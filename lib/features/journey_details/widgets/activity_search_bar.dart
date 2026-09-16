import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_search_bar.dart';
import 'package:skygate/core/constants/journey_assets.dart';
import 'package:skygate/features/journey_details/controller/cubit/activities_cubit.dart';
import 'package:skygate/features/journey_details/widgets/activity_filter_sheet.dart';

class ActivitySearchBar extends StatefulWidget {
  const ActivitySearchBar({super.key});

  @override
  State<ActivitySearchBar> createState() => _ActivitySearchBarState();
}

class _ActivitySearchBarState extends State<ActivitySearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ActivitiesCubit>();

    return AppSearchBar(
      controller: _controller,
      hintKey: 'search_activities',
      onSubmitted: cubit.search,
      actionAsset: JourneyAssets.sort,
      onActionTap: () => ActivityFilterSheet.show(
        context,
        selected: cubit.kindFilter,
        onApply: cubit.applyFilter,
      ),
    );
  }
}
