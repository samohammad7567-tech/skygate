import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/services/trip_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/core/utils/api_parse.dart';
import 'package:skygate/core/models/activity_model.dart';

part 'activities_state.dart';

class ActivitiesCubit extends Cubit<ActivitiesState> {
  ActivitiesCubit({this.tripId}) : super(ActivitiesInitial());

  ActivitiesCubit get(BuildContext context) => BlocProvider.of(context);
  final int? tripId;

  List<ActivityDayModel> days = [];
  int selectedDayIndex = 0;
  int todayIndex = -1;

  ActivityDayModel? get selectedDay =>
      selectedDayIndex < days.length ? days[selectedDayIndex] : null;
  List<ActivityKind> get legend {
    final kinds = days
        .expand((day) => day.activities)
        .map((activity) => activity.kind)
        .toSet();
    return ActivityKind.values.where(kinds.contains).toList();
  }

  void selectDay(int index) {
    if (selectedDayIndex == index) return;
    selectedDayIndex = index;
    emit(DaySelected());
  }

  Future<void> getActivities({bool refresh = false}) async {
    emit(ActivitiesLoading());
    try {
      days = ActivityDayModel.daysFrom(await _activities(refresh: refresh));
      todayIndex = _findToday();
      if (selectedDayIndex >= days.length) selectedDayIndex = 0;
      emit(ActivitiesLoaded());
    } catch (error) {
      debugPrint('getActivities error: $error');
      emit(ActivitiesError(message: ApiError.messageOf(error)));
    }
  }

  Future<List<TripActivityModel>> _activities({required bool refresh}) async {
    final id = tripId;
    if (id != null) {
      final trip = await TripService.trip(id, refresh: refresh);
      return trip.activities;
    }

    final response = await DioService.get(ApiEndpoints.activities);
    return ApiParse.listOf(response.data['data'], TripActivityModel.fromJson);
  }

  int _findToday() {
    final now = DateTime.now();
    return days.indexWhere(
      (day) =>
          day.date != null &&
          day.date!.year == now.year &&
          day.date!.month == now.month &&
          day.date!.day == now.day,
    );
  }
}
