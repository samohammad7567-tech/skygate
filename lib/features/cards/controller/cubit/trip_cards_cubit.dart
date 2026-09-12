import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/core/utils/api_parse.dart';
import 'package:skygate/core/utils/file_opener.dart';
import 'package:skygate/features/cards/models/luggage_tag_model.dart';
import 'package:skygate/features/cards/models/pilgrim_card_model.dart';
import 'package:skygate/features/cards/models/trip_pilgrim_model.dart';

part 'trip_cards_state.dart';

enum TripCardsTab { pilgrims, luggage }

class TripCardsCubit extends Cubit<TripCardsState> {
  TripCardsCubit({required this.bookingId}) : super(TripCardsInitial());

  TripCardsCubit get(BuildContext context) => BlocProvider.of(context);

  final int bookingId;

  TripCardsTab tab = TripCardsTab.pilgrims;

  /// Everyone on the booking. Both tabs list the same people and differ only
  /// in what unfolds under a name.
  List<TripPilgrimModel> pilgrims = const [];

  /// Which row is open. Only one at a time, the way the design draws it.
  int? expandedId;

  /// Fetched the first time a row opens, then kept — reopening must not
  /// re-hit the network, and the preview sheet reads the same object.
  final Map<int, PilgrimCardModel> cards = {};
  final Map<int, String> cardErrors = {};
  final Set<int> loadingCards = {};

  /// Keyed by `booking_pilgrim_id`; a pilgrim may carry several bags.
  Map<int, List<LuggageTagModel>> tags = const {};

  /// Whose file is being handed to the system right now, so only that button
  /// spins while it happens.
  int? busyDocumentId;

  void changeTab(TripCardsTab value) {
    if (tab == value) return;
    tab = value;
    expandedId = null;
    emit(TripCardsLoaded());
  }

  void toggle(TripPilgrimModel pilgrim) {
    final id = pilgrim.id ?? pilgrim.pilgrimId;
    if (id == null) return;

    if (expandedId == id) {
      expandedId = null;
      emit(TripCardsLoaded());
      return;
    }

    expandedId = id;
    emit(TripCardsLoaded());
    // Luggage tags arrive with the list; a pilgrim's card does not, so it is
    // read the moment the row that shows it opens.
    if (tab == TripCardsTab.pilgrims) getCard(pilgrim);
  }

  Future<void> getCards({bool refresh = false}) async {
    emit(TripCardsLoading());
    try {
      final results = await Future.wait([
        DioService.get(ApiEndpoints.booking(bookingId)),
        DioService.get(ApiEndpoints.luggageTags),
      ]);

      pilgrims = TripPilgrimModel.rosterOf(results[0].data['data']);
      tags = _groupTags(
        ApiParse.rowsOf(results[1].data['data'], LuggageTagModel.fromJson),
      );
      if (refresh) {
        cards.clear();
        cardErrors.clear();
      }
      emit(TripCardsLoaded());
    } catch (error) {
      debugPrint('getCards error: $error');
      emit(TripCardsError(message: ApiError.messageOf(error)));
    }
  }

  /// Reads one pilgrim's card face. A failure is held against that row rather
  /// than emitted as a screen error — the other rows are still good.
  Future<void> getCard(TripPilgrimModel pilgrim) async {
    final rowId = pilgrim.id ?? pilgrim.pilgrimId;
    final personId = pilgrim.pilgrimId ?? pilgrim.id;
    if (rowId == null || personId == null) return;
    if (cards.containsKey(rowId) || loadingCards.contains(rowId)) return;

    loadingCards.add(rowId);
    cardErrors.remove(rowId);
    emit(TripCardsLoaded());

    try {
      final response = await DioService.get(
        ApiEndpoints.pilgrimIdCard(personId),
      );
      final body = response.data['data'];
      cards[rowId] = PilgrimCardModel.fromJson(
        body is Map<String, dynamic> ? body : const {},
      );
    } catch (error) {
      debugPrint('getCard($personId) error: $error');
      cardErrors[rowId] = ApiError.messageOf(error);
    } finally {
      loadingCards.remove(rowId);
      if (!isClosed) emit(TripCardsLoaded());
    }
  }

  /// Hands one document's file to the system. [documentId] only decides which
  /// button spins while it happens.
  Future<void> download({required int documentId, required String? url}) async {
    busyDocumentId = documentId;
    emit(TripCardsLoaded());

    final opened = await FileOpener.open(url);
    busyDocumentId = null;
    if (isClosed) return;

    _report(opened);
  }

  /// "تحميل كل الملفات" — every card's PDF, or every tag's, depending on
  /// which tab is showing.
  Future<void> downloadAll() async {
    final urls = tab == TripCardsTab.pilgrims
        ? <String>[for (final card in cards.values) ?card.fileUrl]
        : <String>[
            for (final list in tags.values)
              for (final tag in list) ?tag.fileUrl,
          ];

    if (urls.isEmpty) {
      _report(false);
      return;
    }

    var opened = 0;
    for (final url in urls) {
      if (await FileOpener.open(url)) opened++;
    }
    if (isClosed) return;

    _report(opened > 0);
  }

  List<LuggageTagModel> tagsOf(TripPilgrimModel pilgrim) =>
      tags[pilgrim.id ?? -1] ?? const [];

  /// The one-shot signal the toast listens for, followed straight back to the
  /// resting state so the screen keeps rebuilding from the same fields.
  void _report(bool opened) {
    emit(
      opened ? DocumentOpened() : DocumentFailed(message: 'no_file_to_open'),
    );
    emit(TripCardsLoaded());
  }

  static Map<int, List<LuggageTagModel>> _groupTags(List<LuggageTagModel> all) {
    final grouped = <int, List<LuggageTagModel>>{};
    for (final tag in all) {
      final owner = tag.bookingPilgrimId;
      if (owner == null) continue;
      grouped.putIfAbsent(owner, () => []).add(tag);
    }
    return grouped;
  }
}
