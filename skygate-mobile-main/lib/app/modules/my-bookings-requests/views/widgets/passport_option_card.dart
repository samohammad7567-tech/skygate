import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';

class PassportOptionCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const PassportOptionCard({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
        padding: EdgeInsets.all(15.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0.r),
          border: Border.all(color: AppColors.blue),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: AppColors.blue,
            ),
            SizedBox(height: 15.h),
            Text(
              text,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

