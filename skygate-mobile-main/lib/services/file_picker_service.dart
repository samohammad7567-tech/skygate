import 'dart:io';

import 'package:file_picker/file_picker.dart';

/// Picking documents from device storage.
///
/// Wraps `FilePicker.platform` and hands back `dart:io` [File]s, dropping the
/// entries the platform could not resolve to a path. Cancelling yields `null`
/// or an empty list rather than an exception.
class FilePickerService {
  FilePickerService._();

  static final FilePickerService instance = FilePickerService._();

  /// Extensions accepted wherever the app asks for a passport scan.
  static const List<String> passportExtensions = ['jpg', 'jpeg', 'png', 'pdf'];

  /// Picks a single file of any type. Returns `null` when the user cancels.
  Future<File?> pickFile({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
  }) async {
    final files = await pickFiles(
      type: type,
      allowedExtensions: allowedExtensions,
      allowMultiple: false,
    );
    return files.isEmpty ? null : files.first;
  }

  /// Picks one or more files. Returns an empty list when the user cancels.
  Future<List<File>> pickFiles({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    bool allowMultiple = true,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: allowMultiple,
        // `allowedExtensions` is only honoured with FileType.custom.
        type: allowedExtensions == null ? type : FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (result == null) return <File>[];

      return result.files
          .where((file) => file.path != null)
          .map((file) => File(file.path!))
          .toList();
    } catch (_) {
      return <File>[];
    }
  }

  /// Picks images or PDFs, the combination used for passport attachments.
  Future<List<File>> pickDocuments({bool allowMultiple = true}) => pickFiles(
        allowedExtensions: passportExtensions,
        allowMultiple: allowMultiple,
      );

  /// Picks a single PDF. Returns `null` when the user cancels.
  Future<File?> pickPdf() => pickFile(allowedExtensions: const ['pdf']);

  /// Releases the temporary copies the picker created.
  Future<void> clearTemporaryFiles() async {
    try {
      await FilePicker.platform.clearTemporaryFiles();
    } catch (_) {
      // nothing to clean up
    }
  }
}
