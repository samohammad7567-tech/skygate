import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/models/meta_model.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/core/utils/api_parse.dart';
import 'package:skygate/features/vip_trip/models/private_trip_request_model.dart';

part 'vip_requests_state.dart';

class VipRequestsCubit extends Cubit<VipRequestsState> {
  VipRequestsCubit() : super(VipRequestsInitial());

  VipRequestsCubit get(BuildContext context) => BlocProvider.of(context);
  List<PrivateTripRequestModel> requests = const [];
  Meta meta = Meta.empty();
  PrivateTripRequestModel? selected;
  Future<void> getRequests() async {
    emit(VipRequestsLoading());
    try {
      final response = await DioService.get(ApiEndpoints.privateTripRequests);
      requests = ApiParse.rowsOf(
        response.data['data'],
        PrivateTripRequestModel.fromJson,
      );
      meta = Meta.of(
        response.data['meta'] ??
            (response.data['data'] is Map
                ? response.data['data']['meta']
                : null),
      );
      emit(VipRequestsLoaded());
    } catch (error) {
      debugPrint('getRequests error: $error');
      emit(VipRequestsError(message: ApiError.messageOf(error)));
    }
  }

  Future<void> getRequest(PrivateTripRequestModel request) async {
    selected = request;
    final id = request.id;
    if (id == null) {
      emit(VipRequestLoaded());
      return;
    }

    emit(VipRequestLoading());
    try {
      final response = await DioService.get(
        ApiEndpoints.privateTripRequest(id),
      );
      final data = response.data['data'];
      if (data is Map<String, dynamic>) {
        selected = PrivateTripRequestModel.fromJson(data);
      }
      emit(VipRequestLoaded());
    } catch (error) {
      debugPrint('getRequest error: $error');
      emit(VipRequestError(message: ApiError.messageOf(error)));
    }
  }

  Future<void> cancelRequest() async {
    final id = selected?.id;
    if (id == null) {
      emit(VipCancelError(message: ApiError.generic));
      return;
    }

    emit(VipCancelLoading());
    try {
      final response = await DioService.post(
        ApiEndpoints.cancelPrivateTripRequest(id),
      );
      final data = response.data['data'];
      if (data is Map<String, dynamic>) {
        selected = PrivateTripRequestModel.fromJson(data);
      }
      emit(VipCancelled());
      await getRequests();
    } catch (error) {
      debugPrint('cancelRequest error: $error');
      emit(VipCancelError(message: ApiError.messageOf(error)));
    }
  }
}
