import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/payments/models/payment_currency.dart';

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
        contentPadding: EdgeInsets.symmetric(horizontal: 14.s, vertical: 16.s),
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
    borderRadius: BorderRadius.circular(12.s),
    borderSide: BorderSide(color: color),
  );
}

class _CurrencyChip extends StatelessWidget {
  const _CurrencyChip({required this.currency});

  final PaymentCurrency currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(12.s, 0, 8.s, 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.s, vertical: 5.s),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8.s),
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
