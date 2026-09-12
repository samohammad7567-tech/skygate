import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/passport_mrz_zone.dart';
import 'package:skygate/core/components/placeholder_bar.dart';
import 'package:skygate/core/components/scan_corner_frame.dart';
import 'package:skygate/core/utils/app_scale.dart';

class PassportScanPreview extends StatelessWidget {
  const PassportScanPreview({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScanCornerFrame(
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18.s),
            child: Container(
              color: theme.colorScheme.surface,
              padding: EdgeInsets.fromLTRB(16.s, 34.s, 16.s, 16.s),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PlaceholderBar(widthFactor: 1, height: 9.s),
                  Gap(14.s),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(child: _TextBlock()),
                      Gap(12.s),
                      const _PhotoBox(),
                    ],
                  ),
                  Gap(20.s),
                  const PassportMrzZone(),
                ],
              ),
            ),
          ),
          Positioned.fill(child: _Sweep(progress: progress)),
          const Positioned(top: -14, child: _ScanningPill()),
        ],
      ),
    );
  }
}

class _TextBlock extends StatelessWidget {
  const _TextBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlaceholderBar(widthFactor: 0.55),
        Gap(9.s),
        PlaceholderBar(widthFactor: 0.95),
        Gap(9.s),
        PlaceholderBar(widthFactor: 0.7),
        Gap(9.s),
        PlaceholderBar(widthFactor: 0.85),
        Gap(9.s),
        PlaceholderBar(widthFactor: 0.6),
      ],
    );
  }
}

class _PhotoBox extends StatelessWidget {
  const _PhotoBox();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScanCornerFrame(
      size: 22.s,
      child: Container(
        height: 78.s,
        width: 78.s,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.person, size: 44.s, color: theme.colorScheme.primary),
      ),
    );
  }
}

class _Sweep extends StatelessWidget {
  const _Sweep({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return IgnorePointer(
      child: Align(
        alignment: Alignment(0, progress * 2 - 1),
        child: Container(
          height: 46.s,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primary.withValues(alpha: 0),
                primary.withValues(alpha: 0.14),
                primary.withValues(alpha: 0.30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScanningPill extends StatelessWidget {
  const _ScanningPill();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.s, vertical: 7.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.s),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 8.s,
            width: 8.s,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          Gap(8.s),
          Text('scanning_now'.tr(), style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
