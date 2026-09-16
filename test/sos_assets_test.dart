import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:skygate/core/constants/sos_assets.dart';
import 'package:skygate/features/sos/models/lost_item_model.dart';
import 'package:skygate/features/sos/models/sos_option_model.dart';

const List<String> _screenKeys = [
  'sos',
  'sos_online',
  'sos_online_now',
  'sos_offline',
  'sos_call_failed',
  'sos_system_title',
  'sos_system_desc',
  'sos_hold_hint',
  'sos_raised_short',
  'sos_sent',
  'sos_needs_location',
  'sos_notify_title',
  'sos_notify_desc',
  'sos_steps_title',
  'sos_keep_location_on',
  'sos_chat_title',
  'sos_chat_bot_title',
  'sos_chat_bot_desc',
  'sos_chat_hint',
  'sos_chat_attach',
  'sos_chat_voice',
  'sos_chat_unavailable',
  'sos_chat_empty',
  'lost_items_title',
  'lost_public_note',
  'lost_items_count',
  'lost_handled_by',
  'lost_status_all',
  'lost_empty',
  'lost_details_title',
  'lost_action_mark_found',
  'lost_action_collect',
  'lost_no_action',
  'close',
  'lost_report_title',
  'lost_report_action',
  'lost_report_note',
  'lost_field_description',
  'lost_hint_description',
  'lost_description_required',
  'lost_field_photo',
  'lost_add_photo',
  'lost_field_place',
  'lost_place_example',
  'lost_hint_place',
  'lost_field_time',
  'lost_hint_time',
  'lost_field_notes',
  'lost_hint_notes',
  'lost_submit',
  'lost_report_sent',
];

Map<String, dynamic> _translations(String language) =>
    jsonDecode(File('assets/lang/$language.json').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  test('every SosAssets path exists on disk', () {
    final missing = SosAssets.all
        .where((path) => !File(path).existsSync())
        .toList();
    expect(missing, isEmpty, reason: 'Missing asset files: $missing');
  });

  test('SosAssets.all has no duplicates', () {
    expect(SosAssets.all.toSet().length, SosAssets.all.length);
  });

  test('every sheet option resolves its glyph', () {
    for (final option in SosOption.values) {
      expect(
        File(option.icon).existsSync(),
        isTrue,
        reason: 'missing ${option.icon}',
      );
    }
  });

  test('every SOS key is translated in both languages', () {
    final keys = <String>[
      ..._screenKeys,
      for (final option in SosOption.values) ...[
        option.titleKey,
        ?option.subtitleKey,
      ],
      for (final party in SosInfoModel.audience) party.titleKey,
      for (final step in SosInfoModel.steps) step.titleKey,
      for (final status in LostItemStatus.values) status.labelKey,
    ];

    for (final language in ['ar', 'en']) {
      final translations = _translations(language);
      final missing = keys.where((key) => !translations.containsKey(key));
      expect(missing, isEmpty, reason: 'missing $language keys: $missing');
    }
  });

  test('lost item statuses read back from the words the API uses', () {
    expect(LostItemStatus.fromApi('reported'), LostItemStatus.reported);
    expect(LostItemStatus.fromApi(['found']), LostItemStatus.found);
    expect(LostItemStatus.fromApi('تم التسليم'), LostItemStatus.returned);
    expect(LostItemStatus.fromApi('closed'), LostItemStatus.closed);
    expect(LostItemStatus.fromApi('who knows'), LostItemStatus.reported);
    expect(LostItemStatus.fromApi(null), LostItemStatus.reported);
  });

  test('the emergency number dials as digits only', () {
    expect(SosContacts.dialUri.scheme, 'tel');
    expect(SosContacts.dialUri.path, matches(r'^\+?\d+$'));
  });

  test('a lost item falls back to a bundled cover when it has no photo', () {
    final item = LostItemModel.fromJson({'id': 7, 'item_name': 'حقيبة'});
    expect(item.photo, isNull);
    expect(SosAssets.itemPhotoFallbacks, contains(item.fallbackPhoto));
    expect(File(item.fallbackPhoto).existsSync(), isTrue);
  });
}
