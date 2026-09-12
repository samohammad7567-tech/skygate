import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_outlined_button.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/utils/app_scale.dart';

class ProfileFormActions extends StatelessWidget {
  const ProfileFormActions({
    super.key,
    required this.onSave,
    required this.onCancel,
    this.isSaving = false,
    this.saveLabelKey = 'save_changes',
  });

  final VoidCallback onSave;
  final VoidCallback onCancel;
  final bool isSaving;
  final String saveLabelKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          label: saveLabelKey.tr(),
          width: double.infinity,
          height: 48.s,
          isLoading: isSaving,
          onPressed: onSave,
        ),
        Gap(12.s),
        AppOutlinedButton(
          label: 'cancel'.tr(),
          // Disabled while the call is out, so backing out cannot dispose the
          // cubit mid-request.
          onPressed: isSaving ? null : onCancel,
        ),
      ],
    );
  }
}
