import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/app_search_bar.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/carriers/controller/cubit/carriers_cubit.dart';
import 'package:skygate/features/carriers/widgets/carrier_card.dart';

class CarriersBody extends StatefulWidget {
  const CarriersBody({super.key, this.onMenuTap});
  final VoidCallback? onMenuTap;

  @override
  State<CarriersBody> createState() => _CarriersBodyState();
}

class _CarriersBodyState extends State<CarriersBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<CarriersCubit, CarriersState>(
          builder: (context, state) {
            final cubit = context.read<CarriersCubit>();

            return Column(
              children: [
                AppPageHeader(
                  title: cubit.category.titleKey.tr(),
                  onMenuTap: widget.onMenuTap,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 12.s),
                  child: AppSearchBar(
                    controller: _searchController,
                    hintKey: cubit.category.searchHintKey,
                    onSubmitted: cubit.search,
                  ),
                ),
                Expanded(child: _list(state, cubit)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _list(CarriersState state, CarriersCubit cubit) {
    if (state is CarriersLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return BuildCondition(
      condition: cubit.carriers.isNotEmpty,
      builder: (_) => RefreshIndicator(
        onRefresh: cubit.getCarriers,
        child: ListView.separated(
          padding: EdgeInsets.fromLTRB(20.s, 0, 20.s, 20.s),
          itemCount: cubit.carriers.length,
          separatorBuilder: (_, _) => SizedBox(height: 14.s),
          itemBuilder: (_, index) => CarrierCard(
            carrier: cubit.carriers[index],
            transport: cubit.category.vehicle,
          ),
        ),
      ),
      fallback: (_) => EmptyState(
        message: state is CarriersError
            ? state.message.tr()
            : 'no_carriers'.tr(),
        onRetry: cubit.getCarriers,
      ),
    );
  }
}
