import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';
import 'package:skygate/core/utils/app_scale.dart';

class LightTheme {
  LightTheme._();

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    fontFamily: AppFonts.hacen,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceTint,
      outline: AppColors.border,
      outlineVariant: AppColors.dotInactive,
      error: AppColors.error,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
    dividerTheme: const DividerThemeData(color: AppColors.border, space: 1),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.surface,
      headerBackgroundColor: AppColors.surface,
      headerForegroundColor: AppColors.textPrimary,
      todayBorder: const BorderSide(color: AppColors.primary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.s)),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.primary
            : Colors.transparent,
      ),
      checkColor: const WidgetStatePropertyAll(Colors.white),
      side: BorderSide(color: AppColors.primary, width: 1.5.s),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.s)),
    ),
    textTheme: TextTheme(
      headlineSmall: TextStyle(
        fontSize: 22.fs,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
      titleLarge: TextStyle(
        fontSize: 18.fs,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
      titleMedium: TextStyle(
        fontSize: 15.fs,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 13.fs,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(fontSize: 13.fs, color: AppColors.textPrimary),
      bodySmall: TextStyle(fontSize: 11.fs, color: AppColors.textSecondary),
      labelLarge: TextStyle(
        fontSize: 14.fs,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
  );
}
