import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/dashed_box.dart';
import 'package:skygate/core/components/upload_size_chip.dart';
import 'package:skygate/core/constants/sos_assets.dart';

class LostPhotoPicker extends StatelessWidget {
  const LostPhotoPicker({
    super.key,
    required this.photo,
    required this.onPick,
    required this.onRemove,
  });

  final File? photo;
  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final file = photo;
    if (file != null) return _Preview(file: file, onRemove: onRemove);

    final theme = Theme.of(context);

    return DashedBox(
      onTap: onPick,
      radius: 14,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
      child: Column(
        children: [
          AppImage(
            SosAssets.camera,
            height: 32,
            width: 32,
            color: theme.colorScheme.primary,
          ),
          const Gap(12),
          Text(
            'lost_add_photo'.tr(),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium,
          ),
          const Gap(10),
          const UploadSizeChip(),
        ],
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.file, required this.onRemove});

  final File file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.file(
            file,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        PositionedDirectional(
          top: 8,
          end: 8,
          child: Material(
            color: theme.colorScheme.surface,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onRemove,
              child: SizedBox(
                height: 32,
                width: 32,
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
