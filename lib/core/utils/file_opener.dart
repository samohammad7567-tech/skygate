import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Hands a document the API published — a card PDF, a visa scan, a ticket —
/// to whatever the device uses to open it.
///
/// The app never stores these files itself: every one of them arrives as a
/// URL on its resource, so "تحميل" means handing that URL out rather than
/// streaming bytes through Dio.
class FileOpener {
  FileOpener._();

  static Future<bool> open(String? url) async {
    final address = url?.trim();
    if (address == null || address.isEmpty) return false;

    final uri = Uri.tryParse(address);
    if (uri == null || !uri.hasScheme) return false;

    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (error) {
      debugPrint('FileOpener.open error: $error');
      return false;
    }
  }
}
