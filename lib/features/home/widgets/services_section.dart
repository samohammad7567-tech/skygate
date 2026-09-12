import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/home/models/service_model.dart';
import 'package:skygate/features/home/widgets/service_card.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key, required this.services});

  final List<ServiceModel> services;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.s),
      child: Column(
        children: [
          Text(
            'what_our_services_include'.tr(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
          SizedBox(height: 4.s),
          Text(
            'every_offer_includes_services'.tr(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 14.s),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 9,
              mainAxisSpacing: 9,
              // Tall enough for the worst case in the copy: a two-line title
              // over a one-line description, or the other way round.
              childAspectRatio: 1,
            ),
            itemBuilder: (_, index) => ServiceCard(service: services[index]),
          ),
        ],
      ),
    );
  }
}
