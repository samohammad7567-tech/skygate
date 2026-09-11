import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/constants/profile_assets.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.url, this.file, this.size = 92});
  final String? url;
  final File? file;

  final double size;

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return ClipOval(
        child: Image.file(file!, height: size, width: size, fit: BoxFit.cover),
      );
    }

    final resolved = ApiEndpoints.mediaUrl(url);
    if (resolved == null) return _placeholder;

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: resolved,
        height: size,
        width: size,
        fit: BoxFit.cover,
        placeholder: (_, _) => _placeholder,
        errorWidget: (_, _, _) => _placeholder,
      ),
    );
  }

  Widget get _placeholder =>
      AppImage(ProfileAssets.avatar, height: size, width: size);
}
