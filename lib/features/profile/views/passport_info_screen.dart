import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/profile/controller/cubit/profile_cubit.dart';
import 'package:skygate/features/profile/views/edit_passport_screen.dart';
import 'package:skygate/features/profile/widgets/passport_info_card.dart';
import 'package:skygate/features/profile/widgets/profile_scaffold.dart';
import 'package:skygate/core/components/app_section_title.dart';

class PassportInfoScreen extends StatelessWidget {
  const PassportInfoScreen({super.key});

  void _edit(BuildContext context) {
    final cubit = context.read<ProfileCubit>();
    cubit.resetPassportForm();
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: cubit, child: const EditPassportScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();

        return ProfileScaffold(
          title: 'nav_account'.tr(),
          children: [
            AppSectionTitle(text: 'passport_information'.tr()),
            Gap(12.s),
            PassportInfoCard(passport: cubit.passport),
            Gap(18.s),
            CustomButton(
              label: 'edit_passport_information'.tr(),
              height: 48.s,
              onPressed: () => _edit(context),
            ),
          ],
        );
      },
    );
  }
}
