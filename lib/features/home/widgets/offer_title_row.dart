import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/home/models/offer_model.dart';

class OfferTitleRow extends StatelessWidget {
  const OfferTitleRow({super.key, required this.offer});

  final OfferModel offer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final slugs = offer.inclusions.isEmpty
        ? OfferInclusion.defaultOrder
        : offer.inclusions;

    return Row(
      children: [
        Flexible(
          child: Text(
            offer.title ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium,
          ),
        ),
        SizedBox(width: 8.s),
        Flexible(
          child: Wrap(
            spacing: 6.s,
            runSpacing: 4.s,
            textDirection: ui.TextDirection.ltr,
            children: [
              for (final slug in slugs)
                if (OfferInclusion.assetFor(slug) case final asset?)
                  AppImage(
                    asset,
                    width: 16.s,
                    height: 16.s,
                    color: theme.colorScheme.primary,
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
