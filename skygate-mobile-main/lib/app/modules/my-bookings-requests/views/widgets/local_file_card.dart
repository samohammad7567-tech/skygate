import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';

class LocalFileCard extends StatelessWidget {
  final File file;
  final VoidCallback onRemove;

  const LocalFileCard({
    super.key,
    required this.file,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final fileName = file.path.split(Platform.pathSeparator).last;

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
              fileName,
              textAlign: TextAlign.center,
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

