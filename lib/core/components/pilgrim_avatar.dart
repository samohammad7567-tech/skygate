import 'package:flutter/material.dart';
import 'package:skygate/core/components/cached_image.dart';
import 'package:skygate/core/constants/card_assets.dart';

/// The pilgrim's photo in its ring — the same portrait the cards tabs, the
/// visa and ticket tabs, and the pilgrim card's header all print.
class PilgrimAvatar extends StatelessWidget {
  const PilgrimAvatar({
    super.key,
    required this.photo,
    this.size = 46,
    this.ringColor,
    this.ringWidth = 2,
  });

  final String? photo;
  final double size;

  /// Defaults to the brand blue the list tiles draw; the dark card face
  /// passes the gold that reads against navy.
  final Color? ringColor;
  final double ringWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: size,
      width: size,
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
          // No portrait on file still has to fill the ring, so the fallback
          // is an image rather than a blank circle.
          fallbackAsset: CardAssets.avatar,
          height: size,
          width: size,
        ),
      ),
    );
  }
}
