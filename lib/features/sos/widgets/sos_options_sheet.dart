// `easy_localization` re-exports `intl`, whose own `TextDirection` would
// shadow the one `Directionality` answers with.
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
    // The sheet closes first: whatever the row opens should come back to the
    // tab, not to a sheet still sitting on top of it.
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
    // A device with no dialler — a tablet, an emulator — must say so rather
    // than swallow the tap on an emergency affordance.
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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(10),
            const SheetHandle(),
            const Gap(16),
            for (final option in SosOption.values) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _OptionRow(
                  option: option,
                  onTap: () => _open(context, option),
                ),
              ),
              const Gap(12),
            ],
            const Gap(4),
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
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Row(
            children: [
              // The chevron points back along the reading direction, which is
              // what "opens onto" means in both languages.
              Transform.flip(
                flipX: Directionality.of(context) == TextDirection.rtl,
                child: AppImage(
                  SosAssets.chevron,
                  height: 18,
                  width: 18,
                  color: theme.colorScheme.primary,
                ),
              ),
              const Gap(8),
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
                    const Gap(4),
                    Text(
                      subtitleKey?.tr() ?? SosContacts.emergencyNumber,
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      // The phone number is Latin digits inside Arabic copy,
                      // so it is pinned LTR to keep the "+" on its left.
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
              const Gap(10),
              AppGlyphPlate(asset: option.icon, size: 42, glyphSize: 20),
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
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: Text(
        'sos_online'.tr(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(color: AppColors.success),
      ),
    );
  }
}
