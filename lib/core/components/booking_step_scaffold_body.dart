import 'package:flutter/material.dart';
import 'package:skygate/core/components/booking_step_bar.dart';
import 'package:skygate/core/utils/app_scale.dart';

class BookingStepScaffoldBody extends StatelessWidget {
  const BookingStepScaffoldBody({
    super.key,
    required this.step,
    required this.children,
    required this.total,
  });

  final int step;
  final int total;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 20.s),
      children: [
        BookingStepBar(step: step, total: total),
        SizedBox(height: 18.s),
        ...children,
      ],
    );
  }
}
