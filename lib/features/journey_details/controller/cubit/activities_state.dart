part of 'activities_cubit.dart';

@immutable
sealed class ActivitiesState {}

final class ActivitiesInitial extends ActivitiesState {}

final class ActivitiesLoading extends ActivitiesState {}

final class ActivitiesLoaded extends ActivitiesState {}

final class DaySelected extends ActivitiesState {}

final class ActivitiesError extends ActivitiesState {
  final String message;

  ActivitiesError({required this.message});
}

final class AttendanceConfirmed extends ActivitiesState {}

final class FeedbackSubmitted extends ActivitiesState {}

final class ActivityActionFailed extends ActivitiesState {
  ActivityActionFailed({required this.message});

  final String message;
}
