import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_page_header.dart';
import 'package:skygate/core/components/booking_bottom_bar.dart';
import 'package:skygate/core/components/booking_step_scaffold_body.dart';

class BookingStepScaffold extends StatelessWidget {
  const BookingStepScaffold({
    super.key,
    required this.step,
    required this.children,
    required this.onContinue,
    required this.total,
    this.onBack,
    this.isLoading = false,
    this.continueLabel,
    this.titleKey = 'booking_details',
    this.drawer,
  });
  final int step;
  final int total;
  final List<Widget> children;
  final VoidCallback? onContinue;

  final VoidCallback? onBack;
  final bool isLoading;
  final String? continueLabel;
  final String titleKey;
  final Widget? drawer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Below the Scaffold, so `Scaffold.of` finds the one above rather
            // than whatever the caller was built under.
            Builder(
              builder: (inner) => AppPageHeader(
                title: titleKey.tr(),
                onBack: onBack,
                onMenuTap: drawer == null
                    ? null
                    : () => Scaffold.of(inner).openDrawer(),
              ),
            ),
            Expanded(
              child: BookingStepScaffoldBody(
                step: step,
                total: total,
                children: children,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BookingBottomBar(
        onContinue: onContinue,
        onBack: onBack,
        isLoading: isLoading,
        continueLabel: continueLabel,
      ),
    );
  }
}
