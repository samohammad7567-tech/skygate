import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/features/payments/models/payment_method_model.dart';
import 'package:skygate/features/payments/widgets/payment_radio.dart';

/// One option of "طريقة التحويل": the ring, the provider's name over its
/// bulleted steps, and the logo.
///
/// Every line of the body is authored by the back office — the card renders
/// whatever `instructions` carries rather than knowing anything about a
/// particular provider.
class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  final PaymentMethodModel method;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(14);

    return Material(
      color: isSelected
          ? theme.colorScheme.surfaceContainerHighest
          : theme.colorScheme.surface,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: PaymentRadio(isSelected: isSelected),
              ),
              const Gap(10),
              Expanded(child: _Body(method: method)),
              const Gap(10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedImage(
                  url: method.image,
                  fallbackAsset: method.logoFallback,
                  height: 40,
                  width: 52,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The name, the subtitle and one bullet per instruction.
class _Body extends StatelessWidget {
  const _Body({required this.method});

  final PaymentMethodModel method;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          method.name ?? '—',
          textAlign: TextAlign.end,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        if (method.subtitle != null) ...[
          const Gap(4),
          Text(
            method.subtitle!,
            textAlign: TextAlign.end,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(color: muted),
          ),
        ],
        for (final instruction in method.instructions) ...[
          const Gap(3),
          Text(
            '• $instruction',
            textAlign: TextAlign.end,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(color: muted),
          ),
        ],
      ],
    );
  }
}
