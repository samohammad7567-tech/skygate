import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Placeholder body for tabs that are not designed yet.
class ComingSoonView extends StatelessWidget {
  const ComingSoonView({super.key, required this.titleKey});

  final String titleKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(titleKey.tr(), style: theme.textTheme.titleMedium),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
      ),
      body: Center(
        child: Text(
          'coming_soon'.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge,
        ),
      ),
    );
  }
}
