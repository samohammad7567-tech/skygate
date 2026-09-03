import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

/// Fingerprint / face unlock.
///
/// Every method swallows plugin errors and reports them as `false` or an empty
/// list, so a device without a sensor, or with none enrolled, degrades to
/// "biometrics unavailable" instead of crashing the login flow.
class BiometricAuthService {
  BiometricAuthService._();

  static final BiometricAuthService instance = BiometricAuthService._();

  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Default prompt shown by the OS dialog.
  static const String defaultReason = 'يرجى استخدام بصمة الأصبع للمصادقة.';

  /// Whether the device has biometric hardware the app can use.
  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      debugPrint('Error checking biometrics: $e');
      return false;
    }
  }

  /// Whether biometrics or a device passcode can authenticate the user.
  Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.isDeviceSupported();
    } catch (e) {
      debugPrint('Error checking device support: $e');
      return false;
    }
  }

  /// The biometric types enrolled on this device (fingerprint, face, iris).
  Future<List<BiometricType>> availableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('Error reading available biometrics: $e');
      return <BiometricType>[];
    }
  }

  /// True when the device can prompt for a biometric right now.
  Future<bool> isAvailable() async {
    if (!await canCheckBiometrics()) return false;
    return (await availableBiometrics()).isNotEmpty;
  }

  /// Shows the OS biometric prompt. Returns `false` when the user cancels or
  /// the check fails.
  ///
  /// [biometricOnly] keeps the device PIN/pattern fallback out of the prompt.
  Future<bool> authenticate({
    String reason = defaultReason,
    bool biometricOnly = true,
    bool stickyAuth = true,
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          biometricOnly: biometricOnly,
          useErrorDialogs: true,
          stickyAuth: stickyAuth,
        ),
      );
    } catch (e) {
      debugPrint('Authentication error: $e');
      return false;
    }
  }

  /// Dismisses a prompt left open by [authenticate] with `stickyAuth`.
  Future<bool> cancelAuthentication() async {
    try {
      return await _localAuth.stopAuthentication();
    } catch (_) {
      return false;
    }
  }
}
