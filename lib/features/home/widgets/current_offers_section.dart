import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/components/section_header.dart';
import 'package:skygate/core/utils/screen_size.dart';
import 'package:skygate/features/home/models/offer_model.dart';
import 'package:skygate/features/home/widgets/offer_card.dart';

/// "العروض الحالية" header plus the horizontal offer carousel.
class CurrentOffersSection extends StatelessWidget {
  const CurrentOffersSection({
    super.key,
    required this.offers,
    required this.isLoading,
    this.errorMessage,
    this.onViewAll,
    this.onRetry,
    this.onOfferTap,
  });

  final List<OfferModel> offers;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onViewAll;
  final VoidCallback? onRetry;
  final ValueChanged<OfferModel>? onOfferTap;

  static const double _listHeight = 360;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionHeader(
            title: 'current_offers'.tr(),
            actionLabel: 'view_all'.tr(),
            onActionTap: onViewAll,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(height: _listHeight, child: _body(context)),
      ],
    );
  }

  Widget _body(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return BuildCondition(
      condition: offers.isNotEmpty,
      builder: (_) => ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: offers.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final offer = offers[index];
          return OfferCard(
            offer: offer,
            width: ScreenSize.cardWidth,
            onViewDetails: () => onOfferTap?.call(offer),
          );
        },
      ),
      fallback: (_) => EmptyState(
        message: errorMessage ?? 'no_offers'.tr(),
        onRetry: onRetry,
      ),
    );
  }
}
