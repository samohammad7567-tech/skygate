import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_sheet.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/core/utils/app_scale.dart';

/// The two languages the app ships, keyed by the code EasyLocalization and
/// the `X-localization` header both speak.
const Map<String, String> settingsLanguages = {
  'ar': 'settings_language_arabic',
  'en': 'settings_language_english',
};

/// Asks which language to display the app in. Answers with the chosen code,
/// or null if the reader dismissed the sheet.
Future<String?> showSettingsLanguageSheet(
  BuildContext context, {
  required String current,
}) {
  return showAppSheet<String>(
    context,
    isScrollControlled: false,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(10.s),
          const SheetHandle(),
          Gap(14.s),
          Text(
            'change-language'.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(sheetContext).textTheme.titleLarge,
          ),
          Gap(6.s),
          for (final entry in settingsLanguages.entries)
            _Option(
              code: entry.key,
              labelKey: entry.value,
              isSelected: entry.key == current,
            ),
          Gap(8.s),
        ],
      ),
    ),
  );
}

class _Option extends StatelessWidget {
  const _Option({
    required this.code,
    required this.labelKey,
    required this.isSelected,
  });

  final String code;
  final String labelKey;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      title: Text(labelKey.tr(), style: theme.textTheme.titleSmall),
      trailing: isSelected
          ? Icon(Icons.check_rounded, color: theme.colorScheme.primary)
          : null,
      onTap: () => Navigator.of(context).pop(code),
    );
  }
}
