import 'package:flutter/material.dart';
import 'package:skygate/core/components/booking_step_bar.dart';

/// Scrolling column of a wizard step: the progress card, then the step's own
/// content.
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
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      children: [
        BookingStepBar(step: step, total: total),
        const SizedBox(height: 18),
        ...children,
      ],
    );
  }
}
