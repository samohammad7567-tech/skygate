import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/services/location_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/features/sos/models/sos_event_model.dart';

part 'sos_state.dart';

class SosCubit extends Cubit<SosState> {
  SosCubit() : super(SosInitial());

  SosCubit get(BuildContext context) => BlocProvider.of(context);
  static const Duration holdDuration = Duration(seconds: 3);
  static const Duration _tick = Duration(milliseconds: 50);
  SosEventModel? event;
  double holdProgress = 0;
  bool get isRaised => event != null && event?.resolvedAt == null;

  bool get isHolding => _hold != null;

  Timer? _hold;
  void startHold() {
    if (_hold != null || isRaised) return;

    holdProgress = 0;
    emit(SosHoldStarted());

    _hold = Timer.periodic(_tick, (timer) {
      holdProgress =
          (timer.tick * _tick.inMilliseconds) / holdDuration.inMilliseconds;

      if (holdProgress < 1) {
        emit(SosHoldProgress(progress: holdProgress));
        return;
      }

      holdProgress = 1;
      _stopHold();
      raise();
    });
  }

  void cancelHold() {
    if (_hold == null) return;
    _stopHold();
    holdProgress = 0;
    emit(SosHoldCancelled());
  }

  void _stopHold() {
    _hold?.cancel();
    _hold = null;
  }

  Future<void> raise() async {
    emit(SosSending());

    final access = await LocationService.request();
    if (!access.isGranted) {
      if (!isClosed) {
        emit(SosFailed(message: 'sos_needs_location', access: access));
      }
      return;
    }

    final point = await LocationService.current();
    if (point == null) {
      if (!isClosed) {
        emit(SosFailed(message: 'map_gps_no_fix', access: access));
      }
      return;
    }

    try {
      final response = await DioService.post(
        ApiEndpoints.sosEvents,
        data: SosEventModel.body(
          latitude: point.latitude,
          longitude: point.longitude,
        ),
      );
      final body = response.data['data'];
      event = SosEventModel.fromJson(
        body is Map<String, dynamic> ? body : const {},
      );
      if (!isClosed) emit(SosRaised());
    } catch (error) {
      debugPrint('SosCubit.raise error: $error');
      if (!isClosed) emit(SosFailed(message: ApiError.messageOf(error)));
    }
  }

  Future<void> refreshStatus() async {
    final id = event?.id;
    if (id == null) return;

    try {
      final response = await DioService.get(ApiEndpoints.sosEvent(id));
      final body = response.data['data'];
      event = SosEventModel.fromJson(
        body is Map<String, dynamic> ? body : const {},
      );
      if (!isClosed) emit(SosRaised());
    } catch (error) {
      debugPrint('SosCubit.refreshStatus error: $error');
    }
  }

  @override
  Future<void> close() {
    _stopHold();
    return super.close();
  }
}
