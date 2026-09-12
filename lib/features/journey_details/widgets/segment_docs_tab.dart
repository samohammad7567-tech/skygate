import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_expandable_tile.dart';
import 'package:skygate/core/components/audience_chip.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/components/pilgrim_avatar.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/cards/models/trip_pilgrim_model.dart';
import 'package:skygate/features/journey_details/controller/cubit/segment_docs_cubit.dart';
import 'package:skygate/features/journey_details/widgets/ticket_tile.dart';
import 'package:skygate/features/journey_details/widgets/visa_tile.dart';

/// The تأشيرات and تذاكر tabs. Both are the same list of pilgrims — only what
/// unfolds under a name differs — so one widget draws both.
class SegmentDocsTab extends StatelessWidget {
  const SegmentDocsTab({super.key, required this.state});

  final SegmentDocsState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SegmentDocsCubit>();

    if (state is SegmentDocsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!cubit.hasBooking) {
      return EmptyState(message: 'documents_need_booking'.tr());
    }

    return BuildCondition(
      condition: cubit.pilgrims.isNotEmpty,
      builder: (_) => Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 12.s),
              itemCount: cubit.pilgrims.length,
              separatorBuilder: (_, _) => SizedBox(height: 12.s),
              itemBuilder: (_, index) =>
                  _PilgrimRow(pilgrim: cubit.pilgrims[index]),
            ),
          ),
          if (cubit.expandedId != null)
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 16.s),
                child: CustomButton(
                  label: 'download_all_files'.tr(),
                  width: double.infinity,
                  height: 48.s,
                  icon: Icon(Icons.download_rounded, size: 18.s),
                  onPressed: cubit.downloadAll,
                ),
              ),
            ),
        ],
      ),
      fallback: (_) => EmptyState(
        message: state is SegmentDocsError
            ? (state as SegmentDocsError).message.tr()
            : 'no_travel_documents'.tr(),
        onRetry: () => cubit.getDocuments(refresh: true),
      ),
    );
  }
}

class _PilgrimRow extends StatelessWidget {
  const _PilgrimRow({required this.pilgrim});

  final TripPilgrimModel pilgrim;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SegmentDocsCubit>();
    final rowId = pilgrim.id ?? pilgrim.pilgrimId;

    return AppExpandableTile(
      leading: PilgrimAvatar(photo: pilgrim.photo),
      title: pilgrim.displayName,
      badge: AudienceChip(audience: pilgrim.audience),
      isExpanded: cubit.expandedId != null && cubit.expandedId == rowId,
      onToggle: () => cubit.toggle(pilgrim),
      children: cubit.tab == SegmentTab.visas
          ? _visas(context, cubit)
          : _tickets(context, cubit),
    );
  }

  List<Widget> _visas(BuildContext context, SegmentDocsCubit cubit) {
    final visas = cubit.visasOf(pilgrim);
    if (visas.isEmpty) return [_empty('no_visas')];

    return [
      for (var i = 0; i < visas.length; i++)
        VisaTile(
          visa: visas[i],
          position: i + 1,
          isDownloading: cubit.busyDocumentId == visas[i].id,
          onDownload: () => cubit.download(
            documentId: visas[i].id ?? 0,
            url: visas[i].fileUrl,
          ),
          onPreview: () => cubit.download(
            documentId: visas[i].id ?? 0,
            url: visas[i].fileUrl,
          ),
        ),
    ];
  }

  List<Widget> _tickets(BuildContext context, SegmentDocsCubit cubit) {
    final tickets = cubit.ticketsOf(pilgrim);
    if (tickets.isEmpty) return [_empty('no_tickets')];

    return [
      for (var i = 0; i < tickets.length; i++)
        TicketTile(
          ticket: tickets[i],
          position: i + 1,
          isDownloading: cubit.busyDocumentId == tickets[i].id,
          onDownload: () => cubit.download(
            documentId: tickets[i].id ?? 0,
            url: tickets[i].fileUrl,
          ),
          onPreview: () => cubit.download(
            documentId: tickets[i].id ?? 0,
            url: tickets[i].fileUrl,
          ),
        ),
    ];
  }

  Widget _empty(String messageKey) => Padding(
    padding: EdgeInsets.symmetric(vertical: 16.s),
    child: EmptyState(message: messageKey.tr()),
  );
}
