import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAlertDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required String? positiveButtonText,
    required String? negativeButtonText,
    required VoidCallback? onPositivePressed,
    bool barrierDismissible = true,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: context.textTheme.titleMedium,),
          content: Text(message, style: context.textTheme.titleMedium,),
          actions: <Widget>[
            TextButton(
                child: Text(negativeButtonText??"Cancel", style: context.textTheme.titleSmall,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            TextButton(
              child: Text(positiveButtonText ?? 'OK', style: context.textTheme.titleSmall,),
              onPressed: () {
                Navigator.of(context).pop();
                if (onPositivePressed != null) onPositivePressed();
              },
            ),
          ],
        );
      },
    );
  }
}