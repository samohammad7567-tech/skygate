import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_id_card.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/card_assets.dart';
import 'package:skygate/features/cards/models/pilgrim_card_model.dart';

/// "معاينة الوجه الخلفي" — the scannable face: the card's title, the QR a
/// supervisor reads, and the number to ring if the pilgrim is lost.
class PilgrimCardBack extends StatelessWidget {
  const PilgrimCardBack({super.key, required this.card});

  final PilgrimCardModel? card;

  @override
  Widget build(BuildContext context) {
    return AppIdCard(
      header: const CardTitleBand(
        titleKey: 'pilgrim_card',
        latinTitle: 'PILGRIM CARD',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          CardQr(url: card?.qrUrl, size: 170),
          const SizedBox(height: 20),
          const AppCardRule(),
          const SizedBox(height: 16),
          _EmergencyBox(phone: card?.emergencyPhone),
        ],
      ),
    );
  }
}

/// The two-line title a card's navy band carries — Arabic over the Latin
/// name, centred. Shared with the luggage tag.
class CardTitleBand extends StatelessWidget {
  const CardTitleBand({
    super.key,
    required this.titleKey,
    required this.latinTitle,
  });

  final String titleKey;
  final String latinTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          titleKey.tr(),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.surface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          latinTitle,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.surface,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

/// The QR the API publishes as an image URL. Nothing is generated on device —
/// a card with no QR yet shows the outline glyph instead of a broken box.
class CardQr extends StatelessWidget {
  const CardQr({super.key, required this.url, this.size = 150});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: url == null
            ? AppImage(
                CardAssets.qr,
                height: size,
                width: size,
                color: AppColors.textSecondary,
              )
            : CachedImage(
                url: url,
                fallbackAsset: CardAssets.qr,
                height: size,
                width: size,
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}

class _EmergencyBox extends StatelessWidget {
  const _EmergencyBox({required this.phone});

  final String? phone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.accent),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppImage(
              CardAssets.emergency,
              height: 24,
              width: 24,
              color: AppColors.primary,
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'emergency_number'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  phone ?? '—',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
