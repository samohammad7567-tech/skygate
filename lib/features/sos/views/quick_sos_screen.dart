import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/constants/sos_assets.dart';
import 'package:skygate/features/sos/controller/cubit/sos_cubit.dart';
import 'package:skygate/features/sos/widgets/sos_audience_card.dart';
import 'package:skygate/features/sos/widgets/sos_hold_button.dart';
import 'package:skygate/features/sos/widgets/sos_note_banner.dart';
import 'package:skygate/features/sos/widgets/sos_steps_card.dart';

class QuickSosScreen extends StatelessWidget {
  const QuickSosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<SosCubit, SosState>(
          listener: (context, state) {
            if (state is SosRaised) {
              showToast(context, 'sos_sent'.tr());
            } else if (state is SosFailed) {
              showToast(context, state.message.tr(), isError: true);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                AppPageHeader(title: 'sos_option_quick'.tr()),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                    children: const [
                      SosNoteBanner(
                        titleKey: 'sos_system_title',
                        messageKey: 'sos_system_desc',
                      ),
                      Gap(24),
                      Center(child: SosHoldButton()),
                      Gap(24),
                      SosAudienceCard(),
                      Gap(14),
                      SosStepsCard(),
                      Gap(14),
                      SosNoteBanner(
                        messageKey: 'sos_keep_location_on',
                        icon: SosAssets.stepLocation,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
