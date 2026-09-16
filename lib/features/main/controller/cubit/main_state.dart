part of 'main_cubit.dart';

@immutable
sealed class MainState {}

final class MainInitial extends MainState {}

final class TabChanged extends MainState {}

final class ThemeChanged extends MainState {}
