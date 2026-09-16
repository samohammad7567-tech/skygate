import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_search_bar.dart';
import 'package:skygate/core/constants/journey_assets.dart';

class HotelSearchBar extends StatelessWidget {
  const HotelSearchBar({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onSortTap,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onSortTap;

  @override
  Widget build(BuildContext context) {
    return AppSearchBar(
      controller: controller,
      hintKey: 'search_hotel_hint',
      onSubmitted: onSubmitted,
      actionAsset: JourneyAssets.sort,
      actionTooltip: 'sort_hotels'.tr(),
      onActionTap: onSortTap,
    );
  }
}
