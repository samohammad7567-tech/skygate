import 'package:flutter/material.dart';
import 'package:sky_gate/app/global_widgets/svg_icon.dart';

class UserImage extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const UserImage({
    Key? key,
    required this.size,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty || imageUrl!.contains("null")) {
      return placeHolder();
    }
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Image.network(
        imageUrl!,
        errorBuilder: (context, error, stackTrace) => placeHolder(),

        loadingBuilder: (context, child, loadingProgress) => Stack(
          children: [
            placeHolder(),
             Center(
              child: child
            ),
          ],
        ),
      ),
    );
  }

  Widget placeHolder() {
    return SvgIcon(
      'icons/user_image_placholder.svg',
      size: size,
    );
  }
}
