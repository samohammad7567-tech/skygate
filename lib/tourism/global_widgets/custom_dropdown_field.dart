import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skygate/tourism/core/extentions/extentions.dart';

class CustomDropdownField extends StatelessWidget {
  final List<DropdownMenuItem<String>>? dropDownList;
  final void Function(String?)? onChanged;
  final String? hintText;

  CustomDropdownField({this.dropDownList, this.onChanged, this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 285.0.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0.r),
        image: const DecorationImage(
          scale: 0.5,
            image: AssetImage("assets/images/pngs/text_field.png"),
        ),
      ),
      child: DropdownButtonFormField<String>(
          items: dropDownList,
          alignment: AlignmentDirectional.center,
          padding: EdgeInsets.only(right: 80.0.w, left: 8.0.w),
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
    );
  }
}
