import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skygate/core/components/app_background.dart';
import 'package:skygate/core/components/app_title_header.dart';
import 'package:skygate/core/components/passport_scan_preview.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/auth/controller/cubit/register_cubit.dart';
import 'package:skygate/features/auth/views/passport_confirm_screen.dart';

/// "استخراج بيانات جواز السفر" — picks the passport photo, uploads it and
/// sweeps the mocked page until the MRZ comes back.
class PassportScanScreen extends StatefulWidget {
  const PassportScanScreen({super.key, required this.source});

  /// Where the passport photo comes from; chosen on the previous screen.
  final ImageSource source;

  @override
  State<PassportScanScreen> createState() => _PassportScanScreenState();
}

class _PassportScanScreenState extends State<PassportScanScreen>
    with SingleTickerProviderStateMixin {
  /// Owned by the screen; drives the sweep line over the passport preview.
  late final AnimationController _sweep = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void initState() {
    super.initState();
    context.read<RegisterCubit>().scanPassportFrom(widget.source);
  }

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  void _onState(BuildContext context, RegisterState state) {
    if (state is PassportScanned) {
      NaivgatorHelper.pushReplacementNavigation(
        context,
        BlocProvider.value(
          value: context.read<RegisterCubit>(),
          child: const PassportConfirmScreen(),
        ),
      );
    } else if (state is PassportScanError) {
      showToast(context, state.message.tr(), isError: true);
      NaivgatorHelper.popNavigation(context);
    } else if (state is PassportScanCancelled) {
      NaivgatorHelper.popNavigation(context);
    } else if (state is FileTooLarge) {
      showToast(context, 'file_too_large'.tr(), isError: true);
      NaivgatorHelper.popNavigation(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: BlocListener<RegisterCubit, RegisterState>(
            listener: _onState,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
              child: Column(
                children: [
                  AppTitleHeader(
                    title: 'extract_passport_data'.tr(),
                    showBack: true,
                  ),
                  const Gap(36),
                  AnimatedBuilder(
                    animation: _sweep,
                    builder: (_, _) =>
                        PassportScanPreview(progress: _sweep.value),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
