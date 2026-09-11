import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_glyph_plate.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/sos_assets.dart';
import 'package:skygate/features/sos/models/sos_option_model.dart';

class SosStepsCard extends StatelessWidget {
  const SosStepsCard({super.key});
  static const List<Color> _accents = [
    AppColors.success,
    AppColors.primary,
    AppColors.accent,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final steps = SosInfoModel.steps;

    return AppCard(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      radius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'sos_steps_title'.tr(),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge,
          ),
          const Gap(14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AppImage(
                  SosAssets.stepsMap,
                  height: 132,
                  width: 108,
                  fit: BoxFit.cover,
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  children: [
                    for (var i = 0; i < steps.length; i++)
                      _StepRow(step: steps[i], accent: _accents[i]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step, required this.accent});

  final SosInfoModel step;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              step.titleKey.tr(),
              textAlign: TextAlign.end,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
            ),
          ),
          const Gap(8),
          Container(
            height: 7,
            width: 7,
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
          ),
          const Gap(8),
          AppGlyphPlate(
            asset: step.icon,
            size: 36,
            glyphSize: 18,
            color: accent,
            background: accent.withValues(alpha: 0.12),
          ),
        ],
      ),
    );
  }
}
