import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';

/// Network image with a bundled fallback.
///
/// Falls straight back to [fallbackAsset] when [url] is null or empty, which is
/// what happens while the API is still stubbed.
class CachedImage extends StatelessWidget {
  const CachedImage({
    super.key,
    required this.url,
    required this.fallbackAsset,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final String? url;
  final String fallbackAsset;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) return _fallback(context);

    return CachedNetworkImage(
      imageUrl: url!,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, _) => _fallback(context),
      errorWidget: (_, _, _) => _fallback(context),
    );
  }

  Widget _fallback(BuildContext context) => Container(
    width: width,
    height: height,
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    alignment: Alignment.center,
    child: AppImage(fallbackAsset, width: width, height: height, fit: fit),
  );
}
