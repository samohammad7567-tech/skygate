import 'package:flutter/material.dart';

/// Gives context-less callers (services, interceptors) a way to navigate.
class NavigationService {
  NavigationService._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;
}
