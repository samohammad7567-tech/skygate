part of 'settings_cubit.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class SettingsLoaded extends SettingsState {}

final class LanguageChanged extends SettingsState {
  final String languageCode;

  LanguageChanged({required this.languageCode});
}
