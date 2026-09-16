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

class BookingCubit extends Cubit<BookingState> {
  BookingCubit(this.tripId) : super(BookingInitial());

  BookingCubit get(BuildContext context) => BlocProvider.of(context);
  final int tripId;
  static const int totalSteps = 6;
  static const int paymentWindowHours = 24;
  int currentStep = 1;

  void goToStep(int step) {
    if (step == currentStep || step < 1 || step > totalSteps) return;
    currentStep = step;
    emit(BookingStepChanged());
  }

  TripModel? trip;

  Future<TripModel> _loadTrip({bool refresh = false}) async {
    final loaded = await TripService.trip(tripId, refresh: refresh);
    trip = loaded;
    return loaded;
  }

  final List<BookingOptionModel> options = BookingOptionModel.catalogue;
  BookingType selectedType = BookingType.individual;

  void selectType(BookingType type) {
    if (selectedType == type) return;
    selectedType = type;
    emit(BookingTypeSelected());
  }

  final PassportForm passportForm = PassportForm();

  bool get isScanned => passportForm.isScanned;
  bool get pledgeAccepted => passportForm.pledgeAccepted;
  void passportChanged() => emit(PassportFieldChanged());

  void togglePledge(bool? value) {
    passportForm.pledgeAccepted = value ?? false;
    emit(PassportFieldChanged());
  }

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

  void resetScan() {
    passportForm.resetScan();
    emit(PassportFieldChanged());
  }

  final List<UmrahDocumentModel> documentTypes = UmrahDocumentModel.catalogue;
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

  List<BookingRouteModel> routes = [];
  int selectedRouteIndex = 0;

  BookingRouteModel? get selectedRoute =>
      selectedRouteIndex < routes.length ? routes[selectedRouteIndex] : null;

  void selectRoute(int index) {
    if (selectedRouteIndex == index) return;
    selectedRouteIndex = index;
    emit(BookingRoutesLoaded());
  }

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

  final Map<BookingCity, List<HotelModel>> hotels = {};
  final Map<BookingCity, int> selectedHotelIndex = {};
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

  BookingSummaryModel? summary;
  Duration remaining = Duration.zero;

  Timer? _countdown;
  Future<void> getSummary() async {
    emit(BookingSummaryLoading());
    try {
      final loaded = await _loadTrip();
      final room = selectedRoom;
      final schedules = loaded.paymentSchedules;
      final windowHours =
          BookingInstallmentModel.windowHoursOf(schedules) ??
          paymentWindowHours;

      summary = BookingSummaryModel(
        tripTitle: loaded.title,
        routeName: selectedRoute?.name,
        bookingType: selectedType,
        roomType: room?.name,
        makkahHotel: selectedHotelIn(BookingCity.makkah)?.name,
        madinahHotel: selectedHotelIn(BookingCity.madinah)?.name,
        total: room?.adultPrice,
        currency: room?.currency,
        paymentWindowHours: windowHours,
        expiresAt: DateTime.now().add(Duration(hours: windowHours)),
        installments: BookingInstallmentModel.scheduleOf(
          schedules,
          total: room?.adultPrice,
          currency: room?.currency,
        ),
      );
      _startCountdown();
      emit(BookingSummaryLoaded());
    } catch (error) {
      debugPrint('getSummary error: $error');
      emit(BookingSummaryError(message: ApiError.messageOf(error)));
    }
  }

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

  int? pilgrimId;
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

  Future<void> _createPilgrim() async {
    if (pilgrimId != null) return;
    final response = await DioService.post(
      ApiEndpoints.pilgrims,
      data: passportForm.toModel().toPilgrimJson(isSelf: true),
    );
    final created = response.data['data'];
    pilgrimId = created is Map ? created['id'] as int? : null;
  }

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
