import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/core/utils/api_parse.dart';
import 'package:skygate/core/utils/file_opener.dart';
import 'package:skygate/features/cards/models/trip_pilgrim_model.dart';
import 'package:skygate/features/journey_details/models/travel_document_model.dart';

part 'segment_docs_state.dart';

/// The three tabs of "تفاصيل القسم". The first is the segment itself and
/// needs nothing read; the other two are per-pilgrim document lists.
enum SegmentTab { details, visas, tickets }

/// Backs the تأشيرات and تذاكر tabs.
///
/// Both are the trip's documents grouped by pilgrim, so they share one read
/// and one expansion. Without a booking there is nobody to group by — that is
/// the case where the segment was opened from a trip being browsed rather
/// than from one that was booked, and both tabs are legitimately empty.
class SegmentDocsCubit extends Cubit<SegmentDocsState> {
  SegmentDocsCubit({required this.bookingId, required this.segmentId})
    : super(SegmentDocsInitial());

  SegmentDocsCubit get(BuildContext context) => BlocProvider.of(context);

  final int? bookingId;

  /// Tickets are per leg; visas are per trip. Null leaves every ticket in.
  final int? segmentId;

  SegmentTab tab = SegmentTab.details;

  List<TripPilgrimModel> pilgrims = const [];
  Map<int, List<VisaModel>> visas = const {};
  Map<int, List<PilgrimTicketModel>> tickets = const {};

  int? expandedId;
  int? busyDocumentId;

  bool get hasBooking => bookingId != null;

  void changeTab(SegmentTab value) {
    if (tab == value) return;
    tab = value;
    expandedId = null;
    emit(SegmentDocsLoaded());

    // The two document tabs share one read, taken the first time either is
    // opened rather than on every visit to the screen.
    if (value != SegmentTab.details && pilgrims.isEmpty) getDocuments();
  }

  void toggle(TripPilgrimModel pilgrim) {
    final id = pilgrim.id ?? pilgrim.pilgrimId;
    if (id == null) return;

    expandedId = expandedId == id ? null : id;
    emit(SegmentDocsLoaded());
  }

  Future<void> getDocuments({bool refresh = false}) async {
    final booking = bookingId;
    if (booking == null) {
      emit(SegmentDocsLoaded());
      return;
    }
    if (pilgrims.isNotEmpty && !refresh) return;

    emit(SegmentDocsLoading());
    try {
      final results = await Future.wait([
        DioService.get(ApiEndpoints.booking(booking)),
        DioService.get(ApiEndpoints.visas),
        DioService.get(ApiEndpoints.pilgrimTickets),
      ]);

      pilgrims = TripPilgrimModel.rosterOf(results[0].data['data']);
      visas = _group(
        ApiParse.rowsOf(results[1].data['data'], VisaModel.fromJson),
        (visa) => visa.bookingPilgrimId,
      );
      tickets = _group(
        ApiParse.rowsOf(results[2].data['data'], PilgrimTicketModel.fromJson)
            // A ticket naming another leg belongs on that leg's tab.
            .where((t) => segmentId == null || t.segmentId == segmentId)
            .toList(),
        (ticket) => ticket.bookingPilgrimId,
      );
      emit(SegmentDocsLoaded());
    } catch (error) {
      debugPrint('getDocuments error: $error');
      emit(SegmentDocsError(message: ApiError.messageOf(error)));
    }
  }

  Future<void> download({required int documentId, required String? url}) async {
    busyDocumentId = documentId;
    emit(SegmentDocsLoaded());

    final opened = await FileOpener.open(url);
    busyDocumentId = null;
    if (isClosed) return;

    emit(
      opened
          ? SegmentDocumentOpened()
          : SegmentDocumentFailed(message: 'no_file_to_open'),
    );
    emit(SegmentDocsLoaded());
  }

  /// "تحميل كل الملفات" — every file on the tab being shown.
  Future<void> downloadAll() async {
    final urls = tab == SegmentTab.visas
        ? <String>[
            for (final list in visas.values)
              for (final visa in list) ?visa.fileUrl,
          ]
        : <String>[
            for (final list in tickets.values)
              for (final ticket in list) ?ticket.fileUrl,
          ];

    var opened = 0;
    for (final url in urls) {
      if (await FileOpener.open(url)) opened++;
    }
    if (isClosed) return;

    emit(
      opened > 0
          ? SegmentDocumentOpened()
          : SegmentDocumentFailed(message: 'no_file_to_open'),
    );
    emit(SegmentDocsLoaded());
  }

  List<VisaModel> visasOf(TripPilgrimModel pilgrim) =>
      visas[pilgrim.id ?? -1] ?? const [];

  List<PilgrimTicketModel> ticketsOf(TripPilgrimModel pilgrim) =>
      tickets[pilgrim.id ?? -1] ?? const [];

  static Map<int, List<T>> _group<T>(List<T> all, int? Function(T) ownerOf) {
    final grouped = <int, List<T>>{};
    for (final row in all) {
      final owner = ownerOf(row);
      if (owner == null) continue;
      grouped.putIfAbsent(owner, () => []).add(row);
    }
    return grouped;
  }
}
