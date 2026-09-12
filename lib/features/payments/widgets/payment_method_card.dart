import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/payments/models/payment_method_model.dart';
import 'package:skygate/features/payments/widgets/payment_radio.dart';

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
    final borderRadius = BorderRadius.circular(14.s);

    return Material(
      color: isSelected
          ? theme.colorScheme.surfaceContainerHighest
          : theme.colorScheme.surface,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          padding: EdgeInsets.all(12.s),
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
                padding: EdgeInsets.only(top: 2.s),
                child: PaymentRadio(isSelected: isSelected),
              ),
              Gap(10.s),
              Expanded(child: _Body(method: method)),
              Gap(10.s),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.s),
                child: CachedImage(
                  url: method.image,
                  fallbackAsset: method.logoFallback,
                  height: 40.s,
                  width: 52.s,
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
          Gap(4.s),
          Text(
            method.subtitle!,
            textAlign: TextAlign.end,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(color: muted),
          ),
        ],
        for (final instruction in method.instructions) ...[
          Gap(3.s),
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
