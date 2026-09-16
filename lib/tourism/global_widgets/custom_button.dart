import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;
  final Color btnColor;
  final bool addShadow;
  final double borderRadius;
  final double padding;

  const CustomButton({
    super.key,
    required this.child,
    required this.onTap,
    required this.btnColor,
    required this.addShadow,
    this.borderRadius = 20.0,
    this.padding = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      clipBehavior: Clip.hardEdge,
      style: ButtonStyle(
        alignment: Alignment.center,
        backgroundColor: WidgetStatePropertyAll(btnColor),
        elevation: (addShadow == false)
            ? const WidgetStatePropertyAll(0.0)
            : const WidgetStatePropertyAll(10.0),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: padding.w, vertical: padding.h),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
        ),
      ),
      child: child,
    );
  }
}
