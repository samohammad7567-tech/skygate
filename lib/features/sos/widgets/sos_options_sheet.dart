import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_glyph_plate.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/sos_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/sos/controller/cubit/lost_items_cubit.dart';
import 'package:skygate/features/sos/controller/cubit/sos_cubit.dart';
import 'package:skygate/features/sos/controller/cubit/support_chat_cubit.dart';
import 'package:skygate/features/sos/models/sos_option_model.dart';
import 'package:skygate/features/sos/views/lost_items_screen.dart';
import 'package:skygate/features/sos/views/quick_sos_screen.dart';
import 'package:skygate/features/sos/views/support_chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SosOptionsSheet extends StatelessWidget {
  const SosOptionsSheet({super.key});
  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<SosCubit>(),
      child: const SosOptionsSheet(),
    ),
  );

  void _open(BuildContext context, SosOption option) {
    NaivgatorHelper.popNavigation(context);

    switch (option) {
      case SosOption.quick:
        NaivgatorHelper.pushNavigation(
          context,
          BlocProvider.value(
            value: context.read<SosCubit>(),
            child: const QuickSosScreen(),
          ),
        );
      case SosOption.call:
        _dial(context);
      case SosOption.chat:
        NaivgatorHelper.pushNavigation(
          context,
          BlocProvider(
            create: (_) => SupportChatCubit()..openChat(),
            child: const SupportChatScreen(),
          ),
        );
      case SosOption.lostItems:
        NaivgatorHelper.pushNavigation(
          context,
          BlocProvider(
            create: (_) => LostItemsCubit()..getItems(),
            child: const LostItemsScreen(),
          ),
        );
    }
  }

  Future<void> _dial(BuildContext context) async {
    final launched = await launchUrl(SosContacts.dialUri);
    if (!launched && context.mounted) {
      showToast(context, 'sos_call_failed'.tr(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.s)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(10.s),
            const SheetHandle(),
            Gap(16.s),
            for (final option in SosOption.values) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.s),
                child: _OptionRow(
                  option: option,
                  onTap: () => _open(context, option),
                ),
              ),
              Gap(12.s),
            ],
            Gap(4.s),
          ],
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({required this.option, required this.onTap});

  final SosOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitleKey = option.subtitleKey;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(14.s),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.s),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.s, vertical: 12.s),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.s),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Row(
            children: [
              Transform.flip(
                flipX: Directionality.of(context) == TextDirection.rtl,
                child: AppImage(
                  SosAssets.chevron,
                  height: 18.s,
                  width: 18.s,
                  color: theme.colorScheme.primary,
                ),
              ),
              Gap(8.s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (option == SosOption.chat) const _OnlineBadge(),
                        Flexible(
                          child: Text(
                            option.titleKey.tr(),
                            textAlign: TextAlign.end,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall,
                          ),
                        ),
                      ],
                    ),
                    Gap(4.s),
                    Text(
                      subtitleKey?.tr() ?? SosContacts.emergencyNumber,
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: subtitleKey == null
                          ? TextDirection.ltr
                          : null,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(10.s),
              AppGlyphPlate(asset: option.icon, size: 42.s, glyphSize: 20.s),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnlineBadge extends StatelessWidget {
  const _OnlineBadge();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsetsDirectional.only(end: 8.s),
      child: Text(
        'sos_online'.tr(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(color: AppColors.success),
      ),
    );
  }
}
