import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/features/payments/controller/cubit/payments_cubit.dart';
import 'package:skygate/features/payments/widgets/payment_summary_card.dart';
import 'package:skygate/features/payments/widgets/transaction_card.dart';

/// "المعاملات المالية" — the same summary ring as "المدفوعات", over every
/// transfer filed against the booking.
///
/// It is pushed with the [PaymentsCubit] the payments screen already built, so
/// the booking is not fetched twice.
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentsCubit>().getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<PaymentsCubit, PaymentsState>(
          builder: (context, state) {
            final cubit = context.read<PaymentsCubit>();

            return Column(
              children: [
                AppPageHeader(title: 'financial_transactions'.tr()),
                Expanded(child: _body(context, state, cubit)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _body(BuildContext context, PaymentsState state, PaymentsCubit cubit) {
    if (state is TransactionsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final payment = cubit.payment;
    final transactions = cubit.transactions;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      children: [
        if (payment != null) ...[
          PaymentSummaryCard(payment: payment),
          const Gap(16),
        ],
        BuildCondition(
          condition: transactions.isNotEmpty,
          builder: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < transactions.length; i++) ...[
                TransactionCard(transaction: transactions[i], position: i + 1),
                if (i < transactions.length - 1) const Gap(12),
              ],
            ],
          ),
          fallback: (_) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: EmptyState(
              message: state is TransactionsError
                  ? state.message.tr()
                  : 'no_transactions'.tr(),
            ),
          ),
        ),
      ],
    );
  }
}
