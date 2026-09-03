import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatMessage extends StatelessWidget {
  String? text;
  bool? isMe;
  bool? hasAttach;
  String? attachURL;
  DateTime? timestamp;

  ChatMessage(
      {this.text, this.isMe, this.timestamp, this.attachURL, this.hasAttach});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 10.0.h),
        decoration: BoxDecoration(
          color: isMe! ? Theme.of(context).primaryColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(20.0.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text!,
              style: TextStyle(
                color: isMe! ? Colors.white : Colors.black,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 4),
            Visibility(
              visible: hasAttach!,
              child: Column(
                children: [
                  TextButton(
                    onPressed: () async {
                      if (!await launchUrl(Uri.parse(attachURL!))) {
                        log('Could not launch $attachURL');
                      }
                    },
                    child: Text(
                      "تحميل الملف",
                      style: TextStyle(
                        color: (isMe!) ? Colors.white : AppColors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor:
                            (isMe!) ? Colors.white : AppColors.blue,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
            Text(
              '${timestamp!.hour}:${timestamp!.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                color: isMe! ? Colors.white70 : Colors.black54,
                fontSize: 10.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
