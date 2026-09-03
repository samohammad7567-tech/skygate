import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skygate/tourism/core/extentions/extentions.dart';

class RegularTripsDropdownfield extends StatelessWidget {
  final List<DropdownMenuItem<String>>? dropDownList;
  final void Function(String?)? onChanged;
  final String? hintText;
  final String? title;
  final String? value;

  const RegularTripsDropdownfield(
      {super.key,
      this.dropDownList,
      this.onChanged,
      this.hintText,
      this.title,
      this.value});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xD9D9D9C4)),
            borderRadius: BorderRadius.circular(15.0.r),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            items: dropDownList,
            icon: Text(""),
            autovalidateMode: AutovalidateMode.disabled,
            padding: EdgeInsets.only(right: 10.0.w, left: 8.0.w),
            style: context.textTheme.titleSmall,
            hint: Text(
              textAlign: TextAlign.center,
              hintText!,
              style: context.textTheme.titleSmall,
            ),
            isExpanded: true,
            onChanged: onChanged,
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
        PositionedDirectional(
          top: -12.0.h,
          start: 16.0.w,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            color: Colors.white,
            child: Text(
              title!,
              style: context.textTheme.titleSmall,
            ),
          ),
        ),
      ],
    );
  }
}
