import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/features/payments/controller/cubit/pay_cubit.dart';
import 'package:skygate/features/payments/widgets/payment_amount_field.dart';
import 'package:skygate/features/payments/widgets/payment_currency_selector.dart';
import 'package:skygate/features/payments/widgets/payment_field_label.dart';
import 'package:skygate/features/payments/widgets/payment_method_card.dart';
import 'package:skygate/features/payments/widgets/payment_receipt_field.dart';

/// The four blocks of "معلومات الدفع", in the order the sheet asks for them.
class PaymentSheetForm extends StatelessWidget {
  const PaymentSheetForm({
    super.key,
    required this.cubit,
    required this.state,
    required this.amountController,
    required this.onPickReceipt,
  });

  final PayCubit cubit;
  final PayState state;
  final TextEditingController amountController;
  final VoidCallback onPickReceipt;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PaymentNoteCard(),
        const Gap(20),
        const PaymentFieldLabel(labelKey: 'transfer_currency'),
        const Gap(10),
        PaymentCurrencySelector(
          selected: cubit.currency,
          onChanged: cubit.changeCurrency,
        ),
        const Gap(20),
        const PaymentFieldLabel(
          labelKey: 'transfer_amount',
          hintKey: 'transfer_amount_hint',
        ),
        const Gap(10),
        PaymentAmountField(
          controller: amountController,
          currency: cubit.currency,
        ),
        const Gap(20),
        const PaymentFieldLabel(
          labelKey: 'transfer_method',
          hintKey: 'transfer_method_hint',
        ),
        const Gap(10),
        _Methods(cubit: cubit, state: state),
        const Gap(20),
        const PaymentFieldLabel(
          labelKey: 'transfer_receipt',
          hintKey: 'transfer_receipt_hint',
        ),
        const Gap(10),
        PaymentReceiptField(
          file: cubit.receipt,
          onTap: onPickReceipt,
          onRemove: cubit.removeReceipt,
        ),
      ],
    );
  }
}

/// "طريقة التحويل" — the options from `GET app/payment-methods`, or the state
/// the call left the column in.
class _Methods extends StatelessWidget {
  const _Methods({required this.cubit, required this.state});

  final PayCubit cubit;
  final PayState state;

  @override
  Widget build(BuildContext context) {
    if (state is PayMethodsLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (cubit.methods.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: EmptyState(
          message: state is PayMethodsError
              ? (state as PayMethodsError).message.tr()
              : 'no_payment_methods'.tr(),
          onRetry: cubit.getMethods,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final method in cubit.methods) ...[
          PaymentMethodCard(
            method: method,
            isSelected: cubit.selectedMethod?.id == method.id,
            onTap: () => cubit.selectMethod(method),
          ),
          if (method != cubit.methods.last) const Gap(12),
        ],
      ],
    );
  }
}
