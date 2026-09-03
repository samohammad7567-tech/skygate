import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skygate/tourism/core/extentions/extentions.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';

class RegularTripsTextField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextStyle? errorStyle;
  const RegularTripsTextField({
    super.key,
    required this.title,
    this.hintText = '',
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.errorStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0.w),
          child: TextFormField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0.r),
                  borderSide: const BorderSide(color: Color(0xD9D9D9C4))),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0.r),
                  borderSide: const BorderSide(color: Color(0xD9D9D9C4))),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0.r),
                  borderSide: const BorderSide(color: Colors.red)),
              // focusedBorder: InputBorder.none,
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0.r),
                  borderSide: const BorderSide(color: Colors.red)),
              hintText: hintText,
              hintStyle: context.textTheme.titleSmall!.copyWith(
                color: AppColors.greyMedium,
              ),
              errorStyle: errorStyle,
              contentPadding: EdgeInsets.symmetric(vertical: 15.0.h),
            ),
            autovalidateMode: AutovalidateMode.disabled,
            inputFormatters: inputFormatters,
            style: context.textTheme.bodySmall,
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
          ),
        ),
        PositionedDirectional(
          top: -12.0.h,
          start: 16.0.w,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            color: Colors.white,
            child: Text(
              title,
              style: context.textTheme.titleSmall,
            ),
          ),
        ),
      ],
    );
  }
}
