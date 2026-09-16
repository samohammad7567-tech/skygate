import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/my_trips_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

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
            icon: AppImage(
              MyTripsAssets.download,
              height: 18.s,
              width: 18.s,
              color: AppColors.surface,
            ),
          ),
        ),
        SizedBox(width: 10.s),
        Expanded(
          child: SizedBox(
            height: _height,
            child: OutlinedButton(
              onPressed: onPreview,
              style: OutlinedButton.styleFrom(
                backgroundColor: theme.colorScheme.surface,
                side: BorderSide(color: theme.colorScheme.primary),
                padding: EdgeInsets.symmetric(horizontal: 8.s),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.s),
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
                  SizedBox(width: 8.s),
                  AppImage(
                    MyTripsAssets.preview,
                    height: 18.s,
                    width: 18.s,
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
