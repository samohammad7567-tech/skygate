import 'package:flutter/material.dart';

/// Opens a modal bottom sheet dressed the way every sheet in the app is: on
/// the surface colour, with its top two corners rounded to 20.
///
/// Pair the [builder]'s content with a [SheetHandle] at the top — the grab bar
/// is the content's own first row rather than part of the frame, so a sheet
/// that scrolls keeps it pinned.
Future<T?> showAppSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: builder,
  );
}
