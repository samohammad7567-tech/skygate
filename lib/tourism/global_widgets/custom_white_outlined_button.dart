import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomWhiteOutlinedButton extends StatelessWidget {
  const CustomWhiteOutlinedButton({
    super.key,
    required this.addShadow,
    required this.borderColor,
    required this.child,
    required this.onTap,
    this.padding = 10.0,
    this.borderRadius = 30.0,
  });

  final void Function()? onTap;

  final Widget child;
  final Color borderColor;
  final bool addShadow;
  final double padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.r),
      elevation: (addShadow == false) ? 0.0 : 10.0,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: borderColor, width: 1.5),
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
          child: Center(
            child: Padding(padding: EdgeInsets.all(padding.r), child: child),
          ),
        ),
      ),
    );
  }
}
