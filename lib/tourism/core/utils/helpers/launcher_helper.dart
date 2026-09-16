import 'package:url_launcher/url_launcher.dart';

class LauncherHelper {
  static Future<void> openMap(double lat, double lng) async {
    String url = "google.navigation:q=$lat,$lng";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      url = "comgooglemaps://?q=$lat,$lng";
      String appleUrl =
          "https://maps.apple.com/?sll=$lat,$lng";
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else if (await canLaunchUrl(Uri.parse(appleUrl))) {
        await launchUrl(Uri.parse(appleUrl));
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  static Future<void> launchWhatsapp({String? mobile, String? msg}) async {
    String? cleanedMobileNum = mobile!.replaceAll(RegExp(r'[^0-9+]'), '');

    String? URL = "";
    if (msg == "") {
      URL = "https://wa.me/$cleanedMobileNum";
    } else {
      URL =
          "https://wa.me/$cleanedMobileNum?text=${Uri.encodeComponent(msg!)}";
    }

    if (await canLaunchUrl(Uri.parse(URL))) {
      await launchUrl(Uri.parse(URL));
    } else {
      throw 'Could not launch $URL';
    }
  }

  static Future<void> downloadFile({String? fileURL}) async {
    if (await canLaunchUrl(Uri.parse(fileURL!))) {
      await launchUrl(Uri.parse(fileURL));
    } else {
      throw 'Could not launch $fileURL';
    }
  }
}
