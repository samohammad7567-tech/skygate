import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/dashed_box.dart';
import 'package:skygate/core/components/upload_size_chip.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/profile/widgets/profile_avatar.dart';

class ProfilePhotoField extends StatelessWidget {
  const ProfilePhotoField({
    super.key,
    required this.image,
    required this.onTap,
    required this.onRemove,
    this.url,
  });
  final File? image;
  final String? url;

  final VoidCallback onTap;
  final VoidCallback onRemove;

  static const double _avatarSize = 112;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('add_profile_photo'.tr(), style: theme.textTheme.bodyMedium),
        Gap(12.s),
        DashedBox(
          onTap: onTap,
          padding: EdgeInsets.symmetric(horizontal: 16.s, vertical: 22.s),
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  ProfileAvatar(url: url, file: image, size: _avatarSize),
                  Container(
                    height: 32.s,
                    width: 32.s,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.surface,
                        width: 2.s,
                      ),
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      size: 20.s,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
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
        ),
      ],
    );
  }
}
