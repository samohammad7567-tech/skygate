import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_id_card.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_sheet.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/card_assets.dart';
import 'package:skygate/core/utils/app_format.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/cards/models/luggage_tag_model.dart';
import 'package:skygate/features/cards/models/trip_pilgrim_model.dart';
import 'package:skygate/features/cards/widgets/card_field_row.dart';
import 'package:skygate/features/cards/widgets/pilgrim_card_back.dart';

class LuggageCardSheet extends StatelessWidget {
  const LuggageCardSheet({
    super.key,
    required this.tag,
    required this.pilgrim,
    this.tripNumber,
    this.tripDate,
  });

  final LuggageTagModel tag;
  final TripPilgrimModel pilgrim;
  final String? tripNumber;
  final DateTime? tripDate;

  static Future<void> show(
    BuildContext context, {
    required LuggageTagModel tag,
    required TripPilgrimModel pilgrim,
    String? tripNumber,
    DateTime? tripDate,
  }) => showAppSheet<void>(
    context,
    builder: (_) => LuggageCardSheet(
      tag: tag,
      pilgrim: pilgrim,
      tripNumber: tripNumber,
      tripDate: tripDate,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.s, 12.s, 20.s, 20.s),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SheetHandle(),
              Gap(14.s),
              Text(
                'luggage_card_preview'.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge,
              ),
              Gap(16.s),
              AppIdCard(
                header: const CardTitleBand(
                  titleKey: 'luggage_card',
                  latinTitle: 'LUGGAGE ID CARD',
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Number(value: tag.shortNumber),
                    Gap(14.s),
                    const AppCardRule(),
                    CardFieldRow(
                      asset: CardAssets.pilgrimName,
                      startLabelKey: 'pilgrim_name',
                      startValue: pilgrim.displayName,
                    ),
                    CardFieldRow(
                      asset: CardAssets.tickets,
                      startLabelKey: 'trip_number',
                      startValue: tripNumber,
                    ),
                    CardFieldRow(
                      asset: CardAssets.calendar,
                      startLabelKey: 'trip_date',
                      startValue: AppFormat.numericDate(tripDate),
                    ),
                    Gap(14.s),
                    _Footer(qr: tag.qrUrl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Number extends StatelessWidget {
  const _Number({required this.value});

  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          'luggage_number'.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.primary),
        ),
        Gap(4.s),
        Text(
          value ?? '—',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: 40.fs,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.qr});

  final String? qr;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CardQr(url: qr, size: 86.s),
        AppImage(CardAssets.brandMark, height: 30.s),
      ],
    );
  }
}
