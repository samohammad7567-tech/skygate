import 'package:flutter/material.dart';
import 'package:sky_gate/app/core/theme/text_theme.dart';
import 'app_colors.dart';
// ignore_for_file: deprecated_member_use

class AppFonts {
  static const String skygateFont = "Hacen";
}

ThemeData enThemeData = ThemeData(
  brightness: AppColors.colorScheme.brightness,
  primaryColor: AppColors.colorScheme.primary,
  canvasColor: AppColors.colorScheme.background,
  scaffoldBackgroundColor: AppColors.colorScheme.background,
  cardColor: AppColors.colorScheme.surface,
  dividerColor: AppColors.colorScheme.onSurface.withOpacity(0.12),
  dialogBackgroundColor: AppColors.colorScheme.background,
  textTheme: enTextTheme,
  indicatorColor: AppColors.colorScheme.primary,
  applyElevationOverlayColor: false,
  colorScheme: AppColors.colorScheme,
  fontFamily: AppFonts.skygateFont,
);

ThemeData arThemeData = ThemeData(
  brightness: AppColors.colorScheme.brightness,
  primaryColor: AppColors.colorScheme.primary,
  canvasColor: AppColors.colorScheme.background,
  scaffoldBackgroundColor: AppColors.colorScheme.background,
  cardColor: AppColors.colorScheme.surface,
  dividerColor: AppColors.colorScheme.onSurface.withOpacity(0.12),
  dialogBackgroundColor: AppColors.colorScheme.background,
  textTheme: arTextTheme,
  indicatorColor: AppColors.colorScheme.primary,
  applyElevationOverlayColor: false,
  colorScheme: AppColors.colorScheme,
  fontFamily: AppFonts.skygateFont,
);
