import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_outlined_button.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/payments/controller/cubit/payments_cubit.dart';
import 'package:skygate/features/payments/models/booking_details_model.dart';
import 'package:skygate/features/payments/models/booking_payment_model.dart';
import 'package:skygate/features/payments/views/booking_details_screen.dart';
import 'package:skygate/features/payments/views/payment_success_screen.dart';
import 'package:skygate/features/payments/views/transactions_screen.dart';
import 'package:skygate/features/payments/widgets/payment_sheet.dart';
import 'package:skygate/features/payments/widgets/payment_summary_card.dart';
import 'package:skygate/features/payments/widgets/payment_timeline_card.dart';

/// "المدفوعات" — what the booking costs against what has been settled, the
/// instalments it falls due in, and the way to pay the next one.
class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key, required this.bookingId, this.details});

  final int bookingId;

  /// "تفاصيل الحجز", handed in by whoever opened the flow — the API publishes
  /// no endpoint the screen could fetch it from. Null hides its button.
  final BookingDetailsModel? details;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PaymentsCubit(bookingId: bookingId, details: details)..getPayment(),
      child: const _PaymentsBody(),
    );
  }
}

class _PaymentsBody extends StatelessWidget {
  const _PaymentsBody();

  /// Opens "معلومات الدفع" and files whatever transfer it created.
  Future<void> _pay(BuildContext context) async {
    final cubit = context.read<PaymentsCubit>();
    final transaction = await showPaymentSheet(
      context,
      bookingId: cubit.bookingId,
    );
    if (transaction == null || !context.mounted) return;

    cubit.addTransaction(transaction);
    NaivgatorHelper.pushNavigation(context, const PaymentSuccessScreen());
  }

  void _openDetails(BuildContext context) {
    final details = context.read<PaymentsCubit>().details;
    if (details == null) return;
    NaivgatorHelper.pushNavigation(
      context,
      BookingDetailsScreen(details: details),
    );
  }

  void _openTransactions(BuildContext context) {
    final cubit = context.read<PaymentsCubit>();
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: cubit, child: const TransactionsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<PaymentsCubit, PaymentsState>(
          builder: (context, state) {
            final cubit = context.read<PaymentsCubit>();
            final payment = cubit.payment;

            return Column(
              children: [
                AppPageHeader(title: 'payments'.tr()),
                Expanded(
                  child: switch (state) {
                    PaymentSummaryLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    _ when payment == null => EmptyState(
                      message: state is PaymentSummaryError
                          ? state.message.tr()
                          : 'no_payments'.tr(),
                      onRetry: cubit.getPayment,
                    ),
                    _ => RefreshIndicator(
                      onRefresh: cubit.getPayment,
                      child: _Content(
                        payment: payment,
                        hasDetails: cubit.details != null,
                        onPay: () => _pay(context),
                        onDetails: () => _openDetails(context),
                        onTransactions: () => _openTransactions(context),
                      ),
                    ),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.payment,
    required this.hasDetails,
    required this.onPay,
    required this.onDetails,
    required this.onTransactions,
  });

  final BookingPaymentModel payment;
  final bool hasDetails;
  final VoidCallback onPay;
  final VoidCallback onDetails;
  final VoidCallback onTransactions;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      children: [
        PaymentSummaryCard(payment: payment),
        if (payment.installments.isNotEmpty) ...[
          const Gap(16),
          PaymentTimelineCard(installments: payment.installments),
        ],
        const Gap(20),
        CustomButton(
          label: 'pay_now'.tr(),
          height: 48,
          width: double.infinity,
          // Nothing left outstanding means nothing left to transfer.
          onPressed: payment.isSettled ? null : onPay,
        ),
        if (hasDetails) ...[
          const Gap(12),
          AppOutlinedButton(
            label: 'view_booking_details'.tr(),
            onPressed: onDetails,
          ),
        ],
        const Gap(12),
        // The design reaches "المعاملات المالية" from no screen it draws; it
        // is hung here because this is the only page that holds the booking.
        AppOutlinedButton(
          label: 'financial_transactions'.tr(),
          onPressed: onTransactions,
        ),
      ],
    );
  }
}
