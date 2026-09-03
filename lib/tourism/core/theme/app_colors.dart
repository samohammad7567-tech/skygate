// ignore_for_file: deprecated_member_use


import 'package:flutter/material.dart';

class AppColors {
  static ColorScheme colorScheme = ColorScheme(
    primary: blue.shade300,
    secondary: blue.shade100,
    surface: Colors.white,
    background: Colors.white,
    error: red,
    onPrimary: const Color(0xffffffff),
    onSecondary: const Color(0xffffffff),
    onSurface: const Color(0xff000000),
    onBackground: Colors.white,
    onError: red,
    brightness: Brightness.light,
  );


  static const MaterialColor purple = MaterialColor(
    0xFF6A4C93,
    <int, Color>{
      900: Color(0xFF6A4C93),
    },
  );
  static const MaterialColor green = MaterialColor(
    0xFF8AC926,
    <int, Color>{
      900: Color(0xFF8AC926),
    },
  );
  static const MaterialColor yellow = MaterialColor(
    0xFFFFCA3A,
    <int, Color>{
      900: Color(0xFFFFCA3A),
    },
  );
  static const MaterialColor blue = MaterialColor(
    0xFF195AA7,
    <int, Color>{
      100: Color(0xFF195AA7),
      200: Color(0xFF195AA7),
      300: Color(0xFF195AA7),
      400: Color(0xFF195AA7),
      500: Color(0xFF195AA7),
      600: Color(0xFF195AA7),
      700: Color(0xFF195AA7),
      800: Color(0xFF195AA7),
      900: Color(0xFF195AA7),
    },
  );
  static const MaterialColor grey = MaterialColor(
    0xFFF2F3F4,
    <int, Color>{
      900: Color(0xFFF2F3F4),
    },
  );

  static const MaterialColor greyMedium = MaterialColor(
    0xFFAFA4A4,
    <int, Color>{
      900: Color(0xFFAFA4A4),
    },
  );
  static const MaterialColor red = MaterialColor(
    0xFFFF595E,
    <int, Color>{
      100: Color(0xFFFF595E),
    },
  );
}
