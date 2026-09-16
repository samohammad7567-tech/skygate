import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skygate/tourism/core/extentions/extentions.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/failures/field_failure/field_failure.dart';

class CustomFormField extends StatefulWidget {
  const CustomFormField({
    super.key,
    this.title = '',
    this.prefixIcon,
    required this.hintText,
    this.suffixIcon,
    this.suffix,
    this.prefix,
    this.obscureText = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.autoValidate = true,
    this.onChange,
    this.readOnly = false,
    this.isPassword = false,
    this.onTap,
    this.maxLines = 1,
    this.maxLength = 1000,
  });
  final bool autoValidate;
  final Widget? prefixIcon;
  final Widget? suffix;
  final String hintText;
  final String title;
  final IconData? suffixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readOnly;
  final TextEditingController? controller;
  final Function(String)? onChange;
  final FieldFailure? Function(String)? validator;
  final bool? isPassword;
  final Function()? onTap;
  final Widget? prefix;
  final int? maxLength;
  final int? maxLines;

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  final showPassword = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool password = !showPassword.value;
      password = widget.isPassword! && password;
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0.r),
          image: const DecorationImage(
            scale: 0.5,
            image: AssetImage("assets/images/pngs/text_field.png"),
          ),
        ),
        child: TextFormField(
          textAlign: TextAlign.center,
          maxLines: widget.maxLines,
          textInputAction: TextInputAction.newline,
          onTap: widget.onTap,
          maxLength: widget.maxLength,
          cursorHeight: 25.0,
          validator: widget.validator != null
              ? (value) {
                  return context.fieldFailureParser(
                    widget.validator!(value ?? ''),
                  );
                }
              : null,
          onChanged: widget.onChange,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          autovalidateMode: widget.autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          obscureText: password,
          style: Theme.of(
            context,
          ).textTheme.titleSmall!.copyWith(color: AppColors.blue),
          decoration: InputDecoration(
            errorMaxLines: 3,
            errorStyle: TextStyle(fontSize: 14.0),
            counterText: "",
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            prefixIcon: widget.prefixIcon == null
                ? null
                : Padding(
                    padding: EdgeInsetsDirectional.only(start: 18.w),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [widget.prefixIcon!],
                    ),
                  ),
            suffix: widget.suffix,
            isCollapsed: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: AppColors.blue,
              fontSize: 13.0,
              fontWeight: FontWeight.w400,
            ),
            contentPadding: const EdgeInsets.all(15),
            prefix: widget.prefix,
            suffixIcon: widget.suffixIcon != null
                ? IconButton(
                    icon: showPassword.value
                        ? const Icon(
                            Icons.visibility_off,
                            color: AppColors.blue,
                          )
                        : const Icon(Icons.visibility, color: AppColors.blue),
                    onPressed: () {
                      showPassword.value = (!showPassword.value);
                    },
                  )
                : null,
          ),
        ),
      );
    });
  }
}
