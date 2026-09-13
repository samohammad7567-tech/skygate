import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_outlined_button.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/image_source_sheet.dart';
import 'package:skygate/core/components/or_divider.dart';
import 'package:skygate/core/components/scan_launcher.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/core/components/booking_section_title.dart';
import 'package:skygate/core/components/booking_step_scaffold.dart';
import 'package:skygate/core/components/capture_instructions_card.dart';
import 'package:skygate/features/group_booking/controller/cubit/group_booking_cubit.dart';
import 'package:skygate/features/group_booking/views/group_passport_manual_screen.dart';
import 'package:skygate/features/group_booking/views/group_passport_scan_screen.dart';

class GroupVerifyScreen extends StatelessWidget {
  const GroupVerifyScreen({super.key});

  Future<void> _scan(BuildContext context) async {
    final cubit = context.read<GroupBookingCubit>();
    final source = await showImageSourceSheet(context);
    if (source == null || !context.mounted) return;

    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(
        value: cubit,
        child: GroupPassportScanScreen(source: source),
      ),
    );
  }

  void _typeManually(BuildContext context) {
    final cubit = context.read<GroupBookingCubit>();
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(
        value: cubit,
        child: const GroupPassportManualScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLeader = context.read<GroupBookingCubit>().isAddingLeader;

    return BookingStepScaffold(
      step: isLeader ? 2 : 4,
      total: GroupBookingCubit.totalSteps,
      onContinue: () => _scan(context),
      children: [
        BookingSectionTitle(
          title: isLeader ? 'data_verification'.tr() : 'add_new_traveler'.tr(),
          subtitle: isLeader
              ? 'first_traveler_data'.tr()
              : 'complete_traveler_data'.tr(),
        ),
        Gap(16.s),
        Container(
          padding: EdgeInsets.fromLTRB(16.s, 18.s, 16.s, 20.s),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16.s),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'passport_info'.tr(),
                textAlign: TextAlign.end,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Gap(18.s),
              ScanLauncher(onTap: () => _scan(context)),
              Gap(20.s),
              const CaptureInstructionsCard(),
              Gap(16.s),
              CustomButton(
                label: 'capture_and_read_passport'.tr(),
                height: 48.s,
                onPressed: () => _scan(context),
                icon: AppImage(
                  AuthAssets.camera,
                  height: 20.s,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              Gap(14.s),
              const OrDivider(),
              Gap(14.s),
              AppOutlinedButton(
                label: 'manual_entry'.tr(),
                onPressed: () => _typeManually(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
