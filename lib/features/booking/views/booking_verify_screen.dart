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
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/booking/controller/cubit/booking_cubit.dart';
import 'package:skygate/features/booking/views/booking_passport_manual_screen.dart';
import 'package:skygate/features/booking/views/booking_passport_scan_screen.dart';
import 'package:skygate/core/components/booking_section_title.dart';
import 'package:skygate/features/booking/widgets/booking_step_scaffold.dart';
import 'package:skygate/core/components/capture_instructions_card.dart';

/// Step 2 (entry) — "التحقق من البيانات". Offers the camera, or the typed
/// route through "إدخال يدوي".
class BookingVerifyScreen extends StatelessWidget {
  const BookingVerifyScreen({super.key});

  Future<void> _scan(BuildContext context) async {
    final cubit = context.read<BookingCubit>();
    final source = await showImageSourceSheet(context);
    if (source == null || !context.mounted) return;

    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(
        value: cubit,
        child: BookingPassportScanScreen(source: source),
      ),
    );
  }

  void _typeManually(BuildContext context) {
    final cubit = context.read<BookingCubit>();
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(
        value: cubit,
        child: const BookingPassportManualScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BookingStepScaffold(
      step: 2,
      onContinue: () => _scan(context),
      children: [
        BookingSectionTitle(
          title: 'data_verification'.tr(),
          subtitle: 'complete_personal_data'.tr(),
        ),
        const Gap(16),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
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
              const Gap(18),
              ScanLauncher(onTap: () => _scan(context)),
              const Gap(20),
              const CaptureInstructionsCard(),
              const Gap(16),
              CustomButton(
                label: 'capture_and_read_passport'.tr(),
                height: 48,
                onPressed: () => _scan(context),
                icon: AppImage(
                  AuthAssets.imageScanner,
                  height: 20,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              const Gap(14),
              const OrDivider(),
              const Gap(14),
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
