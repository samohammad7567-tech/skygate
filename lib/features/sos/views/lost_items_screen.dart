import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/constants/sos_assets.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/sos/controller/cubit/lost_items_cubit.dart';
import 'package:skygate/features/sos/models/lost_item_model.dart';
import 'package:skygate/features/sos/views/report_lost_item_screen.dart';
import 'package:skygate/features/sos/widgets/lost_item_card.dart';
import 'package:skygate/features/sos/widgets/lost_item_details_sheet.dart';
import 'package:skygate/features/sos/widgets/lost_items_tab_bar.dart';
import 'package:skygate/features/sos/widgets/lost_status_filter.dart';
import 'package:skygate/features/sos/widgets/sos_note_banner.dart';

class LostItemsScreen extends StatelessWidget {
  const LostItemsScreen({super.key});
  void _report(BuildContext context) {
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(
        value: context.read<LostItemsCubit>(),
        child: const ReportLostItemScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<LostItemsCubit, LostItemsState>(
          builder: (context, state) {
            final cubit = context.read<LostItemsCubit>();
            final isMine = cubit.tab == LostItemsTab.mine;

            return Column(
              children: [
                AppPageHeader(title: 'lost_items_title'.tr()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LostItemsTabBar(
                    selected: cubit.tab,
                    onChanged: cubit.changeTab,
                  ),
                ),
                const Gap(12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  // The public tab explains itself and offers the filter; the
                  // pilgrim's own tab leads with the way to file a report.
                  child: isMine
                      ? CustomButton(
                          label: 'lost_report_action'.tr(),
                          height: 48,
                          width: double.infinity,
                          onPressed: () => _report(context),
                          icon: AppImage(
                            SosAssets.report,
                            height: 18,
                            width: 18,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      : const SosNoteBanner(messageKey: 'lost_public_note'),
                ),
                const Gap(12),
                if (!isMine)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _CountRow(
                      count: cubit.items.length,
                      selected: cubit.statusFilter,
                      onChanged: cubit.filterByStatus,
                    ),
                  ),
                Expanded(child: _list(context, state, cubit)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _list(
    BuildContext context,
    LostItemsState state,
    LostItemsCubit cubit,
  ) {
    if (state is LostItemsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: cubit.getItems,
      child: BuildCondition(
        condition: cubit.items.isNotEmpty,
        builder: (_) => ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          itemCount: cubit.items.length,
          separatorBuilder: (_, _) => const Gap(12),
          itemBuilder: (_, index) => LostItemCard(
            item: cubit.items[index],
            onTap: () =>
                LostItemDetailsSheet.show(context, item: cubit.items[index]),
          ),
        ),
        fallback: (_) => ListView(
          padding: const EdgeInsets.only(top: 60),
          children: [
            EmptyState(
              message: state is LostItemsError
                  ? state.message.tr()
                  : 'lost_empty'.tr(),
              onRetry: cubit.getItems,
            ),
          ],
        ),
      ),
    );
  }
}

class _CountRow extends StatelessWidget {
  const _CountRow({
    required this.count,
    required this.selected,
    required this.onChanged,
  });

  final int count;
  final LostItemStatus? selected;
  final ValueChanged<LostItemStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        LostStatusFilter(selected: selected, onChanged: onChanged),
        const Spacer(),
        Text(
          'lost_items_count'.tr(args: ['$count']),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
