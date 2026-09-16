import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/sos_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/sos/controller/cubit/sos_cubit.dart';
import 'package:skygate/features/sos/widgets/sos_options_sheet.dart';

class SosButton extends StatelessWidget {
  const SosButton({super.key});

  static const double size = 56;
  static const double bottomInset = 30;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SosCubit, SosState>(
      builder: (context, state) {
        final isRaised = context.read<SosCubit>().isRaised;
        final background = isRaised
            ? AppColors.error
            : theme.colorScheme.primary;

        return Semantics(
          button: true,
          label: 'sos'.tr(),
          child: Material(
            color: background,
            shape: const CircleBorder(),
            elevation: 6,
            shadowColor: background.withValues(alpha: 0.45),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => SosOptionsSheet.show(context),
              child: SizedBox(
                height: size.s,
                width: size.s,
                child: Center(
                  child: AppImage(
                    SosAssets.sos,
                    height: 26.s,
                    width: 26.s,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
