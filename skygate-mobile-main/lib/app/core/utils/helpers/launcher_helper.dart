import 'package:url_launcher/url_launcher.dart';

class LauncherHelper {
  static openMap(double lat, double lng) async {
    // Android
    String url = "google.navigation:q=" + lat.toString() + "," + lng.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // iOS
      url = "comgooglemaps://?q=" + lat.toString() + "," + lng.toString();

      //apple map
      String appleUrl = "https://maps.apple.com/?sll=" +
          lat.toString() +
          "," +
          lng.toString();
      if (await canLaunch(url)) {
        await launch(url);
      } else if (await canLaunch(appleUrl)) {
        await launch(appleUrl);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  static launchWhatsapp({String? mobile, String? msg}) async {
    String? cleanedMobileNum = mobile!.replaceAll(RegExp(r'[^0-9+]'), '');

    String? URL = "";
    if(msg == "") {
      URL = "https://wa.me/${cleanedMobileNum}";
    } else {
      URL = "https://wa.me/${cleanedMobileNum}?text=${Uri.encodeComponent(msg!)}";
    }

    if (await canLaunchUrl(Uri.parse(URL))) {
      await launchUrl(Uri.parse(URL));
    } else {
      throw 'Could not launch $URL';
    }
  }

  static downloadFile({String? fileURL}) async {
    if (await canLaunchUrl(Uri.parse(fileURL!))) {
      await launchUrl(Uri.parse(fileURL!));
    } else {
      throw 'Could not launch $fileURL';
    }
  }
}
