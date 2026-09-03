import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sky_gate/app/core/utils/constants/constants.dart';
import 'package:sky_gate/app/core/utils/failures/http/http_failure.dart';
import 'package:sky_gate/app/core/utils/helpers/parse_helpers/failure_parser.dart';
import 'package:sky_gate/app/modules/messages/repositoy/messages_repository.dart';
import 'package:sky_gate/app/modules/my-trips/models/condition_model.dart';
import 'package:sky_gate/app/modules/my-trips/models/trip_model.dart';
import 'package:sky_gate/app/modules/my-trips/repository/accept_trip_conditions_repository.dart';
import 'package:sky_gate/app/modules/my-trips/repository/add_trip_notes_repository.dart';
import 'package:sky_gate/app/modules/my-trips/repository/get_trips_repository.dart';
import 'package:sky_gate/app/routes/app_pages.dart';
import 'package:toastification/toastification.dart';
import '../../../core/utils/failures/base_failure.dart';


enum GetTripsDataStatus {initial, loading, error, success}
enum AcceptTripConditionsStatus {initial, loading, error, success}
enum AddTripNotesStatus {initial, loading, error, success}

class MyTripsController extends GetxController {

  List<TripModel> tripsList = [];

  TextEditingController ticketEditRequestController = TextEditingController();
  TextEditingController tripNotesController = TextEditingController();

  GetTripsDataStatus getTripsDataStatus = GetTripsDataStatus.initial;
  Failure getTripsDataFailure =  const ServerFailure();
  AcceptTripConditionsStatus acceptTripConditionsStatus = AcceptTripConditionsStatus.initial;
  AddTripNotesStatus addTripNotesStatus = AddTripNotesStatus.initial;

  bool sendMsgLoading = false;

  late MessagesRepository messagesRepository;
  late GetTripsRepository getTripsRepository;
  late AcceptTripConditionsRepository acceptTripConditionsRepository;
  late AddTripNotesRepository addTripNotesRepository;

  int clickedCardIndex = -1;
  bool showTicketDetails = false;

  // This is used as argument when navigating to trip conditions page.
  ConditionModel conditions = ConditionModel();
  String conditions_accepted = "0";
  String ticketID = "-2";

  @override
  void onInit() async {
    super.onInit();
    getTripsRepository = GetTripsRepository();
    messagesRepository = MessagesRepository();
    acceptTripConditionsRepository = AcceptTripConditionsRepository();
    addTripNotesRepository = AddTripNotesRepository();
    await getTripsData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }


  Future<void> getTripsData() async {
    getTripsDataStatus = GetTripsDataStatus.loading;
    update();

    (await getTripsRepository.getTrips())
        .fold((left) {
          getTripsDataFailure = left;
      getTripsDataStatus = GetTripsDataStatus.error;
      update();
    }, (right) async {
      if(right.code == "1") {
        getTripsDataStatus = GetTripsDataStatus.success;
        update();
        tripsList = right.data!;
      } else {
        tripsList = [];
        getTripsDataStatus = GetTripsDataStatus.success;
        update();
      }
    });
  }

  Future<void> sendUserMessage({BuildContext? context}) async {
    sendMsgLoading = true;
    update();

    String message = ticketEditRequestController.text;

    (await messagesRepository.sendMessage(
        attach: null,
        msg: message,
        targetTeam: AppConfig.salesTeam.toString()
    ))
        .fold((left) {
      sendMsgLoading = false;
      update();
      String? error = FailureParser.mapFailureToString(failure: left, context: context!);
      toastification.show(
        context: context,
        title: const Text("طلب تعديل/إلغاء الرحلة"),
        description: Text(error),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 8),
      );
    }, (right) async {
      if(right.code == "1") {
        sendMsgLoading = false;
        update();
        toastification.show(
          context: Get.overlayContext,
          title: const Text("طلب تعديل/إلغاء الرحلة"),
          description: Text("لقد تم إرسال طلبك بنجاح. سيتم الرد في أقرب وقت."),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
        Get.back();
      } else {
        sendMsgLoading = false;
        update();
        toastification.show(
          context: context,
          title: const Text("طلب تعديل/إلغاء الرحلة"),
          description: Text(right.message!),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
      }
    });
  }

  void onDetailsBtnClicked({int? index}) {
    if(clickedCardIndex == index) {
      clickedCardIndex = -1;
    } else {
      clickedCardIndex = index!;
    }

    update();
  }

  Future<void> acceptTripConditions({BuildContext? context}) async {
    acceptTripConditionsStatus = AcceptTripConditionsStatus.loading;
    update();

    (await acceptTripConditionsRepository.acceptTripConditions(ticketID: ticketID ))
        .fold((left) {
      acceptTripConditionsStatus = AcceptTripConditionsStatus.success;
      update();
      String? error = FailureParser.mapFailureToString(failure: left, context: context!);
      toastification.show(
        context: context,
        title: const Text("قبول شروط الرحلة"),
        description: Text(error),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 8),
      );
    }, (right) async {
      if(right.code == "1") {
        acceptTripConditionsStatus = AcceptTripConditionsStatus.success;
        update();
        toastification.show(
          context: Get.overlayContext,
          title: const Text("قبول شروط الرحلة"),
          description: Text(right.message!),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
        Get.offAllNamed(Routes.HOME);
      } else {
        acceptTripConditionsStatus = AcceptTripConditionsStatus.success;
        update();
        toastification.show(
          context: context,
          title: const Text("قبول شروط الرحلة"),
          description: Text(right.message!),
          type: ToastificationType.info,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
      }
    });
  }

  Future<void> addTripNotes({BuildContext? context}) async {
    addTripNotesStatus = AddTripNotesStatus.loading;
    update();

    final notes = tripNotesController.text;

    (await addTripNotesRepository.addTripNotes(ticketID: ticketID,notes: notes ))
        .fold((left) {
      addTripNotesStatus = AddTripNotesStatus.success;
      update();
      String? error = FailureParser.mapFailureToString(failure: left, context: context!);
      toastification.show(
        context: context,
        title: const Text("إضافة ملاحظات الرحلة"),
        description: Text(error),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 8),
      );
    }, (right) async {
      if(right.code == "1") {
        addTripNotesStatus = AddTripNotesStatus.success;
        update();
        toastification.show(
          context: Get.overlayContext,
          title: const Text("إضافة ملاحظات الرحلة"),
          description: Text(right.message!),
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
        Get.offAllNamed(Routes.HOME);
      } else {
        addTripNotesStatus = AddTripNotesStatus.success;
        update();
        toastification.show(
          context: context,
          title: const Text("إضافة ملاحظات الرحلة"),
          description: Text(right.message!),
          type: ToastificationType.info,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
      }
    });
  }
}
