import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';

class TimePickerFormField extends StatefulWidget {
  final TextEditingController controller;
  final Function(TimeOfDay)? onTimePick;
  final String? Function(String?)? validator;
  final String hintText;

  const TimePickerFormField({
    Key? key,
    required this.controller,
    this.onTimePick,
    this.validator,
    required this.hintText,
  }) : super(key: key);

  @override
  _TimePickerFormFieldState createState() => _TimePickerFormFieldState();
}

class _TimePickerFormFieldState extends State<TimePickerFormField> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final initialTime = TimeOfDay.now();
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.inputOnly,
    );

    if (pickedTime != null) {
      final formattedTime = pickedTime.format(context);
      widget.controller.text = formattedTime;
      if (widget.onTimePick != null) {
        widget.onTimePick!(pickedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.0.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0.r),
        image: const DecorationImage(
          scale: 0.5,
          image: AssetImage("assets/images/pngs/text_field.png"),
        ),
      ),
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: widget.controller,
        style: TextStyle(
          color: AppColors.blue,
          fontSize: 17.0,
          fontWeight: FontWeight.w400,
        ),
        readOnly: true,
        onTap: () => _selectTime(context),
        decoration: InputDecoration(
          hintText: widget.hintText,
          contentPadding:
              EdgeInsetsDirectional.fromSTEB(40.0.w, 10.0.h, 15.0.w, 0.0.h),
          hintStyle: TextStyle(
            color: AppColors.blue,
            fontSize: 13.0,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.only(left: 16.0.w),
            child: const Icon(
              Icons.access_time,
              color: AppColors.blue,
            ),
          ),
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
        validator: widget.validator,
        inputFormatters: [
          FilteringTextInputFormatter.deny(
              RegExp(r'[a-zA-Z]')), // Prevent manual text input
        ],
      ),
    );
  }
}
