part of 'lost_items_cubit.dart';

@immutable
sealed class LostItemsState {}

final class LostItemsInitial extends LostItemsState {}

final class LostItemsLoading extends LostItemsState {}

final class LostItemsLoaded extends LostItemsState {}

final class LostItemsError extends LostItemsState {
  LostItemsError({required this.message});

  final String message;
}

final class LostItemFormChanged extends LostItemsState {}

final class LostItemReportSending extends LostItemsState {}

final class LostItemReported extends LostItemsState {}

final class LostItemReportError extends LostItemsState {
  LostItemReportError({required this.message});

  final String message;
}
