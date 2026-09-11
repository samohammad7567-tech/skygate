import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/vip_trip_assets.dart';

class VipRequirementsField extends StatelessWidget {
  const VipRequirementsField({
    super.key,
    required this.controller,
    required this.maxLength,
    this.onChanged,
  });

  final TextEditingController controller;
  final int maxLength;

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              maxLines: null,
              expands: true,
              maxLength: maxLength,
              textAlignVertical: TextAlignVertical.top,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'write_your_notes_here'.tr(),
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                // The box draws its own frame, and the counter would sit
                // outside it.
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                counterText: '',
              ),
            ),
          ),
          const SizedBox(width: 10),
          AppImage(
            VipTripAssets.pencil,
            height: 18,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
