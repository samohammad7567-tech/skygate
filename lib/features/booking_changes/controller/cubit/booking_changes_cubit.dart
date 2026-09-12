import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/models/meta_model.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/core/utils/api_parse.dart';
import 'package:skygate/features/booking_changes/models/booking_change_request_model.dart';

part 'booking_changes_state.dart';

class BookingChangesCubit extends Cubit<BookingChangesState> {
  BookingChangesCubit() : super(BookingChangesInitial());

  BookingChangesCubit get(BuildContext context) => BlocProvider.of(context);

  List<BookingChangeRequestModel> requests = const [];
  Meta meta = Meta.empty();

  /// The row the details screen reads. Seeded from the list so the screen
  /// paints immediately, then replaced by the single-request response.
  BookingChangeRequestModel? selected;

  Future<void> getRequests() async {
    emit(BookingChangesLoading());
    try {
      final response = await DioService.get(ApiEndpoints.bookingChangeRequests);
      requests = ApiParse.rowsOf(
        response.data['data'],
        BookingChangeRequestModel.fromJson,
      );
      meta = Meta.of(
        response.data['meta'] ??
            (response.data['data'] is Map
                ? response.data['data']['meta']
                : null),
      );
      emit(BookingChangesLoaded());
    } catch (error) {
      debugPrint('getRequests error: $error');
      emit(BookingChangesError(message: ApiError.messageOf(error)));
    }
  }

  Future<void> getRequest(BookingChangeRequestModel request) async {
    selected = request;
    final id = request.id;
    if (id == null) {
      emit(BookingChangeLoaded());
      return;
    }

    emit(BookingChangeLoading());
    try {
      final response = await DioService.get(
        ApiEndpoints.bookingChangeRequest(id),
      );
      final data = response.data['data'];
      if (data is Map<String, dynamic>) {
        selected = BookingChangeRequestModel.fromJson(data);
      }
      emit(BookingChangeLoaded());
    } catch (error) {
      debugPrint('getRequest error: $error');
      emit(BookingChangeError(message: ApiError.messageOf(error)));
    }
  }
}
