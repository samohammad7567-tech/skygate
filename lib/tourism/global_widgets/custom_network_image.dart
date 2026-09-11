import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String? url;
  final BoxFit fit;

  const CustomNetworkImage(
      {Key? key, required this.url, this.fit = BoxFit.cover})
      : super(key: key);

  bool isUrlValid() {
    if (url != null) {
      if (url!.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  Widget placeHolderImage() {
    return Image.asset(
      'assets/images/pngs/avatar.png',
      fit: fit,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isUrlValid()) {
      return CachedNetworkImage(
        imageUrl: url!,
        placeholder: (_, __) => placeHolderImage(),
        errorWidget: (_, __, ___) => placeHolderImage(),
        fit: fit,
      );
    } else {
      return placeHolderImage();
    }
  }
}
