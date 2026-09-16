import 'package:skygate/core/constants/sos_assets.dart';

enum SosOption {
  quick('sos_option_quick', 'sos_option_quick_subtitle', SosAssets.quickSos),
  call('sos_option_call', null, SosAssets.call),
  chat('sos_option_chat', 'sos_option_chat_subtitle', SosAssets.chat),
  lostItems(
    'sos_option_lost_items',
    'sos_option_lost_items_subtitle',
    SosAssets.lostItems,
  );

  const SosOption(this.titleKey, this.subtitleKey, this.icon);

  final String titleKey;
  final String? subtitleKey;

  final String icon;
}

class SosContacts {
  SosContacts._();
  static const String emergencyNumber = String.fromEnvironment(
    'SOS_PHONE',
    defaultValue: '+963-09653256',
  );
  static Uri get dialUri => Uri(
    scheme: 'tel',
    path: emergencyNumber.replaceAll(RegExp(r'[^\d+]'), ''),
  );
}

class SosInfoModel {
  const SosInfoModel({required this.icon, required this.titleKey, this.color});

  final String icon;
  final String titleKey;
  final int? color;
  static const List<SosInfoModel> audience = [
    SosInfoModel(icon: SosAssets.tripLeader, titleKey: 'sos_notify_leader'),
    SosInfoModel(
      icon: SosAssets.supervisors,
      titleKey: 'sos_notify_supervisors',
    ),
    SosInfoModel(icon: SosAssets.adminTeam, titleKey: 'sos_notify_admin'),
    SosInfoModel(icon: SosAssets.office, titleKey: 'sos_notify_office'),
  ];
  static const List<SosInfoModel> steps = [
    SosInfoModel(icon: SosAssets.stepLocation, titleKey: 'sos_step_location'),
    SosInfoModel(icon: SosAssets.stepAlert, titleKey: 'sos_step_alert'),
    SosInfoModel(icon: SosAssets.stepContact, titleKey: 'sos_step_contact'),
  ];
}
