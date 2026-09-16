import 'package:flutter/material.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/constants/card_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

class PilgrimAvatar extends StatelessWidget {
  const PilgrimAvatar({
    super.key,
    required this.photo,
    this.size,
    this.ringColor,
    this.ringWidth = 2,
  });

  final String? photo;
  final double? size;
  final Color? ringColor;
  final double ringWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: (size ?? 46.s),
      width: (size ?? 46.s),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ringColor ?? theme.colorScheme.primary,
          width: ringWidth,
        ),
      ),
      child: ClipOval(
        child: CachedImage(
          url: photo,
          fallbackAsset: CardAssets.avatar,
          height: (size ?? 46.s),
          width: (size ?? 46.s),
        ),
      ),
    );
  }
}
