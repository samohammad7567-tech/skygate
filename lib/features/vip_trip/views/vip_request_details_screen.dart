import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/confirm_dialog.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/empty_state.dart';
import 'package:skygate/core/components/toast.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/vip_trip_assets.dart';
import 'package:skygate/features/vip_trip/controller/cubit/vip_requests_cubit.dart';
import 'package:skygate/features/vip_trip/utils/vip_travelers_label.dart';
import 'package:skygate/features/vip_trip/widgets/vip_summary_card.dart';

class VipRequestDetailsScreen extends StatelessWidget {
  const VipRequestDetailsScreen({super.key});

  Future<void> _confirmCancel(BuildContext context) async {
    final cubit = context.read<VipRequestsCubit>();

    final confirmed = await showConfirmDialog(
      context,
      message: 'cancel_request_question'.tr(),
      confirmKey: 'yes',
      cancelKey: 'no',
      asset: VipTripAssets.delete,
      tint: AppColors.error,
    );

    if (!confirmed || cubit.isClosed) return;
    await cubit.cancelRequest();
  }

  void _onState(BuildContext context, VipRequestsState state) {
    if (state is VipCancelled) {
      showToast(context, 'request_cancelled'.tr());
    } else if (state is VipCancelError) {
      showToast(context, state.message.tr(), isError: true);
    } else if (state is VipRequestError) {
      showToast(context, state.message.tr(), isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<VipRequestsCubit, VipRequestsState>(
          listener: _onState,
          builder: (context, state) {
            final request = context.read<VipRequestsCubit>().selected;

            return Column(
              children: [
                AppPageHeader(title: 'private_trip_request_details'.tr()),
                Expanded(
                  child: request == null
                      ? EmptyState(message: 'no_private_trip_requests'.tr())
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                          children: [
                            VipSummaryCard(
                              status: request.status,
                              travelers: vipRequestTravelersLabel(request),
                              startDate: request.startDate,
                              endDate: request.endDate,
                              makkahNights: request.makkahNights,
                              madinahNights: request.madinahNights,
                              roomCounts: request.roomCounts,
                              makkahHotel: request.makkahHotel,
                              madinahHotel: request.madinahHotel,
                              notes: request.requirementsText,
                            ),
                            // Only shown once the office has priced the
                            // request; nothing carries a quote before that.
                            if (request.quoteDetails.isNotEmpty) ...[
                              const Gap(16),
                              _Quote(lines: request.quoteDetails),
                            ],
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<VipRequestsCubit, VipRequestsState>(
        builder: (context, state) {
          final request = context.read<VipRequestsCubit>().selected;
          // A cancelled or approved request has nothing left to withdraw.
          if (request == null || !request.status.canCancel) {
            return const SizedBox.shrink();
          }

          return SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: CustomButton(
                label: 'cancel_request'.tr(),
                height: 48,
                width: double.infinity,
                isLoading: state is VipCancelLoading,
                onPressed: () => _confirmCancel(context),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Quote extends StatelessWidget {
  const _Quote({required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('quote_details'.tr(), style: theme.textTheme.titleLarge),
          const Gap(10),
          for (final line in lines) ...[
            Text(line, style: theme.textTheme.bodyMedium),
            const Gap(4),
          ],
        ],
      ),
    );
  }
}
