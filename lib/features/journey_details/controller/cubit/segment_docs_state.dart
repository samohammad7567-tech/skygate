part of 'segment_docs_cubit.dart';

@immutable
sealed class SegmentDocsState {}

final class SegmentDocsInitial extends SegmentDocsState {}

final class SegmentDocsLoading extends SegmentDocsState {}

final class SegmentDocsLoaded extends SegmentDocsState {}

final class SegmentDocsError extends SegmentDocsState {
  SegmentDocsError({required this.message});

  final String message;
}

final class SegmentDocumentOpened extends SegmentDocsState {}

final class SegmentDocumentFailed extends SegmentDocsState {
  SegmentDocumentFailed({required this.message});

  final String message;
}
