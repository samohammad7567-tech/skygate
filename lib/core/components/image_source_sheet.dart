import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Asks whether the file should come from the gallery or the camera.
///
/// Returns `null` when the sheet is dismissed, which the cubits treat as "user
/// backed out" and ignore.
Future<ImageSource?> showImageSourceSheet(BuildContext context) {
  return showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Option(
            icon: Icons.photo_library_outlined,
            label: 'choose_from_gallery'.tr(),
            source: ImageSource.gallery,
          ),
          _Option(
            icon: Icons.photo_camera_outlined,
            label: 'take_photo'.tr(),
            source: ImageSource.camera,
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icon,
    required this.label,
    required this.source,
  });

  final IconData icon;
  final String label;
  final ImageSource source;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(label, style: theme.textTheme.titleSmall),
      onTap: () => Navigator.of(context).pop(source),
    );
  }
}
