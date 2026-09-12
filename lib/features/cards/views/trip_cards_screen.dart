import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/app_tab_bar.dart';
import 'package:skygate/core/components/audience_chip.dart';
import 'package:skygate/core/components/app_expandable_tile.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/components/pilgrim_avatar.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/constants/card_assets.dart';
import 'package:skygate/features/cards/controller/cubit/trip_cards_cubit.dart';
import 'package:skygate/features/cards/models/trip_pilgrim_model.dart';
import 'package:skygate/features/cards/widgets/luggage_card_sheet.dart';
import 'package:skygate/features/cards/widgets/luggage_tag_tile.dart';
import 'package:skygate/features/cards/widgets/pilgrim_card_sheet.dart';
import 'package:skygate/features/cards/widgets/pilgrim_card_tile.dart';

/// "تفاصيل البطاقات" — every traveller on the booking, with their pilgrim
/// card under one tab and their luggage tags under the other.
class TripCardsScreen extends StatelessWidget {
  const TripCardsScreen({super.key, required this.bookingId});

  final int bookingId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TripCardsCubit(bookingId: bookingId)..getCards(),
      child: const _TripCardsBody(),
    );
  }
}

class _TripCardsBody extends StatelessWidget {
  const _TripCardsBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<TripCardsCubit, TripCardsState>(
          listenWhen: (_, state) =>
              state is DocumentOpened || state is DocumentFailed,
          listener: (context, state) {
            if (state is DocumentFailed) {
              showToast(context, state.message.tr(), isError: true);
            }
          },
          builder: (context, state) {
            final cubit = context.read<TripCardsCubit>();

            return Column(
              children: [
                AppPageHeader(title: 'cards_details'.tr()),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: AppTabBar(
                    tabs: const [
                      AppTabItem(
                        labelKey: 'tab_pilgrim_cards',
                        icon: CardAssets.pilgrimCards,
                      ),
                      AppTabItem(
                        labelKey: 'tab_luggage_cards',
                        icon: CardAssets.luggageCards,
                      ),
                    ],
                    selectedIndex: cubit.tab.index,
                    onChanged: (index) =>
                        cubit.changeTab(TripCardsTab.values[index]),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    tabPadding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
                    underlineGap: 10,
                    textStyle: Theme.of(context).textTheme.titleSmall,
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
    TripCardsState state,
    TripCardsCubit cubit,
  ) {
    if (state is TripCardsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return BuildCondition(
      condition: cubit.pilgrims.isNotEmpty,
      builder: (_) => Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              itemCount: cubit.pilgrims.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, index) =>
                  _PilgrimRow(pilgrim: cubit.pilgrims[index]),
            ),
          ),
          // "تحميل كل الملفات" only means something once a row has been
          // opened and its files are known.
          if (cubit.expandedId != null)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: CustomButton(
                  label: 'download_all_files'.tr(),
                  width: double.infinity,
                  height: 48,
                  icon: const Icon(Icons.download_rounded, size: 18),
                  onPressed: cubit.downloadAll,
                ),
              ),
            ),
        ],
      ),
      fallback: (_) => EmptyState(
        message: state is TripCardsError
            ? state.message.tr()
            : 'no_pilgrims_on_booking'.tr(),
        onRetry: () => cubit.getCards(refresh: true),
      ),
    );
  }
}

class _PilgrimRow extends StatelessWidget {
  const _PilgrimRow({required this.pilgrim});

  final TripPilgrimModel pilgrim;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TripCardsCubit>();
    final rowId = pilgrim.id ?? pilgrim.pilgrimId;

    return AppExpandableTile(
      leading: PilgrimAvatar(photo: pilgrim.photo),
      title: pilgrim.displayName,
      badge: AudienceChip(audience: pilgrim.audience),
      isExpanded: cubit.expandedId != null && cubit.expandedId == rowId,
      onToggle: () => cubit.toggle(pilgrim),
      children: cubit.tab == TripCardsTab.pilgrims
          ? [_card(context, cubit, rowId)]
          : _tags(context, cubit),
    );
  }

  Widget _card(BuildContext context, TripCardsCubit cubit, int? rowId) {
    final card = cubit.cards[rowId];

    return PilgrimCardTile(
      pilgrim: pilgrim,
      card: card,
      isLoading: cubit.loadingCards.contains(rowId),
      error: cubit.cardErrors[rowId],
      isDownloading: cubit.busyDocumentId == rowId,
      onRetry: () => cubit.getCard(pilgrim),
      onDownload: () =>
          cubit.download(documentId: rowId ?? 0, url: card?.fileUrl),
      onPreview: () =>
          PilgrimCardSheet.show(context, pilgrim: pilgrim, card: card),
    );
  }

  List<Widget> _tags(BuildContext context, TripCardsCubit cubit) {
    final tags = cubit.tagsOf(pilgrim);
    if (tags.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: EmptyState(message: 'no_luggage_tags'.tr()),
        ),
      ];
    }

    return [
      for (var i = 0; i < tags.length; i++)
        LuggageTagTile(
          tag: tags[i],
          position: i + 1,
          isDownloading: cubit.busyDocumentId == tags[i].id,
          onDownload: () =>
              cubit.download(documentId: tags[i].id ?? 0, url: tags[i].fileUrl),
          onPreview: () => LuggageCardSheet.show(
            context,
            tag: tags[i],
            pilgrim: pilgrim,
            tripNumber: cubit.cards[pilgrim.id]?.tripNumber,
            tripDate: cubit.cards[pilgrim.id]?.departureDate,
          ),
        ),
    ];
  }
}
