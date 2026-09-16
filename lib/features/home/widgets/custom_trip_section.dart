import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/home_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/home/widgets/custom_trip_artwork.dart';
import 'package:skygate/features/home/widgets/custom_trip_feature.dart';
import 'package:skygate/features/home/widgets/custom_trip_notice.dart';

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
      padding: EdgeInsets.symmetric(horizontal: 20.s),
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
          SizedBox(height: 14.s),
          Container(
            height: _cardHeight,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(18.s),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
      padding: EdgeInsets.fromLTRB(12.s, 16.s, 12.s, 16.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'design_your_own_trip'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 16.fs),
                ),
              ),
              AppImage(HomeAssets.crown, width: 34.s, height: 34.s),
              SizedBox(width: 10.s),
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
            radius: 8.s,
          ),
        ],
      ),
    );
  }
}
