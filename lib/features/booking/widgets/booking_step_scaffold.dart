import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/features/booking/controller/cubit/booking_cubit.dart';
import 'package:skygate/features/booking/widgets/booking_bottom_bar.dart';
import 'package:skygate/features/booking/widgets/booking_step_scaffold_body.dart';

/// The frame every wizard step shares: the "تفاصيل الحجز" header, the progress
/// card, the step's own body, and the "متابعة / عودة" strip.
class BookingStepScaffold extends StatelessWidget {
  const BookingStepScaffold({
    super.key,
    required this.step,
    required this.children,
    required this.onContinue,
    this.total = BookingCubit.totalSteps,
    this.onBack,
    this.isLoading = false,
    this.continueLabel,
  });

  /// 1-based index of the step being shown.
  final int step;

  /// Steps the wizard has in total — six for the individual flow, nine for the
  /// group one.
  final int total;

  /// The step's body, laid out under the progress card.
  final List<Widget> children;

  /// `null` disables "متابعة" — used while the step has nothing selected yet.
  final VoidCallback? onContinue;

  final VoidCallback? onBack;
  final bool isLoading;
  final String? continueLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppPageHeader(title: 'booking_details'.tr(), onBack: onBack),
            Expanded(
              child: BookingStepScaffoldBody(
                step: step,
                total: total,
                children: children,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BookingBottomBar(
        onContinue: onContinue,
        onBack: onBack,
        isLoading: isLoading,
        continueLabel: continueLabel,
      ),
    );
  }
}
