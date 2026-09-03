import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomTextareaField extends StatelessWidget {
  CustomTextareaField({super.key, this.labelText, this.hintText, this.controller});

  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380.0.w,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.blue,  // Border color
              width: 2.0,          // Border width
            ),
            borderRadius: BorderRadius.circular(10.0.r),  // Rounded corners
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1.5),
            borderRadius: BorderRadius.circular(10.0.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(10.0.r),
          ),
          labelText: labelText,
          labelStyle: context.textTheme.titleSmall,
          hintText: hintText,
          contentPadding: EdgeInsets.all(16.0.r),  // Inner padding
        ),
        maxLines: 8,
        minLines: 5,
        keyboardType: TextInputType.multiline,
        style: context.textTheme.titleSmall,
      ),
    );
  }
}
