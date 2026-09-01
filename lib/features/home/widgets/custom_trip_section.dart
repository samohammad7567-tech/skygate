import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/home_assets.dart';
import 'package:skygate/features/home/widgets/custom_trip_artwork.dart';
import 'package:skygate/features/home/widgets/custom_trip_feature.dart';
import 'package:skygate/features/home/widgets/custom_trip_notice.dart';

/// "صمم رحلتك الخاصة" banner: Kaaba artwork with the VIP pennant on the start
/// side, copy and CTA on the end side.
class CustomTripSection extends StatelessWidget {
  const CustomTripSection({
    super.key,
    this.isSubmitting = false,
    this.onRequest,
  });

  final bool isSubmitting;
  final VoidCallback? onRequest;

  static const double _cardHeight = 300;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'design_your_own_trip'.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 14),
          Container(
            height: _cardHeight,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Roughly the 40 / 60 split the design uses.
                const Expanded(flex: 40, child: CustomTripArtwork()),
                Expanded(
                  flex: 60,
                  child: _Content(
                    isSubmitting: isSubmitting,
                    onRequest: onRequest,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.isSubmitting, this.onRequest});

  final bool isSubmitting;
  final VoidCallback? onRequest;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // The orange plate behind the crown is part of the export.
              AppImage(HomeAssets.crown, width: 34, height: 34),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'design_your_own_trip'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
                ),
              ),
            ],
          ),
          Text(
            'design_your_own_trip_desc'.tr(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall,
          ),
          const CustomTripFeatures(),
          CustomTripNotice(label: 'we_send_approval_soon'.tr()),
          CustomButton(
            label: 'request_your_trip'.tr(),
            onPressed: onRequest,
            isLoading: isSubmitting,
            backgroundColor: theme.colorScheme.secondary,
            radius: 8,
          ),
        ],
      ),
    );
  }
}
