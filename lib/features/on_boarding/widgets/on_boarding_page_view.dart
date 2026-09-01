import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/features/on_boarding/models/on_boarding_page_model.dart';
import 'package:skygate/features/on_boarding/widgets/on_boarding_indicator.dart';

/// A single onboarding page: illustration on top, copy card below.
///
/// The indicator lives inside the card, as in the design, and takes the live
/// page index so it keeps animating while this page is on screen.
class OnBoardingPageView extends StatelessWidget {
  const OnBoardingPageView({
    super.key,
    required this.page,
    required this.pageCount,
    required this.currentIndex,
  });

  final OnBoardingPageModel page;
  final int pageCount;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 308:289 is the illustration-to-card height ratio in the design.
        Expanded(
          flex: 308,
          child: Center(child: AppImage(page.image, fit: BoxFit.contain)),
        ),
        const SizedBox(height: 8),
        Expanded(
          flex: 289,
          child: _CopyCard(
            titleKey: page.titleKey,
            descriptionKey: page.descriptionKey,
            pageCount: pageCount,
            currentIndex: currentIndex,
          ),
        ),
      ],
    );
  }
}

class _CopyCard extends StatelessWidget {
  const _CopyCard({
    required this.titleKey,
    required this.descriptionKey,
    required this.pageCount,
    required this.currentIndex,
  });

  final String titleKey;
  final String descriptionKey;
  final int pageCount;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Centred so short copy sits mid-card, as in the design, while long
          // copy can still scroll instead of overflowing.
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      titleKey.tr(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 21,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      descriptionKey.tr(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.75,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OnBoardingIndicator(count: pageCount, currentIndex: currentIndex),
        ],
      ),
    );
  }
}
