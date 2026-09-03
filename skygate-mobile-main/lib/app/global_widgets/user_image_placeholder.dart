import 'package:flutter/material.dart';

class UserImagePlaceholder extends StatelessWidget {
  const UserImagePlaceholder({Key? key,this.size=91}) : super(key: key);
final double size;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: size,
        height: size,
        child: Image.asset('assets/user_image_placeholder.png'));
  }
}
