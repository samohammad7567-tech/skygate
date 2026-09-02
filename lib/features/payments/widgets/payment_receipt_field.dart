import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/dashed_box.dart';
import 'package:skygate/core/components/upload_size_chip.dart';
import 'package:skygate/core/constants/payment_assets.dart';

/// "صورة إيصال الحوالة" — the dashed drop zone the receipt photo goes into,
/// showing the picked image back once there is one.
class PaymentReceiptField extends StatelessWidget {
  const PaymentReceiptField({
    super.key,
    required this.file,
    required this.onTap,
    required this.onRemove,
  });

  final File? file;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final picked = file;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DashedBox(
          onTap: onTap,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: picked == null ? const _Empty() : _Attached(file: picked),
        ),
        if (picked != null)
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
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        AppImage(
          PaymentAssets.upload,
          height: 26,
          color: theme.colorScheme.primary,
        ),
        const Gap(8),
        Text(
          'tap_to_upload_file'.tr(),
          textAlign: TextAlign.center,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const Gap(10),
        // The API caps a receipt at 2 MB, tighter than the pilgrim documents.
        const UploadSizeChip(labelKey: 'max_receipt_size'),
      ],
    );
  }
}

class _Attached extends StatelessWidget {
  const _Attached({required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            file,
            height: 140,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const Gap(8),
        Text(
          'file_uploaded'.tr(),
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}
