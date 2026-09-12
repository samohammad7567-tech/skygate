part of 'settings_cubit.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

/// Every preference change lands here — the screen reads the values off the
/// cubit's own fields, so one state is enough to repaint the page.
final class SettingsLoaded extends SettingsState {}

final class LanguageChanged extends SettingsState {
  final String languageCode;

  LanguageChanged({required this.languageCode});
}
