import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/utils/app_scale.dart';

/// One `label` over `value` block, both hung on the start edge — the shape
/// every line of an amendment card takes.
class BookingChangeField extends StatelessWidget {
  const BookingChangeField({
    super.key,
    required this.label,
    this.value,
    this.maxLines = 2,
  });

  final String label;

  /// A line the API has not filled still draws, with an em dash, so the card
  /// keeps its height across the list.
  final String? value;

  /// The card's lines hold one or two; the details screen's notes run long.
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          // bodySmall carries the muted ink in both themes; the design
          // prints the label a step larger than a caption.
          style: theme.textTheme.bodySmall?.copyWith(fontSize: 13.fs),
        ),
        Gap(6.s),
        Text(
          value?.trim().isEmpty ?? true ? '—' : value!,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
