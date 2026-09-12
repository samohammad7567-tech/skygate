import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_sheet.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/core/models/activity_model.dart';

/// The filter behind "الأنشطة": all of them, or only the kinds ticked.
///
/// "جميع الأنشطة" is the same thing as nothing ticked, so it is drawn as the
/// first row rather than as a separate control, and ticking it clears the
/// rest the way the design shows.
class ActivityFilterSheet extends StatefulWidget {
  const ActivityFilterSheet({
    super.key,
    required this.selected,
    required this.onApply,
  });

  final Set<ActivityKind> selected;
  final ValueChanged<Set<ActivityKind>> onApply;

  static Future<void> show(
    BuildContext context, {
    required Set<ActivityKind> selected,
    required ValueChanged<Set<ActivityKind>> onApply,
  }) => showAppSheet<void>(
    context,
    builder: (_) => ActivityFilterSheet(selected: selected, onApply: onApply),
  );

  @override
  State<ActivityFilterSheet> createState() => _ActivityFilterSheetState();
}

class _ActivityFilterSheetState extends State<ActivityFilterSheet> {
  late final Set<ActivityKind> _selected = {...widget.selected};

  bool get _isAll => _selected.isEmpty;

  void _toggle(ActivityKind kind) => setState(() {
    if (!_selected.remove(kind)) _selected.add(kind);
  });

  void _apply() {
    Navigator.of(context).pop();
    widget.onApply(_selected);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetHandle(),
            const Gap(16),
            _Row(
              labelKey: 'activities',
              valueKey: 'all_activities',
              isChecked: _isAll,
              onChanged: () => setState(_selected.clear),
            ),
            for (final kind in ActivityKind.values)
              _Row(
                labelKey: 'activity_kind',
                valueKey: kind.labelKey,
                asset: kind.icon,
                color: kind.color,
                surface: kind.surface,
                isChecked: _selected.contains(kind),
                onChanged: () => _toggle(kind),
              ),
            const Gap(18),
            CustomButton(
              label: 'search'.tr(),
              height: 48,
              width: double.infinity,
              onPressed: _apply,
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.labelKey,
    required this.valueKey,
    required this.isChecked,
    required this.onChanged,
    this.asset,
    this.color,
    this.surface,
  });

  final String labelKey;
  final String valueKey;
  final bool isChecked;
  final VoidCallback onChanged;

  final String? asset;
  final Color? color;
  final Color? surface;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onChanged,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            _Plate(asset: asset, color: color, surface: surface),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    labelKey.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                  const Gap(2),
                  Text(
                    valueKey.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(8),
            Checkbox(value: isChecked, onChanged: (_) => onChanged()),
          ],
        ),
      ),
    );
  }
}

class _Plate extends StatelessWidget {
  const _Plate({this.asset, this.color, this.surface});

  final String? asset;
  final Color? color;
  final Color? surface;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glyph = asset;

    return Container(
      height: 42,
      width: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: surface ?? theme.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: glyph == null
          ? Icon(
              Icons.tune_rounded,
              size: 20,
              color: color ?? theme.colorScheme.primary,
            )
          : AppImage(
              glyph,
              height: 20,
              width: 20,
              color: color ?? theme.colorScheme.primary,
            ),
    );
  }
}
