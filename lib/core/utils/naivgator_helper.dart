import 'package:flutter/material.dart';

class NaivgatorHelper {
  NaivgatorHelper._();

  static Future<T?> pushNavigation<T>(BuildContext context, Widget screen) =>
      Navigator.of(context).push<T>(MaterialPageRoute(builder: (_) => screen));

  static Future<T?> pushReplacementNavigation<T>(
    BuildContext context,
    Widget screen,
  ) => Navigator.of(
    context,
  ).pushReplacement(MaterialPageRoute(builder: (_) => screen));

  static Future<T?> pushAndRemoveUntilNavigation<T>(
    BuildContext context,
    Widget screen,
  ) => Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => screen),
    (route) => false,
  );

  static void popNavigation(BuildContext context) =>
      Navigator.of(context).pop();
  static Future<T?> pushAnchor<T>(
    BuildContext context,
    Widget screen,
    String name,
  ) => Navigator.of(context).push<T>(
    MaterialPageRoute(
      builder: (_) => screen,
      settings: RouteSettings(name: name),
    ),
  );
  static void popBackTo(BuildContext context, String name) => Navigator.of(
    context,
  ).popUntil((route) => route.isFirst || route.settings.name == name);
}
