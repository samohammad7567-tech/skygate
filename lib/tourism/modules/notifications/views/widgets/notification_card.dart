import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/core/utils/helpers/datetime_formatter.dart';

class NotificationCard extends StatelessWidget {
  NotificationCard({super.key, this.body, this.createDate});

  final String? body;
  final String? createDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 302.0.w,
            child: Text(
              '${body}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blue,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                height: 1.57,
              ),
            ),
          ),
          Text(
            '${DateTimeFormatter.formatHumanReadable(createDate!)}',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: AppColors.blue,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
              height: 1.57,
            ),
          ),
        ],
      ),
    );
  }
}
