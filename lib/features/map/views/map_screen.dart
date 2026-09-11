import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_circle_icon_button.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/constants/map_assets.dart';
import 'package:skygate/features/main/controller/cubit/main_cubit.dart';
import 'package:skygate/features/map/controller/cubit/map_cubit.dart';
import 'package:skygate/features/map/models/map_tracking_status.dart';
import 'package:skygate/features/map/widgets/map_gps_alert_view.dart';
import 'package:skygate/features/map/widgets/map_inactive_view.dart';
import 'package:skygate/features/map/widgets/map_live_view.dart';
import 'package:skygate/features/map/widgets/map_protocol_view.dart';
import 'package:skygate/features/map/widgets/map_stopped_view.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key, this.onMenuTap});

  /// Opens the shell's drawer. The shell owns the panel, so a tab only
  /// forwards the tap.
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => MapCubit()..load(),
    // The SOS chip is not this screen's: the shell floats it over every tab.
    child: _MapBody(onMenuTap: onMenuTap),
  );
}

class _MapBody extends StatefulWidget {
  const _MapBody({this.onMenuTap});

  final VoidCallback? onMenuTap;

  @override
  State<_MapBody> createState() => _MapBodyState();
}

class _MapBodyState extends State<_MapBody> {
  Future<void> _pickDate() async {
    final cubit = context.read<MapCubit>();
    final today = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: cubit.selectedDate,
      // A tracking record only exists for days the pilgrim has lived through,
      // and the programme runs to the end of the trip, so the window is the
      // year either side rather than the future alone.
      firstDate: DateTime(today.year - 1),
      lastDate: DateTime(today.year + 1, 12, 31),
    );
    if (picked != null) cubit.selectDate(picked);
  }

  void _goToTab(int index) => context.read<MainCubit>().changeTab(index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppPageHeader(
              title: 'nav_map'.tr(),
              onMenuTap: widget.onMenuTap,
              // A tab root has nothing to pop, so the end corner carries the
              // calendar the design puts there instead of a back chip.
              action: AppCircleIconButton(
                asset: MapAssets.calendar,
                tooltip: 'select_date'.tr(),
                onTap: _pickDate,
              ),
            ),
            Expanded(
              child: BlocBuilder<MapCubit, MapState>(
                builder: (context, state) =>
                    _face(context.read<MapCubit>().status),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _face(MapTrackingStatus status) => switch (status) {
    MapTrackingStatus.loading => const Center(
      child: CircularProgressIndicator(),
    ),
    MapTrackingStatus.consent => const MapProtocolView(),
    MapTrackingStatus.active => MapLiveView(onPickDate: _pickDate),
    MapTrackingStatus.disconnected => const MapGpsAlertView(),
    MapTrackingStatus.inactive => MapInactiveView(
      onBrowseTrips: () => _goToTab(1),
    ),
    MapTrackingStatus.finished => MapStoppedView(onGoHome: () => _goToTab(0)),
  };
}
