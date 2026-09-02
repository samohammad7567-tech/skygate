import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/booking/controller/cubit/booking_cubit.dart';
import 'package:skygate/features/booking/models/booking_summary_model.dart';
import 'package:skygate/features/booking/views/booking_confirmation_screen.dart';
import 'package:skygate/core/components/booking_section_title.dart';
import 'package:skygate/features/booking/widgets/booking_step_scaffold.dart';
import 'package:skygate/features/booking/widgets/payment_countdown_card.dart';
import 'package:skygate/features/booking/widgets/payment_details_card.dart';
import 'package:skygate/features/booking/widgets/payment_schedule_card.dart';

/// Step 6 — "ملخص الحجز": the hold countdown, the priced review and the
/// instalment schedule, then the button that creates the booking.
class BookingSummaryScreen extends StatefulWidget {
  const BookingSummaryScreen({super.key});

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BookingCubit>().getSummary();
  }

  void _onState(BuildContext context, BookingState state) {
    if (state is BookingSubmitted) {
      NaivgatorHelper.pushNavigation(
        context,
        const BookingConfirmationScreen(),
      );
    } else if (state is BookingSubmitError) {
      showToast(context, state.message.tr(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listener: _onState,
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();
        final summary = cubit.summary;

        return BookingStepScaffold(
          step: 6,
          isLoading: state is BookingSubmitLoading,
          onContinue: summary == null ? null : cubit.submit,
          children: [
            BookingSectionTitle(
              title: 'booking_summary'.tr(),
              subtitle: 'review_your_booking'.tr(),
            ),
            const Gap(16),
            if (state is BookingSummaryLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (summary == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: EmptyState(
                  message: state is BookingSummaryError
                      ? state.message.tr()
                      : 'no_booking_summary'.tr(),
                  onRetry: cubit.getSummary,
                ),
              )
            else
              _SummaryContent(summary: summary, remaining: cubit.remaining),
          ],
        );
      },
    );
  }
}

class _SummaryContent extends StatelessWidget {
  const _SummaryContent({required this.summary, required this.remaining});

  final BookingSummaryModel summary;
  final Duration remaining;

  @override
  Widget build(BuildContext context) {
    final installments = summary.installments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PaymentCountdownCard(
          remaining: remaining,
          windowHours: summary.paymentWindowHours,
          firstInstallmentNumber: installments.isEmpty
              ? 1
              : installments.first.number ?? 1,
        ),
        const Gap(16),
        PaymentDetailsCard(summary: summary),
        if (installments.isNotEmpty) ...[
          const Gap(16),
          PaymentScheduleCard(installments: installments),
        ],
      ],
    );
  }
}
