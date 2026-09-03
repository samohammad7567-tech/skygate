import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  final String path;
  final double? size;
  final Color? color;
  final BoxFit fit;

  const SvgIcon(this.path, {
    Key? key,
    this.size,
    this.color,
    this.fit=BoxFit.contain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      color:color,
      fit: fit,
    );
  }
}
