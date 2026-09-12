import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_sheet.dart';
import 'package:skygate/core/components/app_tab_bar.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/features/cards/models/pilgrim_card_model.dart';
import 'package:skygate/features/cards/models/trip_pilgrim_model.dart';
import 'package:skygate/features/cards/widgets/pilgrim_card_back.dart';
import 'package:skygate/features/cards/widgets/pilgrim_card_face.dart';

/// "بطاقة المعتمر" — the card as it will be printed, front and back.
///
/// The sheet holds only which face is showing; the card it draws was already
/// read by [TripCardsCubit] when the pilgrim's row opened, so opening the
/// preview costs no request.
class PilgrimCardSheet extends StatefulWidget {
  const PilgrimCardSheet({
    super.key,
    required this.pilgrim,
    required this.card,
  });

  final TripPilgrimModel pilgrim;
  final PilgrimCardModel? card;

  static Future<void> show(
    BuildContext context, {
    required TripPilgrimModel pilgrim,
    required PilgrimCardModel? card,
  }) => showAppSheet<void>(
    context,
    builder: (_) => PilgrimCardSheet(pilgrim: pilgrim, card: card),
  );

  @override
  State<PilgrimCardSheet> createState() => _PilgrimCardSheetState();
}

class _PilgrimCardSheetState extends State<PilgrimCardSheet> {
  int _face = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SheetHandle(),
              const Gap(14),
              Text(
                'pilgrim_card'.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge,
              ),
              const Gap(16),
              AppTabBar(
                tabs: [
                  AppTabItem(labelKey: 'card_face_front'),
                  AppTabItem(labelKey: 'card_face_back'),
                ],
                selectedIndex: _face,
                onChanged: (index) => setState(() => _face = index),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                tabPadding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
                underlineGap: 10,
                textStyle: theme.textTheme.titleSmall,
              ),
              const Gap(18),
              if (_face == 0)
                PilgrimCardFace(pilgrim: widget.pilgrim, card: widget.card)
              else
                PilgrimCardBack(card: widget.card),
            ],
          ),
        ),
      ),
    );
  }
}
