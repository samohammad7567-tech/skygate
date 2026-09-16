import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  ImagePickerService._();

  static final ImagePicker _picker = ImagePicker();
  static const int maxSizeInBytes = 5 * 1024 * 1024;
  static Future<File?> pick(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (picked == null) return null;
      return File(picked.path);
    } catch (error) {
      debugPrint('ImagePickerService.pick error: $error');
      return null;
    }
  }

  static Future<bool> isWithinSizeLimit(File file) async {
    try {
      return await file.length() <= maxSizeInBytes;
    } catch (error) {
      debugPrint('ImagePickerService.isWithinSizeLimit error: $error');
      return false;
    }
  }
}
