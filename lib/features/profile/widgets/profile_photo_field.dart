import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/dashed_box.dart';
import 'package:skygate/core/components/upload_size_chip.dart';
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
        const Gap(12),
        DashedBox(
          onTap: onTap,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  ProfileAvatar(url: url, file: image, size: _avatarSize),
                  Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.surface,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      size: 20,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
              const Gap(14),
              Text(
                'tap_to_upload_photo'.tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const Gap(4),
              Text(
                'pick_from_gallery_or_camera'.tr(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall,
              ),
              const Gap(12),
              const UploadSizeChip(),
              if (image != null) ...[
                const Gap(8),
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
