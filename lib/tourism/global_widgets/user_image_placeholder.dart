import 'package:flutter/material.dart';

class UserImagePlaceholder extends StatelessWidget {
  const UserImagePlaceholder({super.key, this.size = 91});
  final double size;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset('assets/user_image_placeholder.png'),
    );
  }
}
