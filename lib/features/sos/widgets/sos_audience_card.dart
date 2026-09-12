import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_card.dart';
import 'package:skygate/core/components/app_glyph_plate.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/sos/models/sos_option_model.dart';

class SosAudienceCard extends StatelessWidget {
  const SosAudienceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: EdgeInsets.fromLTRB(14.s, 16.s, 14.s, 18.s),
      radius: 16.s,
      child: Column(
        children: [
          Text(
            'sos_notify_title'.tr(),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge,
          ),
          Gap(6.s),
          Text(
            'sos_notify_desc'.tr(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          Gap(16.s),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final party in SosInfoModel.audience)
                Expanded(child: _AudienceChip(party: party)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AudienceChip extends StatelessWidget {
  const _AudienceChip({required this.party});

  final SosInfoModel party;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        AppGlyphPlate(asset: party.icon, size: 42.s, glyphSize: 20.s),
        Gap(8.s),
        Text(
          party.titleKey.tr(),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
