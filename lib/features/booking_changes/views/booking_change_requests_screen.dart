import 'package:buildcondition/buildcondition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/core/utils/naivgator_helper.dart';
import 'package:skygate/features/booking_changes/controller/cubit/booking_changes_cubit.dart';
import 'package:skygate/features/booking_changes/models/booking_change_request_model.dart';
import 'package:skygate/features/booking_changes/views/booking_change_details_screen.dart';
import 'package:skygate/features/booking_changes/widgets/booking_change_card.dart';

class BookingChangeRequestsScreen extends StatelessWidget {
  const BookingChangeRequestsScreen({super.key, this.onMenuTap});
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingChangesCubit()..getRequests(),
      child: BookingChangeRequestsView(onMenuTap: onMenuTap),
    );
  }
}

class BookingChangeRequestsView extends StatelessWidget {
  const BookingChangeRequestsView({super.key, this.onMenuTap});

  final VoidCallback? onMenuTap;

  Future<void> _openDetails(
    BuildContext context,
    BookingChangeRequestModel request,
  ) async {
    final cubit = context.read<BookingChangesCubit>();
    cubit.getRequest(request);

    await NaivgatorHelper.pushNavigation(
      context,
      BlocProvider.value(
        value: cubit,
        child: const BookingChangeDetailsScreen(),
      ),
    );
    if (cubit.isClosed) return;
    await cubit.getRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<BookingChangesCubit, BookingChangesState>(
          builder: (context, state) {
            final cubit = context.read<BookingChangesCubit>();

            return Column(
              children: [
                AppPageHeader(
                  title: 'booking_change_requests'.tr(),
                  onMenuTap: onMenuTap,
                ),
                Expanded(
                  child: state is BookingChangesLoading
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
                                24.s,
                              ),
                              itemCount: cubit.requests.length,
                              separatorBuilder: (_, _) => Gap(16.s),
                              itemBuilder: (_, index) => BookingChangeCard(
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
                            message: state is BookingChangesError
                                ? state.message.tr()
                                : 'no_booking_change_requests'.tr(),
                            onRetry: cubit.getRequests,
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
