import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/features/journey_details/models/activity_model.dart';

part 'activities_state.dart';

/// Owns "تفاصيل الأنشطة" — the day tabs and the timeline of the selected day.
///
/// `GET app/activities` answers with the programme of the pilgrim's own trip
/// as one flat list and takes no trip parameter, so the days are cut from the
/// activity dates here.
class ActivitiesCubit extends Cubit<ActivitiesState> {
  ActivitiesCubit() : super(ActivitiesInitial());

  ActivitiesCubit get(BuildContext context) => BlocProvider.of(context);

  List<ActivityDayModel> days = [];

  /// Index of the filled day tab.
  int selectedDayIndex = 0;

  /// Day the trip is on right now; its tab is outlined and carries a dot.
  int todayIndex = -1;

  ActivityDayModel? get selectedDay =>
      selectedDayIndex < days.length ? days[selectedDayIndex] : null;

  /// Every kind present in the programme, for the legend bar. Ordered by the
  /// enum so the chips keep a stable position between days.
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

  Future<void> getActivities() async {
    emit(ActivitiesLoading());
    return DioService.get(ApiEndpoints.activities)
        .then((response) {
          days = ActivityDayModel.daysFrom(response.data['data'] as List? ?? []);
          todayIndex = _findToday();
          if (selectedDayIndex >= days.length) selectedDayIndex = 0;
          emit(ActivitiesLoaded());
        })
        .catchError((error) {
          debugPrint('getActivities error: $error');
          emit(ActivitiesError(message: ApiError.messageOf(error)));
        });
  }

  /// Index of the day whose date falls on today, or `-1` when the trip has not
  /// started yet.
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
