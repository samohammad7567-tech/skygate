import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_list_card.dart';
import 'package:skygate/core/components/coming_soon_view.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/constants/settings_assets.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/settings/widgets/settings_tile.dart';
import 'package:skygate/features/sos/controller/cubit/support_chat_cubit.dart';
import 'package:skygate/features/sos/models/sos_option_model.dart';
import 'package:skygate/features/sos/views/support_chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsSupportSection extends StatelessWidget {
  const SettingsSupportSection({super.key});

  void _openChat(BuildContext context) {
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider(
        create: (_) => SupportChatCubit()..openChat(),
        child: const SupportChatScreen(),
      ),
    );
  }

  Future<void> _call(BuildContext context) async {
    final launched = await launchUrl(SosContacts.dialUri);
    if (!launched && context.mounted) {
      showToast(context, 'sos_call_failed'.tr(), isError: true);
    }
  }

  void _openSoon(BuildContext context, String titleKey) {
    NaivgatorHelper.pushNavigation(context, ComingSoonView(titleKey: titleKey));
  }

  @override
  Widget build(BuildContext context) {
    return AppListCard(
      children: [
        SettingsTile(
          icon: SettingsAssets.chat,
          title: 'settings_chat_title'.tr(),
          subtitle: 'settings_chat_desc'.tr(),
          onTap: () => _openChat(context),
        ),
        SettingsTile(
          icon: SettingsAssets.call,
          title: 'settings_call_title'.tr(),
          subtitle: SosContacts.emergencyNumber,
          onTap: () => _call(context),
        ),
        SettingsTile(
          icon: SettingsAssets.faq,
          title: 'settings_faq_title'.tr(),
          subtitle: 'settings_faq_desc'.tr(),
          onTap: () => _openSoon(context, 'settings_faq_title'),
        ),
        SettingsTile(
          icon: SettingsAssets.report,
          title: 'settings_report_title'.tr(),
          subtitle: 'settings_report_desc'.tr(),
          onTap: () => _openSoon(context, 'settings_report_title'),
        ),
      ],
    );
  }
}
