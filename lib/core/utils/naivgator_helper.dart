import 'package:flutter/material.dart';

/// Navigator helpers used across features.
///
/// The file name keeps its original spelling on purpose — do not rename it.
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

  /// Pushes [screen] under [name] so [popBackTo] can find it again.
  ///
  /// Used by flows that branch off a card and come back to it — the group
  /// wizard leaves "تكوين المجموعة" to add a traveller and returns to the same
  /// instance rather than stacking a second copy on top.
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

  /// Unwinds back to the route pushed as [name]. Stops at the first route when
  /// the anchor is not on the stack, so it can never empty the navigator.
  static void popBackTo(BuildContext context, String name) => Navigator.of(
    context,
  ).popUntil((route) => route.isFirst || route.settings.name == name);
}
