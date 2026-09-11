import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class VipCard extends StatelessWidget {
  const VipCard({
    super.key,
    required this.children,
    this.totalLabelKey,
    this.totalValue,
  });

  final List<Widget> children;
  final String? totalLabelKey;
  final String? totalValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(16);

    final rule = Divider(
      height: 1,
      thickness: 1,
      indent: 14,
      endIndent: 14,
      color: theme.colorScheme.outline,
    );

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < children.length; index++) ...[
              if (index > 0) rule,
              children[index],
            ],
            if (totalLabelKey != null) ...[
              rule,
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Text(
                      totalValue ?? '—',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      child: Text(
                        totalLabelKey!.tr(),
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
