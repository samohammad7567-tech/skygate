import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:sky_gate/app/core/theme/app_colors.dart';

class RegularTripsDatepicker extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final FormFieldValidator<String>? validator;
  final String? hintText;
  final String? title;
  final TextEditingController? controller;

  const RegularTripsDatepicker(
      {super.key,
      required this.onDateSelected,
      this.validator,
      this.hintText,
      this.controller,
      this.title});

  @override
  State<RegularTripsDatepicker> createState() => _RegularTripsDatepickerState();
}

class _RegularTripsDatepickerState extends State<RegularTripsDatepicker> {
  DateTime? _selectedDate;

  String _formatDate(DateTime date) {
    if (date.month <= 9) {
      return '${date.year}-0${date.month}-${date.day}';
    }
    return '${date.year}-${date.month}-${date.day}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now, // 100 years ago
      lastDate: DateTime(now.year + 10), // 10 years in future
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.controller!.text = _formatDate(picked);
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        TextFormField(
          textAlign: TextAlign.center,
          controller: widget.controller,
          style: TextStyle(
            color: AppColors.blue,
            fontSize: 17.0,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText ?? '',
            contentPadding:
                EdgeInsetsDirectional.fromSTEB(0.0.w, 10.0.h, 0.0.w, 0.0.h),
            hintStyle: TextStyle(
              color: AppColors.blue,
              fontSize: 13.0,
              fontWeight: FontWeight.w400,
            ),
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: AppColors.blue,
            ),
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
          ),
          onTap: () => _selectDate(context),
          readOnly: true,
          validator: widget.validator,
        ),
        PositionedDirectional(
          top: -12.0.h,
          start: 16.0.w,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            color: Colors.white,
            child: Text(
              widget.title!,
              style: context.textTheme.titleSmall,
            ),
          ),
        ),
      ],
    );
  }
}
