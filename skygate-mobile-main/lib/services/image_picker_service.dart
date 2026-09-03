import 'dart:io';

import 'package:image_picker/image_picker.dart';

/// Picking images from the gallery or the camera.
///
/// Returns `dart:io` [File]s because every caller uploads them through
/// `HttpService.postMultipart`. Cancelling always yields `null` or an empty
/// list, never an exception, so callers do not need a try/catch.
class ImagePickerService {
  ImagePickerService._();

  static final ImagePickerService instance = ImagePickerService._();

  final ImagePicker _picker = ImagePicker();

  /// Picks a single image. Returns `null` when the user cancels.
  Future<File?> pickImage({
    ImageSource source = ImageSource.gallery,
    int? imageQuality,
    double? maxWidth,
    double? maxHeight,
  }) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );
      return picked == null ? null : File(picked.path);
    } catch (_) {
      return null;
    }
  }

  /// Picks a single image from the gallery.
  Future<File?> pickFromGallery({int? imageQuality}) =>
      pickImage(source: ImageSource.gallery, imageQuality: imageQuality);

  /// Takes a photo with the camera.
  Future<File?> pickFromCamera({int? imageQuality}) =>
      pickImage(source: ImageSource.camera, imageQuality: imageQuality);

  /// Picks several images at once. Returns an empty list when the user cancels.
  Future<List<File>> pickMultiImage({
    int? imageQuality,
    double? maxWidth,
    double? maxHeight,
  }) async {
    try {
      final picked = await _picker.pickMultiImage(
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );
      return picked.map((file) => File(file.path)).toList();
    } catch (_) {
      return <File>[];
    }
  }

  /// Picks a video. Returns `null` when the user cancels.
  Future<File?> pickVideo({
    ImageSource source = ImageSource.gallery,
    Duration? maxDuration,
  }) async {
    try {
      final picked =
          await _picker.pickVideo(source: source, maxDuration: maxDuration);
      return picked == null ? null : File(picked.path);
    } catch (_) {
      return null;
    }
  }
}
