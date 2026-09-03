import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({Key? key, required this.addShadow, required this.borderColor,
     required this.child, required this.onTap}) : super(key: key);

  final void Function()? onTap;

  final Widget child;
  final Color borderColor;
  final bool addShadow;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30.r),
      elevation:(addShadow == false)? 0.0 : 10.0,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: borderColor,width: 3.0),
            borderRadius: BorderRadius.circular(30.0.r),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(17.r),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
