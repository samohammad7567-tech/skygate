import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skygate/tourism/core/theme/app_colors.dart';

class DatePickerFormField extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final FormFieldValidator<DateTime>? validator;
  final String? hintText;
  final TextEditingController? controller;

  const DatePickerFormField({
    super.key,
    required this.onDateSelected,
    this.validator,
    required this.hintText,
    this.controller,
  });

  @override
  State<DatePickerFormField> createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  DateTime? _selectedDate;

  @override
  void dispose() {
    widget.controller!.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(now.year - 100), // 100 years ago
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
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Select a date',
          contentPadding: EdgeInsetsDirectional.fromSTEB(
            40.0.w,
            10.0.h,
            15.0.w,
            0.0.h,
          ),
          hintStyle: TextStyle(
            color: AppColors.blue,
            fontSize: 13.0,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.only(left: 16.0.w),
            child: const Icon(Icons.calendar_today, color: AppColors.blue),
          ),
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
        onTap: () => _selectDate(context),
        readOnly: true,
        validator: null,
      ),
    );
  }
}
