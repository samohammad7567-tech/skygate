import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
