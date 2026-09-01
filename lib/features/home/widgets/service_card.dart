import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/features/home/models/service_model.dart';

/// One tile of the "ماذا تشمل خدماتنا" grid.
class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.service});

  final ServiceModel service;

  /// Box the illustration is drawn into. Sized from the widest export so no
  /// tile is cropped, and shared by every tile so the grid stays on a baseline.
  static const double _artWidth = 54;
  static const double _artHeight = 48;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Artwork(service: service),
          const SizedBox(height: 6),
          Text(
            service.titleKey.tr(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              fontSize: 12,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 3),
          Flexible(
            child: Text(
              service.descriptionKey.tr(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 9.5,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The illustration, plus the "vip" banner for the tile that ships one.
class _Artwork extends StatelessWidget {
  const _Artwork({required this.service});

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    final overlay = service.overlay;

    return SizedBox(
      width: ServiceCard._artWidth,
      height: ServiceCard._artHeight,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AppImage(
            service.image,
            width: ServiceCard._artWidth,
            height: ServiceCard._artHeight,
          ),
          if (overlay != null)
            AppImage(
              overlay,
              width: ServiceCard._artWidth,
              fit: BoxFit.fitWidth,
            ),
        ],
      ),
    );
  }
}
