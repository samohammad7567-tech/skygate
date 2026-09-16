import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skygate/core/components/app_background.dart';
import 'package:skygate/core/components/app_title_header.dart';
import 'package:skygate/core/components/passport_scan_preview.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/booking/controller/cubit/booking_cubit.dart';
import 'package:skygate/features/booking/views/booking_passport_confirm_screen.dart';

class BookingPassportScanScreen extends StatefulWidget {
  const BookingPassportScanScreen({super.key, required this.source});
  final ImageSource source;

  @override
  State<BookingPassportScanScreen> createState() =>
      _BookingPassportScanScreenState();
}

class _BookingPassportScanScreenState extends State<BookingPassportScanScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sweep = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

  @override
  void initState() {
    super.initState();
    context.read<BookingCubit>().scanPassportFrom(widget.source);
  }

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  void _onState(BuildContext context, BookingState state) {
    if (state is PassportScanned) {
      NaivgatorHelper.pushReplacementNavigation(
        context,
        BlocProvider.value(
          value: context.read<BookingCubit>(),
          child: const BookingPassportConfirmScreen(),
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
          child: BlocListener<BookingCubit, BookingState>(
            listener: _onState,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.s, 32.s, 24.s, 32.s),
              child: Column(
                children: [
                  AppTitleHeader(
                    title: 'extract_passport_data'.tr(),
                    showBack: true,
                  ),
                  Gap(36.s),
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
