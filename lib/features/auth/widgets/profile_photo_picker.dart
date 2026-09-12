import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/dashed_box.dart';
import 'package:skygate/core/components/upload_size_chip.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

class ProfilePhotoPicker extends StatelessWidget {
  const ProfilePhotoPicker({
    super.key,
    required this.image,
    required this.onTap,
    required this.onRemove,
  });

  final File? image;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  static const double _avatarSize = 118;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DashedBox(
      onTap: onTap,
      padding: EdgeInsets.symmetric(horizontal: 16.s, vertical: 22.s),
      child: Column(
        children: [
          if (image == null)
            const AppImage(AuthAssets.addAccount, height: _avatarSize)
          else
            ClipOval(
              child: Image.file(
                image!,
                height: _avatarSize,
                width: _avatarSize,
                fit: BoxFit.cover,
              ),
            ),
          Gap(14.s),
          Text(
            'tap_to_upload_photo'.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          Gap(4.s),
          Text(
            'pick_from_gallery_or_camera'.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
          Gap(12.s),
          const UploadSizeChip(),
          if (image != null) ...[
            Gap(8.s),
            TextButton(
              onPressed: onRemove,
              child: Text(
                'remove_file'.tr(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
