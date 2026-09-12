import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/auth_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

class ScanCornerFrame extends StatelessWidget {
  const ScanCornerFrame({super.key, required this.child, this.size});

  final Widget child;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(padding: EdgeInsets.all((size ?? 32.s) / 2), child: child),
        Positioned(top: 0, left: 0, child: _corner(AuthAssets.cornerTopLeft)),
        Positioned(top: 0, right: 0, child: _corner(AuthAssets.cornerTopRight)),
        Positioned(
          bottom: 0,
          left: 0,
          child: _corner(AuthAssets.cornerBottomLeft),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: _corner(AuthAssets.cornerBottomRight),
        ),
      ],
    );
  }

  Widget _corner(String asset) => AppImage(
    asset,
    height: (size ?? 32.s),
    width: (size ?? 32.s),
    fit: BoxFit.contain,
  );
}
