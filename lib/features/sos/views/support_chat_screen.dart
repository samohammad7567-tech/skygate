import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/sos/controller/cubit/support_chat_cubit.dart';
import 'package:skygate/features/sos/widgets/chat_bubble.dart';
import 'package:skygate/features/sos/widgets/chat_composer.dart';
import 'package:skygate/features/sos/widgets/chat_header.dart';
import 'package:skygate/features/sos/widgets/sos_note_banner.dart';

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scroll.position.pixels <= 80) {
      context.read<SupportChatCubit>().loadOlder();
    }
  }

  void _scrollToLatest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<SupportChatCubit, SupportChatState>(
          listener: (context, state) {
            if (state is SupportChatError) {
              showToast(context, state.message.tr(), isError: true);
            } else if (state is SupportChatLoaded) {
              _scrollToLatest();
            }
          },
          builder: (context, state) {
            final cubit = context.read<SupportChatCubit>();

            return Column(
              children: [
                ChatHeader(isOnline: cubit.isOnline),
                Expanded(child: _thread(context, state, cubit)),
                ChatComposer(
                  controller: cubit.composer,
                  onSend: cubit.send,
                  onUnavailable: () =>
                      showToast(context, 'sos_chat_unavailable'.tr()),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _thread(
    BuildContext context,
    SupportChatState state,
    SupportChatCubit cubit,
  ) {
    if (state is SupportChatLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return BuildCondition(
      condition: cubit.messages.isNotEmpty,
      builder: (_) => ListView.builder(
        controller: _scroll,
        padding: EdgeInsets.only(top: 12.s, bottom: 12.s),
        // One extra row at the top: the standing notice, and the spinner while
        // an older page is on its way.
        itemCount: cubit.messages.length + 1,
        itemBuilder: (_, index) => index == 0
            ? _Header(isLoadingMore: cubit.isLoadingMore)
            : ChatBubble(message: cubit.messages[index - 1]),
      ),
      fallback: (_) => EmptyState(
        message: state is SupportChatError
            ? state.message.tr()
            : 'sos_chat_empty'.tr(),
        onRetry: cubit.openChat,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isLoadingMore});

  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoadingMore)
          Padding(
            padding: EdgeInsets.only(bottom: 12.s),
            child: SizedBox(
              height: 20.s,
              width: 20.s,
              child: CircularProgressIndicator(strokeWidth: 2.s),
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.s),
          child: SosNoteBanner(
            titleKey: 'sos_chat_bot_title',
            messageKey: 'sos_chat_bot_desc',
          ),
        ),
        Gap(8.s),
      ],
    );
  }
}
