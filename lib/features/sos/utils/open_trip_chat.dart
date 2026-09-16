import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/sos/controller/cubit/support_chat_cubit.dart';
import 'package:skygate/features/sos/views/support_chat_screen.dart';

/// Pushes the trip group chat with its own cubit.
///
/// Shared so the map can reach it too: leaving the safe area is exactly when a
/// pilgrim needs to say "I am here, I am late" in one tap.
Future<void> openTripChat(BuildContext context) =>
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider(
        create: (_) => SupportChatCubit()..openChat(),
        child: const SupportChatScreen(),
      ),
    );
