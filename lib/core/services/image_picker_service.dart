import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Gallery / camera access for the profile photo and the "ملفات المعتمر"
/// uploads. Call it from cubits — never from a widget `build`.
class ImagePickerService {
  ImagePickerService._();

  static final ImagePicker _picker = ImagePicker();

  /// Upload ceiling printed on every dashed drop zone: `الحجم الأقصى (5MB)`.
  static const int maxSizeInBytes = 5 * 1024 * 1024;

  /// Returns the picked file, or `null` when the user backs out.
  ///
  /// Images are downscaled before they leave the device so a 12MP camera shot
  /// does not blow past [maxSizeInBytes].
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

  /// `true` when [file] fits inside [maxSizeInBytes].
  static Future<bool> isWithinSizeLimit(File file) async {
    try {
      return await file.length() <= maxSizeInBytes;
    } catch (error) {
      debugPrint('ImagePickerService.isWithinSizeLimit error: $error');
      return false;
    }
  }
}
