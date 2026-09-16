import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:skygate/tourism/core/utils/constants/constants.dart';
import 'package:skygate/tourism/core/utils/failures/base_failure.dart';
import 'package:skygate/tourism/core/utils/failures/http/http_failure.dart';
import 'package:skygate/tourism/core/utils/helpers/parse_helpers/failure_parser.dart';
import 'package:skygate/tourism/modules/messages/repositoy/messages_repository.dart';
import 'package:toastification/toastification.dart';
import '../../messages/models/chat_message_model.dart';

enum ReadMessagesStatus { initial, error, loading, success }

class SalesSupportController extends GetxController
    with WidgetsBindingObserver {
  final TextEditingController messageController = TextEditingController();
  List<Widget> messages = [];
  final ScrollController scrollController = ScrollController();

  bool sendMsgLoading = false;
  late MessagesRepository messagesRepository;
  ReadMessagesStatus readMessagesStatus = ReadMessagesStatus.initial;
  Failure readMessagesFailure = const ServerFailure();
  double keyboardHeight = 0.0;
  late File? attach;
  bool haveAttach = false;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    messagesRepository = MessagesRepository();
    await readMessages();
  }


  @override
  void didChangeMetrics() {
    final bottomInset =
        WidgetsBinding.instance.platformDispatcher.views.first.viewInsets
            .bottom;
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    keyboardHeight = bottomInset;
    update();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void sendMessage({BuildContext? context}) async {
    if (messageController.text.trim().isEmpty) return;

    await sendUserMessage(context: context);

    messages.add(
      ChatMessage(
        text: messageController.text,
        isMe: true,
        timestamp: DateTime.now(),
        hasAttach: false,
        attachURL: "",
      ),
    );
    messageController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    update();
  }

  Future<void> readMessages() async {
    readMessagesStatus = ReadMessagesStatus.loading;
    update();

    (await messagesRepository.getMessages(
      targetTeam: AppConfig.salesTeam.toString(),
    )).fold(
      (left) {
        readMessagesFailure = left;
        readMessagesStatus = ReadMessagesStatus.error;
        update();
      },
      (right) async {
        if (right.code == "1") {
          for (var element in right.data!) {
            if (element.sender_type == AppConfig.appUserType) {
              messages.add(
                ChatMessage(
                  text: element.message!,
                  isMe: true,
                  timestamp: DateTime.parse(element.created_at!),
                  hasAttach: false,
                  attachURL: element.attach!,
                ),
              );
            }
            if (element.sender_type == AppConfig.adminUserType) {
              messages.add(
                ChatMessage(
                  text: element.message!,
                  isMe: false,
                  timestamp: DateTime.parse(element.created_at!),
                  hasAttach: (element.attach == "") ? false : true,
                  attachURL: element.attach!,
                ),
              );
            }
          }
          readMessagesStatus = ReadMessagesStatus.success;
          update();
        } else {
          messages = [];
          readMessagesStatus = ReadMessagesStatus.success;
          update();
        }
      },
    );
  }

  Future<void> sendUserMessage({BuildContext? context}) async {
    sendMsgLoading = true;
    update();

    String message = messageController.text;

    (await messagesRepository.sendMessage(
      attach: (haveAttach) ? attach : null,
      msg: message,
      targetTeam: AppConfig.salesTeam.toString(),
    )).fold(
      (left) {
        sendMsgLoading = false;
        update();
        String? error = FailureParser.mapFailureToString(
          failure: left,
          context: context!,
        );
        toastification.show(
          context: context,
          title: const Text("محادثة قسم المبيعات"),
          description: Text(error),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 8),
        );
      },
      (right) async {
        if (right.code == "1") {
          sendMsgLoading = false;
          haveAttach = false;
          update();
        } else {
          sendMsgLoading = false;
          update();
          toastification.show(
            context: context,
            title: const Text("محادثة قسم المبيعات"),
            description: Text(right.message!),
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored,
            autoCloseDuration: const Duration(seconds: 8),
          );
        }
      },
    );
  }
}
