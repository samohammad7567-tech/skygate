import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/features/profile/models/pilgrim_document_model.dart';

class DocumentStatusChip extends StatelessWidget {
  const DocumentStatusChip({super.key, required this.status});

  final DocumentReviewStatus? status;

  @override
  Widget build(BuildContext context) {
    final review = status;
    if (review == null) return const SizedBox.shrink();

    final (surface, foreground) = switch (review) {
      DocumentReviewStatus.approved => (_approvedSurface, AppColors.success),
      DocumentReviewStatus.rejected => (_rejectedSurface, AppColors.error),
      // The purple of the design, shared with the journey "شعائر" plate.
      DocumentReviewStatus.pending => (AppColors.ritualSurface, _pendingText),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        review.labelKey.tr(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: foreground),
      ),
    );
  }
}

const Color _approvedSurface = Color(0xFFD8F0E3);
const Color _rejectedSurface = Color(0xFFFBD9D9);
const Color _pendingText = Color(0xFF6D28D9);
