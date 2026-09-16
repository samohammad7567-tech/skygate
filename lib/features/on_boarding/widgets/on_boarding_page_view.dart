import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_page_indicator.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/on_boarding/models/on_boarding_page_model.dart';

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
        Expanded(
          flex: 308,
          child: Center(child: AppImage(page.image, fit: BoxFit.contain)),
        ),
        SizedBox(height: 8.s),
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
      padding: EdgeInsets.fromLTRB(20.s, 22.s, 20.s, 18.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10.s),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 8.s,
            offset: Offset(0, 2.s),
          ),
        ],
      ),
      child: Column(
        children: [
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
                        fontSize: 21.fs,
                        height: 1.5.s,
                      ),
                    ),
                    SizedBox(height: 12.s),
                    Text(
                      descriptionKey.tr(),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.75.s,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 12.s),
          AppPageIndicator(count: pageCount, currentIndex: currentIndex),
        ],
      ),
    );
  }
}
