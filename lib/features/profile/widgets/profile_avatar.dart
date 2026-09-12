import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/constants/profile_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.url, this.file, this.size});
  final String? url;
  final File? file;

  final double? size;

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return ClipOval(
        child: Image.file(
          file!,
          height: (size ?? 92.s),
          width: (size ?? 92.s),
          fit: BoxFit.cover,
        ),
      );
    }

    final resolved = ApiEndpoints.mediaUrl(url);
    if (resolved == null) return _placeholder;

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: resolved,
        height: (size ?? 92.s),
        width: (size ?? 92.s),
        fit: BoxFit.cover,
        placeholder: (_, _) => _placeholder,
        errorWidget: (_, _, _) => _placeholder,
      ),
    );
  }

  Widget get _placeholder => AppImage(
    ProfileAssets.avatar,
    height: (size ?? 92.s),
    width: (size ?? 92.s),
  );
}
