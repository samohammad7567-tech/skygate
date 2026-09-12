import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/dashed_box.dart';
import 'package:skygate/core/components/upload_size_chip.dart';
import 'package:skygate/core/constants/sos_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

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
      radius: 14.s,
      padding: EdgeInsets.symmetric(horizontal: 16.s, vertical: 26.s),
      child: Column(
        children: [
          AppImage(
            SosAssets.camera,
            height: 32.s,
            width: 32.s,
            color: theme.colorScheme.primary,
          ),
          Gap(12.s),
          Text(
            'lost_add_photo'.tr(),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium,
          ),
          Gap(10.s),
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
          borderRadius: BorderRadius.circular(14.s),
          child: Image.file(
            file,
            height: 180.s,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        PositionedDirectional(
          top: 8.s,
          end: 8.s,
          child: Material(
            color: theme.colorScheme.surface,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onRemove,
              child: SizedBox(
                height: 32.s,
                width: 32.s,
                child: Icon(
                  Icons.close,
                  size: 18.s,
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
