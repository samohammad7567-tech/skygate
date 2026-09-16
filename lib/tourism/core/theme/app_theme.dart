import 'package:flutter/material.dart';
import 'package:skygate/tourism/core/theme/text_theme.dart';
import 'app_colors.dart';

class AppFonts {
  static const String skygateFont = "Hacen";
}

ThemeData enThemeData = ThemeData(
  brightness: AppColors.colorScheme.brightness,
  primaryColor: AppColors.colorScheme.primary,
  canvasColor: AppColors.colorScheme.surface,
  scaffoldBackgroundColor: AppColors.colorScheme.surface,
  cardColor: AppColors.colorScheme.surface,
  dividerColor: AppColors.colorScheme.onSurface.withValues(alpha: 0.12),
  textTheme: enTextTheme,
  applyElevationOverlayColor: false,
  colorScheme: AppColors.colorScheme,
  fontFamily: AppFonts.skygateFont, dialogTheme: DialogThemeData(backgroundColor: AppColors.colorScheme.surface), tabBarTheme: TabBarThemeData(indicatorColor: AppColors.colorScheme.primary),
);

ThemeData arThemeData = ThemeData(
  brightness: AppColors.colorScheme.brightness,
  primaryColor: AppColors.colorScheme.primary,
  canvasColor: AppColors.colorScheme.surface,
  scaffoldBackgroundColor: AppColors.colorScheme.surface,
  cardColor: AppColors.colorScheme.surface,
  dividerColor: AppColors.colorScheme.onSurface.withValues(alpha: 0.12),
  textTheme: arTextTheme,
  applyElevationOverlayColor: false,
  colorScheme: AppColors.colorScheme,
  fontFamily: AppFonts.skygateFont, dialogTheme: DialogThemeData(backgroundColor: AppColors.colorScheme.surface), tabBarTheme: TabBarThemeData(indicatorColor: AppColors.colorScheme.primary),
);
