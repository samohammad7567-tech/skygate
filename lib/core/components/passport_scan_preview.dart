import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/passport_mrz_zone.dart';
import 'package:skygate/core/components/placeholder_bar.dart';
import 'package:skygate/core/components/scan_corner_frame.dart';

/// Mock passport page shown while the MRZ is being read.
///
/// [progress] runs 0 → 1 and drives the sweep line; the screen owns the
/// animation controller that produces it.
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
            borderRadius: BorderRadius.circular(18),
            child: Container(
              color: theme.colorScheme.surface,
              padding: const EdgeInsets.fromLTRB(16, 34, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const PlaceholderBar(widthFactor: 1, height: 9),
                  const Gap(14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(child: _TextBlock()),
                      const Gap(12),
                      const _PhotoBox(),
                    ],
                  ),
                  const Gap(20),
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlaceholderBar(widthFactor: 0.55),
        Gap(9),
        PlaceholderBar(widthFactor: 0.95),
        Gap(9),
        PlaceholderBar(widthFactor: 0.7),
        Gap(9),
        PlaceholderBar(widthFactor: 0.85),
        Gap(9),
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
      size: 22,
      child: Container(
        height: 78,
        width: 78,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.person, size: 44, color: theme.colorScheme.primary),
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
          height: 46,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const Gap(8),
          Text('scanning_now'.tr(), style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
