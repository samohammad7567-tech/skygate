import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// In app toasts.
///
/// Centralises the `toastification.show(...)` block that was repeated across
/// controllers, so style, duration and alignment stay consistent.
///
/// [context] stays an explicit parameter to keep the service free of any state
/// management package. Pass the widget context, or register a global one once:
///
/// ```dart
/// ToastService.instance.contextResolver = () => navigatorKey.currentContext;
/// ```
class ToastService {
  ToastService._();

  static final ToastService instance = ToastService._();

  /// Fallback context used when a call site has none.
  BuildContext? Function()? contextResolver;

  /// How long a toast stays on screen unless overridden per call.
  Duration defaultDuration = const Duration(seconds: 5);

  void success({
    required String title,
    String? description,
    BuildContext? context,
    Duration? duration,
  }) {
    _show(
      type: ToastificationType.success,
      title: title,
      description: description,
      context: context,
      duration: duration,
    );
  }

  void error({
    required String title,
    String? description,
    BuildContext? context,
    Duration? duration,
  }) {
    _show(
      type: ToastificationType.error,
      title: title,
      description: description,
      context: context,
      // Errors carry text the user needs time to read.
      duration: duration ?? const Duration(seconds: 8),
    );
  }

  void info({
    required String title,
    String? description,
    BuildContext? context,
    Duration? duration,
  }) {
    _show(
      type: ToastificationType.info,
      title: title,
      description: description,
      context: context,
      duration: duration,
    );
  }

  void warning({
    required String title,
    String? description,
    BuildContext? context,
    Duration? duration,
  }) {
    _show(
      type: ToastificationType.warning,
      title: title,
      description: description,
      context: context,
      duration: duration,
    );
  }

  /// Dismisses every visible toast.
  void dismissAll() => toastification.dismissAll();

  void _show({
    required ToastificationType type,
    required String title,
    String? description,
    BuildContext? context,
    Duration? duration,
  }) {
    final target = context ?? contextResolver?.call();
    if (target == null) return;

    toastification.show(
      context: target,
      type: type,
      style: ToastificationStyle.fillColored,
      title: Text(title),
      description: description == null ? null : Text(description),
      autoCloseDuration: duration ?? defaultDuration,
      alignment: Alignment.topCenter,
    );
  }
}
