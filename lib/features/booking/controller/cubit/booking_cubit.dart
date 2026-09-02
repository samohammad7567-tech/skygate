import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/models/booking_type.dart';
import 'package:skygate/core/models/hotel_model.dart';
import 'package:skygate/core/models/passport_data_model.dart';
import 'package:skygate/core/models/passport_form.dart';
import 'package:skygate/core/models/trip_model.dart';
import 'package:skygate/core/models/umrah_document_model.dart';
import 'package:skygate/core/services/dio_service.dart';
import 'package:skygate/core/services/image_picker_service.dart';
import 'package:skygate/core/services/trip_service.dart';
import 'package:skygate/core/utils/api_error.dart';
import 'package:skygate/core/models/booking_city.dart';
import 'package:skygate/features/booking/models/booking_option_model.dart';
import 'package:skygate/core/models/booking_route_model.dart';
import 'package:skygate/features/booking/models/booking_summary_model.dart';
import 'package:skygate/features/booking/models/room_type_model.dart';

part 'booking_state.dart';

/// Drives the whole six-step booking wizard, so the same instance is handed
/// down to every screen after "إبدأ عملية الحجز" with `BlocProvider.value`.
///
/// Every screen reads its data from the public fields here; the states only
/// signal transitions.
///
/// Steps 3 to 6 are all slices of one call — `GET app/trips/{id}` — kept by
/// [TripService] between them. Submitting walks the documented contract:
/// `POST app/pilgrims` creates the traveller, `POST app/bookings` seats them
/// in a room of the package they picked, and `POST app/pilgrim-documents`
/// attaches their files.
class BookingCubit extends Cubit<BookingState> {
  BookingCubit(this.tripId) : super(BookingInitial());

  BookingCubit get(BuildContext context) => BlocProvider.of(context);

  /// The trip being booked — it keys the routes, the packages and the hotels.
  final int tripId;

  /// Steps printed by the progress card.
  static const int totalSteps = 6;

  /// Hours the hold on the booking lasts.
  static const int paymentWindowHours = 24;

  /// 1-based index of the step being shown.
  int currentStep = 1;

  void goToStep(int step) {
    if (step == currentStep || step < 1 || step > totalSteps) return;
    currentStep = step;
    emit(BookingStepChanged());
  }

  /// The trip behind every step from the route onwards.
  TripModel? trip;

  Future<TripModel> _loadTrip({bool refresh = false}) async {
    final loaded = await TripService.trip(tripId, refresh: refresh);
    trip = loaded;
    return loaded;
  }

  // ── Step 1 — booking type ────────────────────────────────────────────────
  /// The two cards are fixed design content.
  final List<BookingOptionModel> options = BookingOptionModel.catalogue;

  /// Pre-selected, matching the mockup where "حجز فردي فقط" starts ticked.
  BookingType selectedType = BookingType.individual;

  void selectType(BookingType type) {
    if (selectedType == type) return;
    selectedType = type;
    emit(BookingTypeSelected());
  }

  // ── Step 2 — passport ────────────────────────────────────────────────────
  /// The ten passport rows, shared with the signup wizard.
  final PassportForm passportForm = PassportForm();

  bool get isScanned => passportForm.isScanned;
  bool get pledgeAccepted => passportForm.pledgeAccepted;

  /// Rebuilds the card after `PassportFieldsForm` wrote into [passportForm].
  void passportChanged() => emit(PassportFieldChanged());

  void togglePledge(bool? value) {
    passportForm.pledgeAccepted = value ?? false;
    emit(PassportFieldChanged());
  }

  /// Picks the passport photo, then hands it to [scanPassport].
  Future<void> scanPassportFrom(ImageSource source) async {
    final file = await ImagePickerService.pick(source);
    if (file == null) {
      emit(PassportScanCancelled());
      return;
    }
    if (!await ImagePickerService.isWithinSizeLimit(file)) {
      emit(FileTooLarge());
      return;
    }
    await scanPassport(file);
  }

  /// Uploads the passport photo and fills the confirmation screen from the MRZ
  /// the API reads back.
  Future<void> scanPassport(File image) async {
    emit(PassportScanLoading());
    return DioService.post(
          ApiEndpoints.scanPassport,
          data: FormData.fromMap({
            'passport_image': await MultipartFile.fromFile(image.path),
          }),
        )
        .then((response) {
          final body = response.data['data'];
          passportForm.fillFrom(
            PassportDataModel.fromJson(
              body is Map<String, dynamic> ? body : const {},
            ),
          );
          passportForm.isScanned = true;
          emit(PassportScanned());
        })
        .catchError((error) {
          debugPrint('scanPassport error: $error');
          emit(PassportScanError(message: ApiError.messageOf(error)));
        });
  }

  /// Clears the scan result so the user lands back on an empty scanner.
  void resetScan() {
    passportForm.resetScan();
    emit(PassportFieldChanged());
  }

  // ── Step 2 — attached documents ──────────────────────────────────────────
  final List<UmrahDocumentModel> documentTypes = UmrahDocumentModel.catalogue;

  /// Attached file per [UmrahDocumentModel.id].
  final Map<String, File> documents = {};

  Future<void> pickDocument(String id, ImageSource source) async {
    final file = await ImagePickerService.pick(source);
    if (file == null) return;
    if (!await ImagePickerService.isWithinSizeLimit(file)) {
      emit(FileTooLarge());
      return;
    }
    documents[id] = file;
    emit(DocumentPicked());
  }

  void removeDocument(String id) {
    documents.remove(id);
    emit(DocumentPicked());
  }

  // ── Step 3 — route ───────────────────────────────────────────────────────
  List<BookingRouteModel> routes = [];

  /// Index of the ticked route card; the first one in the design.
  int selectedRouteIndex = 0;

  BookingRouteModel? get selectedRoute =>
      selectedRouteIndex < routes.length ? routes[selectedRouteIndex] : null;

  void selectRoute(int index) {
    if (selectedRouteIndex == index) return;
    selectedRouteIndex = index;
    emit(BookingRoutesLoaded());
  }

  /// The trip's itinerary as the one route it offers.
  Future<void> getRoutes() async {
    emit(BookingRoutesLoading());
    try {
      final loaded = await _loadTrip();
      routes = loaded.itinerary.isEmpty
          ? []
          : [BookingRouteModel.fromTrip(loaded)];
      if (selectedRouteIndex >= routes.length) selectedRouteIndex = 0;
      emit(BookingRoutesLoaded());
    } catch (error) {
      debugPrint('getRoutes error: $error');
      emit(BookingRoutesError(message: ApiError.messageOf(error)));
    }
  }

  // ── Step 4 — room type ───────────────────────────────────────────────────
  /// One card per package the trip sells — the room type at its adult rate.
  List<RoomTypeModel> roomTypes = [];

  int selectedRoomIndex = 0;

  RoomTypeModel? get selectedRoom => selectedRoomIndex < roomTypes.length
      ? roomTypes[selectedRoomIndex]
      : null;

  void selectRoom(int index) {
    if (selectedRoomIndex == index) return;
    selectedRoomIndex = index;
    emit(RoomTypesLoaded());
  }

  Future<void> getRoomTypes() async {
    emit(RoomTypesLoading());
    try {
      final loaded = await _loadTrip();
      roomTypes = [
        for (final package in loaded.packages)
          RoomTypeModel.fromPackage(package),
      ];
      if (selectedRoomIndex >= roomTypes.length) selectedRoomIndex = 0;
      emit(RoomTypesLoaded());
    } catch (error) {
      debugPrint('getRoomTypes error: $error');
      emit(RoomTypesError(message: ApiError.messageOf(error)));
    }
  }

  // ── Step 5 — one hotel per city ──────────────────────────────────────────
  /// Hotels offered in each city, keyed by [BookingCity].
  final Map<BookingCity, List<HotelModel>> hotels = {};

  /// The ticked hotel per city.
  final Map<BookingCity, int> selectedHotelIndex = {};

  /// Nights the trip stays in each city, printed next to its name.
  final Map<BookingCity, int> stayDays = {};

  List<HotelModel> hotelsIn(BookingCity city) => hotels[city] ?? const [];

  int selectedHotelIndexIn(BookingCity city) => selectedHotelIndex[city] ?? 0;

  HotelModel? selectedHotelIn(BookingCity city) {
    final list = hotelsIn(city);
    final index = selectedHotelIndexIn(city);
    return index < list.length ? list[index] : null;
  }

  void selectHotel(BookingCity city, int index) {
    if (selectedHotelIndex[city] == index) return;
    selectedHotelIndex[city] = index;
    emit(BookingHotelsLoaded());
  }

  /// The trip's hotels in [city]. The endpoint takes no `city` filter, so the
  /// list is sorted into the two steps here.
  Future<void> getHotels(BookingCity city) async {
    emit(BookingHotelsLoading());
    try {
      final loaded = await _loadTrip();
      final inCity = [
        for (final hotel in loaded.hotels)
          if (city.matches(hotel.city)) hotel,
      ];

      hotels[city] = [
        for (final hotel in inCity) HotelModel.fromTripHotel(hotel),
      ];
      stayDays[city] = inCity.fold(
        0,
        (sum, hotel) => sum + (hotel.nights ?? 0),
      );
      emit(BookingHotelsLoaded());
    } catch (error) {
      debugPrint('getHotels ${city.slug} error: $error');
      emit(BookingHotelsError(message: ApiError.messageOf(error)));
    }
  }

  // ── Step 6 — summary ─────────────────────────────────────────────────────
  BookingSummaryModel? summary;

  /// Time left on the hold, refreshed once a second by [_countdown].
  Duration remaining = Duration.zero;

  Timer? _countdown;

  /// Builds "ملخص الحجز" from what the wizard already holds.
  ///
  /// Nothing is posted: the API publishes no priced summary for the
  /// `trip_id` + `rooms[]` contract, so the review adds up the package the
  /// room type came from — one adult, the traveller booking — and starts the
  /// hold clock the design counts down.
  Future<void> getSummary() async {
    emit(BookingSummaryLoading());
    try {
      final loaded = await _loadTrip();
      final room = selectedRoom;

      summary = BookingSummaryModel(
        tripTitle: loaded.title,
        routeName: selectedRoute?.name,
        bookingType: selectedType,
        roomType: room?.name,
        makkahHotel: selectedHotelIn(BookingCity.makkah)?.name,
        madinahHotel: selectedHotelIn(BookingCity.madinah)?.name,
        total: room?.adultPrice,
        currency: room?.currency,
        paymentWindowHours: paymentWindowHours,
        expiresAt: DateTime.now().add(
          const Duration(hours: paymentWindowHours),
        ),
      );
      _startCountdown();
      emit(BookingSummaryLoaded());
    } catch (error) {
      debugPrint('getSummary error: $error');
      emit(BookingSummaryError(message: ApiError.messageOf(error)));
    }
  }

  /// Ticks the "أكمل الدفع خلال (24 ساعة)" clock down to the hold's expiry.
  void _startCountdown() {
    _countdown?.cancel();
    remaining = _timeLeft();
    if (remaining == Duration.zero) return;

    _countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining = _timeLeft();
      if (remaining == Duration.zero) timer.cancel();
      emit(BookingCountdownTicked());
    });
  }

  Duration _timeLeft() {
    final expiry =
        summary?.expiresAt ??
        DateTime.now().add(Duration(hours: summary?.paymentWindowHours ?? 24));
    final left = expiry.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  // ── Submit ───────────────────────────────────────────────────────────────
  /// Backend id of the traveller, kept so a retry after a failed booking does
  /// not create them twice.
  int? pilgrimId;

  /// Creates the pilgrim, then the booking that seats them, then uploads
  /// whatever documents were attached.
  ///
  /// A failed document upload does not fail the booking — the pilgrim can
  /// retry from their profile later.
  Future<void> submit() async {
    emit(BookingSubmitLoading());
    try {
      await _createPilgrim();
      await DioService.post(ApiEndpoints.bookings, data: bookingBody());
      await _uploadDocuments();
      emit(BookingSubmitted());
    } catch (error) {
      debugPrint('submit booking error: $error');
      emit(BookingSubmitError(message: ApiError.messageOf(error)));
    }
  }

  /// `POST app/pilgrims` — the passport the wizard collected, as the account
  /// holder's own pilgrim record.
  Future<void> _createPilgrim() async {
    if (pilgrimId != null) return;

    final response = await DioService.post(
      ApiEndpoints.pilgrims,
      data: FormData.fromMap(
        passportForm.toModel().toPilgrimJson(isSelf: true),
      ),
    );
    final created = response.data['data'];
    pilgrimId = created is Map ? created['id'] as int? : null;
  }

  /// The `POST app/bookings` body.
  ///
  /// `trip_id` and `rooms[]` are the documented contract; an individual
  /// booking is one room holding one pilgrim, priced by the package the room
  /// type came from. The hotels the wizard collected have no home in it yet —
  /// they are sent anyway so the choice is not dropped on the floor once the
  /// backend starts accepting them.
  Map<String, dynamic> bookingBody() => {
    'trip_id': tripId,
    'rooms': [
      {
        'package_id': selectedRoom?.id,
        'locked_beds_count': 0,
        'hotels': {
          for (final city in BookingCity.values)
            if (selectedHotelIn(city)?.id != null)
              city.slug: selectedHotelIn(city)!.id,
        },
        'pilgrims': [
          if (pilgrimId != null) {'pilgrim_id': pilgrimId},
        ],
      },
    ],
  };

  /// `POST app/pilgrim-documents`, one call per attached file.
  ///
  /// The endpoint keys the document by a numeric `document_type_id`, and the
  /// design only ever names one — there is no document-types lookup in the
  /// OpenAPI document to translate between them — so the slug goes out as
  /// `document_type` until one exists.
  Future<void> _uploadDocuments() async {
    if (documents.isEmpty || pilgrimId == null) return;

    for (final entry in documents.entries) {
      try {
        await DioService.post(
          ApiEndpoints.uploadDocument,
          data: FormData.fromMap({
            'pilgrim_id': pilgrimId,
            'document_type': entry.key,
            'file': await MultipartFile.fromFile(entry.value.path),
          }),
        );
      } catch (error) {
        debugPrint('uploadDocument ${entry.key} error: $error');
      }
    }
  }

  @override
  Future<void> close() {
    _countdown?.cancel();
    passportForm.dispose();
    return super.close();
  }
}
