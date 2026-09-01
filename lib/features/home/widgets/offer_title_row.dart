import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/features/home/models/offer_model.dart';

/// Inclusion glyphs on the end side, offer title on the start side.
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
        const SizedBox(width: 8),
        Flexible(
          // The glyphs read the same way in both locales — the design prints
          // them plane-first from the left — so they keep an LTR run.
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            textDirection: ui.TextDirection.ltr,
            children: [
              for (final slug in slugs)
                if (OfferInclusion.assetFor(slug) case final asset?)
                  AppImage(
                    asset,
                    width: 16,
                    height: 16,
                    color: theme.colorScheme.primary,
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
