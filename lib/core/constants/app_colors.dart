import 'package:flutter/material.dart';

/// Raw palette sampled from the Sky Gate design file.
///
/// Features must read colours from `Theme.of(context)` — this class exists so
/// the two [ThemeData] definitions have a single source of truth.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF195AA7);
  static const Color primaryDark = Color(0xFF103D72);
  static const Color primarySoft = Color(0xFF6993C5);

  static const Color accent = Color(0xFFFF9E00);
  static const Color accentSoft = Color(0xFFFFC260);
  static const Color accentSurface = Color(0xFFFDE8C4);

  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceTint = Color(0xFFEFF6FF);

  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border = Color(0xFFDBEAFE);

  /// Inactive onboarding dot, sampled from the design.
  static const Color dotInactive = Color(0xFFB5BFCE);

  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceTint = Color(0xFF243349);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);

  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF16A34A);

  // ── Auth flow ────────────────────────────────────────────────────────────
  /// Fill of the dashed upload zones and the read-only passport fields.
  static const Color fieldSurface = Color(0xFFF6F8FB);

  /// Background / border of the "تم مسح ومطابقة البيانات بنجاح" banner.
  static const Color successSurface = Color(0xFFEAF7F0);
  static const Color successBorder = Color(0xFFBFE6D2);
  static const Color successText = Color(0xFF14532D);

  static const Color darkFieldSurface = Color(0xFF1B2739);

  // ── Journey activities ───────────────────────────────────────────────────
  /// "شعائر" activity colour, and the plate its glyph sits on.
  static const Color ritual = Color(0xFFB47FFB);
  static const Color ritualSurface = Color(0xFFE2CFFE);

  /// Plate behind the "صلوات" glyph, on the timeline rail and in the legend.
  static const Color prayerSurface = Color(0xFFC6D9ED);

  /// Plate behind the "فندق" glyph.
  static const Color staySurface = Color(0xFFFFCD83);
}
