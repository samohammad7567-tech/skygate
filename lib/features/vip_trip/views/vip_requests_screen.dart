import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/vip_trip/controller/cubit/vip_requests_cubit.dart';
import 'package:skygate/features/vip_trip/controller/cubit/vip_trip_cubit.dart';
import 'package:skygate/features/vip_trip/models/private_trip_request_model.dart';
import 'package:skygate/features/vip_trip/views/vip_counts_screen.dart';
import 'package:skygate/features/vip_trip/views/vip_request_details_screen.dart';
import 'package:skygate/features/vip_trip/widgets/vip_request_card.dart';

class VipRequestsScreen extends StatelessWidget {
  const VipRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VipRequestsCubit()..getRequests(),
      child: const VipRequestsView(),
    );
  }
}

class VipRequestsView extends StatelessWidget {
  const VipRequestsView({super.key});

  void _newRequest(BuildContext context) {
    NaivgatorHelper.pushNavigation(
      context,
      BlocProvider(
        create: (_) => VipTripCubit(),
        child: const VipCountsScreen(),
      ),
    );
  }

  Future<void> _openDetails(
    BuildContext context,
    PrivateTripRequestModel request,
  ) async {
    final cubit = context.read<VipRequestsCubit>();
    cubit.getRequest(request);
    await NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(value: cubit, child: const VipRequestDetailsScreen()),
    );
    if (cubit.isClosed) return;
    await cubit.getRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<VipRequestsCubit, VipRequestsState>(
          builder: (context, state) {
            final cubit = context.read<VipRequestsCubit>();

            return Column(
              children: [
                AppPageHeader(title: 'private_trip_requests'.tr()),
                Expanded(
                  child: state is VipRequestsLoading
                      ? Center(
                          child: CircularProgressIndicator(strokeWidth: 2.s),
                        )
                      : BuildCondition(
                          condition: cubit.requests.isNotEmpty,
                          builder: (_) => RefreshIndicator(
                            onRefresh: cubit.getRequests,
                            child: ListView.separated(
                              padding: EdgeInsets.fromLTRB(
                                20.s,
                                8.s,
                                20.s,
                                20.s,
                              ),
                              itemCount: cubit.requests.length,
                              separatorBuilder: (_, _) => Gap(16.s),
                              itemBuilder: (_, index) => VipRequestCard(
                                request: cubit.requests[index],
                                index: index + 1,
                                onDetails: () => _openDetails(
                                  context,
                                  cubit.requests[index],
                                ),
                              ),
                            ),
                          ),
                          fallback: (_) => EmptyState(
                            message: state is VipRequestsError
                                ? state.message.tr()
                                : 'no_private_trip_requests'.tr(),
                            onRetry: cubit.getRequests,
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.s, 8.s, 20.s, 16.s),
          child: CustomButton(
            label: 'submit_private_trip_request'.tr(),
            height: 48.s,
            width: double.infinity,
            onPressed: () => _newRequest(context),
          ),
        ),
      ),
    );
  }
}
