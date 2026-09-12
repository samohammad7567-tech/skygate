import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/my_trips_assets.dart';

/// The "تحميل / معاينة" pair that closes every document card — a pilgrim
/// card, a luggage tag, a visa, a ticket.
///
/// Download leads in the reading direction because it is the primary action;
/// preview sits beside it as an outline. A document the API returned without
/// a file disables both rather than hiding them, so the card keeps its height
/// whichever state a row is in.
class AppDocumentActions extends StatelessWidget {
  const AppDocumentActions({
    super.key,
    required this.onDownload,
    required this.onPreview,
    this.isDownloading = false,
  });

  final VoidCallback? onDownload;
  final VoidCallback? onPreview;
  final bool isDownloading;

  static const double _height = 40;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: CustomButton(
            label: 'download'.tr(),
            height: _height,
            isLoading: isDownloading,
            onPressed: onDownload,
            icon: const AppImage(
              MyTripsAssets.download,
              height: 18,
              width: 18,
              color: AppColors.surface,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: _height,
            child: OutlinedButton(
              onPressed: onPreview,
              style: OutlinedButton.styleFrom(
                backgroundColor: theme.colorScheme.surface,
                side: BorderSide(color: theme.colorScheme.primary),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      'preview'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AppImage(
                    MyTripsAssets.preview,
                    height: 18,
                    width: 18,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
