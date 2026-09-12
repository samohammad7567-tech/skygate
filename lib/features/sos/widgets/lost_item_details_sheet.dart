import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/sos/models/lost_item_model.dart';
import 'package:skygate/features/sos/widgets/lost_item_card.dart';

class LostItemDetailsSheet extends StatelessWidget {
  const LostItemDetailsSheet({super.key, required this.item, this.onAction});

  final LostItemModel item;
  final VoidCallback? onAction;

  static Future<void> show(
    BuildContext context, {
    required LostItemModel item,
    VoidCallback? onAction,
  }) => showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => LostItemDetailsSheet(item: item, onAction: onAction),
  );
  String? get _actionKey => switch (item.status) {
    LostItemStatus.reported => 'lost_action_mark_found',
    LostItemStatus.found => 'lost_action_collect',
    LostItemStatus.returned || LostItemStatus.closed => null,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionKey = _actionKey;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.s)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.s, 10.s, 16.s, 16.s),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SheetHandle(),
              Gap(14.s),
              Text(
                'lost_details_title'.tr(),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge,
              ),
              Gap(14.s),
              LostItemCard(item: item),
              Gap(18.s),
              if (actionKey != null)
                CustomButton(
                  label: actionKey.tr(),
                  height: 48.s,
                  width: double.infinity,
                  onPressed: onAction,
                )
              else
                Text(
                  'lost_no_action'.tr(),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              Gap(6.s),
              TextButton(
                onPressed: () => NaivgatorHelper.popNavigation(context),
                child: Text('close'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
