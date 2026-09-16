import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';
import 'package:skygate/tourism/modules/my-bookings-requests/models/passport_model.dart';

class ScannedPassportCard extends StatelessWidget {
  final PassportModel passport;
  final VoidCallback onRemove;

  const ScannedPassportCard({
    super.key,
    required this.passport,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0.r),
              border: Border.all(color: AppColors.blue),
            ),
            child: Text(
              "${passport.firstName} ${passport.lastName}\n${passport.passportNumber}",
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.cancel, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
