import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';
import 'package:skygate/core/utils/app_scale.dart';

class DarkTheme {
  DarkTheme._();

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    fontFamily: AppFonts.hacen,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primarySoft,
      onPrimary: Colors.white,
      secondary: AppColors.accent,
      onSecondary: Colors.black,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      surfaceContainerHighest: AppColors.darkSurfaceTint,
      outline: AppColors.darkBorder,
      outlineVariant: AppColors.darkBorder,
      error: AppColors.error,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
    dividerTheme: const DividerThemeData(color: AppColors.darkBorder, space: 1),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.darkSurface,
      headerBackgroundColor: AppColors.darkSurface,
      headerForegroundColor: AppColors.darkTextPrimary,
      todayBorder: const BorderSide(color: AppColors.primarySoft),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.s)),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.primarySoft
            : Colors.transparent,
      ),
      checkColor: const WidgetStatePropertyAll(Colors.white),
      side: BorderSide(color: AppColors.primarySoft, width: 1.5.s),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.s)),
    ),
    textTheme: TextTheme(
      headlineSmall: TextStyle(
        fontSize: 22.fs,
        fontWeight: FontWeight.w700,
        color: AppColors.primarySoft,
      ),
      titleLarge: TextStyle(
        fontSize: 18.fs,
        fontWeight: FontWeight.w700,
        color: AppColors.primarySoft,
      ),
      titleMedium: TextStyle(
        fontSize: 15.fs,
        fontWeight: FontWeight.w700,
        color: AppColors.darkTextPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 13.fs,
        fontWeight: FontWeight.w700,
        color: AppColors.darkTextPrimary,
      ),
      bodyMedium: TextStyle(fontSize: 13.fs, color: AppColors.darkTextPrimary),
      bodySmall: TextStyle(fontSize: 11.fs, color: AppColors.darkTextSecondary),
      labelLarge: TextStyle(
        fontSize: 14.fs,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    ),
  );
}
