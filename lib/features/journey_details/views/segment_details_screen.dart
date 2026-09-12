import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/app_tab_bar.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/constants/card_assets.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/journey_details/controller/cubit/journey_details_cubit.dart';
import 'package:skygate/features/journey_details/controller/cubit/segment_docs_cubit.dart';
import 'package:skygate/features/journey_details/models/journey_route_model.dart';
import 'package:skygate/features/journey_details/views/activities_screen.dart';
import 'package:skygate/features/journey_details/widgets/journey_bottom_bar.dart';
import 'package:skygate/features/journey_details/widgets/segment_details_body.dart';
import 'package:skygate/features/journey_details/widgets/segment_docs_tab.dart';

/// "تفاصيل القسم" — one leg of the route under three tabs: the leg itself,
/// the visas the travellers hold for it, and their tickets.
class SegmentDetailsScreen extends StatelessWidget {
  const SegmentDetailsScreen({
    super.key,
    required this.tripId,
    required this.segment,
    this.bookingId,
  });

  final int tripId;
  final JourneySegmentModel segment;

  /// Null while a trip is only being browsed; the document tabs then have
  /// nobody to list and say so.
  final int? bookingId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => JourneyDetailsCubit(tripId)..showSegment(segment),
        ),
        BlocProvider(
          create: (_) =>
              SegmentDocsCubit(bookingId: bookingId, segmentId: segment.id),
        ),
      ],
      child: const _SegmentDetailsBody(),
    );
  }
}

class _SegmentDetailsBody extends StatelessWidget {
  const _SegmentDetailsBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SegmentDocsCubit, SegmentDocsState>(
      listenWhen: (_, state) =>
          state is SegmentDocumentOpened || state is SegmentDocumentFailed,
      listener: (context, state) {
        if (state is SegmentDocumentFailed) {
          showToast(context, state.message.tr(), isError: true);
        }
      },
      builder: (context, docsState) {
        final docs = context.read<SegmentDocsCubit>();

        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                AppPageHeader(title: 'section_details'.tr()),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: AppTabBar(
                    tabs: const [
                      AppTabItem(
                        labelKey: 'tab_segment_details',
                        icon: CardAssets.segmentDetails,
                      ),
                      AppTabItem(labelKey: 'tab_visas', icon: CardAssets.visas),
                      AppTabItem(
                        labelKey: 'tab_tickets',
                        icon: CardAssets.tickets,
                      ),
                    ],
                    selectedIndex: docs.tab.index,
                    onChanged: (index) =>
                        docs.changeTab(SegmentTab.values[index]),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    tabPadding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
                    underlineGap: 10,
                    textStyle: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Expanded(
                  child: docs.tab == SegmentTab.details
                      ? const _DetailsTab()
                      : SegmentDocsTab(state: docsState),
                ),
              ],
            ),
          ),
          // Only the leg itself leads anywhere onward; the document tabs
          // carry their own "تحميل كل الملفات" instead.
          bottomNavigationBar: docs.tab == SegmentTab.details
              ? JourneyBottomBar(
                  label: 'go_to_activities'.tr(),
                  onPressed: () => NaivgatorHelper.pushNavigation(
                    context,
                    ActivitiesScreen(
                      tripId: context.read<JourneyDetailsCubit>().tripId,
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}

class _DetailsTab extends StatelessWidget {
  const _DetailsTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JourneyDetailsCubit, JourneyDetailsState>(
      builder: (context, state) {
        final segment = context.read<JourneyDetailsCubit>().segment;

        return segment == null
            ? const Center(child: CircularProgressIndicator())
            : SegmentDetailsBody(segment: segment);
      },
    );
  }
}
