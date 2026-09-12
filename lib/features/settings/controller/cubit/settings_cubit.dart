import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/services/language_service.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/settings/models/settings_toggle.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  SettingsCubit get(BuildContext context) => BlocProvider.of(context);

  final Map<SettingsToggle, bool> _toggles = {};

  /// The language the app is displayed in — `ar` or `en`. Read back from the
  /// same store the API header is seeded from, so the row never disagrees
  /// with what the server is being asked in.
  String language = LanguageService.current;

  bool isOn(SettingsToggle toggle) =>
      _toggles[toggle] ?? _restore(toggle) ?? toggle.byDefault;

  bool? _restore(SettingsToggle toggle) {
    final stored = CacheUtil.get(key: toggle.cacheKey);
    if (stored is! bool) return null;
    _toggles[toggle] = stored;
    return stored;
  }

  void loadSettings() {
    for (final toggle in SettingsToggle.values) {
      _toggles[toggle] = _restore(toggle) ?? toggle.byDefault;
    }
    language = LanguageService.current;
    emit(SettingsLoaded());
  }

  Future<void> toggle(SettingsToggle toggle, bool value) async {
    _toggles[toggle] = value;
    // Emitted before the write so the switch answers the tap immediately;
    // SharedPreferences is the slow half and nothing reads it back until the
    // next launch.
    emit(SettingsLoaded());
    await CacheUtil.setBool(key: toggle.cacheKey, value: value);
  }

  /// Records the choice. The locale itself is `EasyLocalization`'s to change —
  /// that needs a context, which never belongs in here — so the screen calls
  /// `setLocale` and this keeps the stored value and the API header in step.
  Future<void> changeLanguage(String languageCode) async {
    if (languageCode == language) return;
    language = languageCode;
    await LanguageService.apply(languageCode);
    emit(LanguageChanged(languageCode: languageCode));
  }
}
