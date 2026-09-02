import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/image_source_sheet.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/features/payments/controller/cubit/pay_cubit.dart';
import 'package:skygate/features/payments/models/financial_transaction_model.dart';
import 'package:skygate/features/payments/widgets/payment_sheet_form.dart';

/// "معلومات الدفع" — the sheet "ادفع الآن" opens.
///
/// Resolves to the transaction `POST app/financial-transactions` created, or
/// `null` when the payer backs out.
Future<FinancialTransactionModel?> showPaymentSheet(
  BuildContext context, {
  required int bookingId,
}) {
  return showModalBottomSheet<FinancialTransactionModel>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => BlocProvider(
      create: (_) => PayCubit(bookingId)..getMethods(),
      child: const _PaymentSheet(),
    ),
  );
}

class _PaymentSheet extends StatefulWidget {
  const _PaymentSheet();

  @override
  State<_PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<_PaymentSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickReceipt() async {
    final source = await showImageSourceSheet(context);
    if (source == null || !mounted) return;
    await context.read<PayCubit>().pickReceipt(source);
  }

  void _submit() {
    final cubit = context.read<PayCubit>();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!cubit.canSubmit) {
      showToast(context, 'select_payment_method'.tr(), isError: true);
      return;
    }
    cubit.submit(amount: _amountController.text);
  }

  void _onState(BuildContext context, PayState state) {
    if (state is PaySubmitted) {
      Navigator.of(context).pop(state.transaction);
    } else if (state is PaySubmitError) {
      showToast(context, state.message.tr(), isError: true);
    } else if (state is PayReceiptTooLarge) {
      showToast(context, 'receipt_too_large'.tr(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<PayCubit, PayState>(
      listener: _onState,
      builder: (context, state) {
        final cubit = context.read<PayCubit>();

        return Padding(
          // Lifts the sheet clear of the keyboard while the amount is typed.
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: FractionallySizedBox(
            heightFactor: 0.92,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(12),
                const SheetHandle(),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      children: [
                        Text(
                          'payment_information'.tr(),
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge,
                        ),
                        const Gap(16),
                        PaymentSheetForm(
                          cubit: cubit,
                          state: state,
                          amountController: _amountController,
                          onPickReceipt: _pickReceipt,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: CustomButton(
                    label: 'send'.tr(),
                    height: 48,
                    width: double.infinity,
                    isLoading: state is PaySubmitLoading,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
