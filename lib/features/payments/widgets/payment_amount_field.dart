import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skygate/features/payments/models/payment_currency.dart';

/// "مقدار المبلغ المحول" — the amount transferred, with the picked currency
/// stamped on it as a chip so the payer can see which one they are quoting.
class PaymentAmountField extends StatelessWidget {
  const PaymentAmountField({
    super.key,
    required this.controller,
    required this.currency,
  });

  final TextEditingController controller;
  final PaymentCurrency currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      // The API takes a decimal amount; anything else is rejected server side,
      // so the keyboard is narrowed to what it accepts.
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
      validator: (value) {
        final amount = num.tryParse(value?.trim() ?? '');
        if (amount == null || amount <= 0) return 'invalid_amount'.tr();
        return null;
      },
      style: theme.textTheme.titleMedium,
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        prefixIcon: _CurrencyChip(currency: currency),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        border: _border(theme.colorScheme.outline),
        enabledBorder: _border(theme.colorScheme.outline),
        focusedBorder: _border(theme.colorScheme.primary),
        errorBorder: _border(theme.colorScheme.error),
        focusedErrorBorder: _border(theme.colorScheme.error),
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color),
  );
}

/// The grey "USD" / "SYP" pill inside the field.
class _CurrencyChip extends StatelessWidget {
  const _CurrencyChip({required this.currency});

  final PaymentCurrency currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 8, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          currency.code,
          maxLines: 1,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
