import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/booking_changes/controller/cubit/booking_changes_cubit.dart';
import 'package:skygate/features/booking_changes/widgets/booking_change_summary_card.dart';

class BookingChangeDetailsScreen extends StatelessWidget {
  const BookingChangeDetailsScreen({super.key});

  void _onState(BuildContext context, BookingChangesState state) {
    if (state is BookingChangeError) {
      showToast(context, state.message.tr(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<BookingChangesCubit, BookingChangesState>(
          listener: _onState,
          builder: (context, state) {
            final request = context.read<BookingChangesCubit>().selected;

            return Column(
              children: [
                AppPageHeader(title: 'booking_change_request_details'.tr()),
                Expanded(
                  child: request == null
                      ? EmptyState(message: 'no_booking_change_requests'.tr())
                      : ListView(
                          padding: EdgeInsets.fromLTRB(20.s, 8.s, 20.s, 24.s),
                          children: [
                            BookingChangeSummaryCard(request: request),
                          ],
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
