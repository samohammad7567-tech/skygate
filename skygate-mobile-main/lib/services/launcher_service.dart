import 'package:url_launcher/url_launcher.dart';

/// Handing a destination over to another app: maps, WhatsApp, the dialer, the
/// mail client or the browser.
///
/// Every method returns `false` instead of throwing when no app can handle the
/// request, so the caller decides what to show the user.
class LauncherService {
  LauncherService._();

  static final LauncherService instance = LauncherService._();

  /// Opens turn by turn navigation to [latitude], [longitude].
  ///
  /// Tries Google Maps navigation first, then the Google Maps iOS scheme, then
  /// Apple Maps.
  Future<bool> openNavigation(double latitude, double longitude) async {
    final candidates = <String>[
      'google.navigation:q=$latitude,$longitude',
      'comgooglemaps://?q=$latitude,$longitude',
      'https://maps.apple.com/?sll=$latitude,$longitude',
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    ];

    for (final candidate in candidates) {
      if (await openUrl(candidate)) return true;
    }
    return false;
  }

  /// Opens a WhatsApp chat with [mobile], optionally prefilling [message].
  ///
  /// Non numeric characters are stripped from [mobile], so `+963 11 222 333`
  /// and `+96311222333` behave the same.
  Future<bool> openWhatsapp({required String mobile, String? message}) async {
    final number = mobile.replaceAll(RegExp(r'[^0-9+]'), '');
    if (number.isEmpty) return false;

    final url = (message == null || message.isEmpty)
        ? 'https://wa.me/$number'
        : 'https://wa.me/$number?text=${Uri.encodeComponent(message)}';

    return openUrl(url);
  }

  /// Opens the dialer prefilled with [mobile].
  Future<bool> callPhone(String mobile) => openUrl('tel:$mobile');

  /// Opens the mail client addressed to [email].
  Future<bool> sendEmail({
    required String email,
    String? subject,
    String? body,
  }) {
    final query = <String>[
      if (subject != null) 'subject=${Uri.encodeComponent(subject)}',
      if (body != null) 'body=${Uri.encodeComponent(body)}',
    ].join('&');

    return openUrl('mailto:$email${query.isEmpty ? '' : '?$query'}');
  }

  /// Hands [fileUrl] to the browser / download manager.
  Future<bool> downloadFile(String fileUrl) =>
      openUrl(fileUrl, mode: LaunchMode.externalApplication);

  /// Opens [url] with the platform default handler.
  Future<bool> openUrl(
    String url, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    try {
      if (!await canLaunchUrl(uri)) return false;
      return await launchUrl(uri, mode: mode);
    } catch (_) {
      // No installed app can handle the scheme.
      return false;
    }
  }
}
