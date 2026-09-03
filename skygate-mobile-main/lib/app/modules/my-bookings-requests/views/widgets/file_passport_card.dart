import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';
import 'package:sky_gate/app/core/utils/constants/constants.dart';
import 'package:sky_gate/app/modules/my-bookings-requests/models/passport_model.dart';
import 'package:url_launcher/url_launcher.dart';

class FilePassportCard extends StatelessWidget {
  final PassportModel passport;
  final VoidCallback onRemove;

  const FilePassportCard({
    super.key,
    required this.passport,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final fileUrl = NetworkRoutesControl.mainUrl + passport.fileUrl;
    final isPdf = passport.fileUrl.toLowerCase().endsWith('.pdf');

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
            child: isPdf
                ? InkWell(
                    onTap: () async {
                      final uri = Uri.parse(fileUrl);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.picture_as_pdf,
                          size: 60,
                          color: Colors.red,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          passport.fileUrl.split('/').last,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5.h),
                        const Text(
                          'اضغط للفتح',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  )
                : Image.network(
                    fileUrl,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 60,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: onRemove,
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

