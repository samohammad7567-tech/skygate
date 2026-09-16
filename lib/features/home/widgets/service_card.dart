import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/home/models/service_model.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.service});

  final ServiceModel service;
  static const double _artWidth = 54;
  static const double _artHeight = 48;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.s, vertical: 8.s),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.s),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Artwork(service: service),
          SizedBox(height: 6.s),
          Text(
            service.titleKey.tr(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleSmall?.copyWith(
              fontSize: 12.fs,
              height: 1.2.s,
            ),
          ),
          SizedBox(height: 3.s),
          Flexible(
            child: Text(
              service.descriptionKey.tr(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 9.5.fs,
                height: 1.25.s,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
