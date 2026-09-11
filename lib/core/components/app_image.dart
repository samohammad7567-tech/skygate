import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skygate/core/constants/app_assets.dart';

class AppImage extends StatelessWidget {
  const AppImage(
    this.asset, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
  });

  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;

  bool get _isSvg => asset.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    if (_isSvg) {
      return SvgPicture.asset(
        asset,
        width: width,
        height: height,
        fit: fit,
        colorFilter: color == null
            ? null
            : ColorFilter.mode(color!, BlendMode.srcIn),
      );
    }
    return Image.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      color: color,
      errorBuilder: (_, _, _) => SizedBox(width: width, height: height),
    );
  }
}
