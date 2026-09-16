import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/components/app_sheet.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/components/sheet_handle.dart';
import 'package:skygate/core/models/activity_model.dart';
import 'package:skygate/core/utils/app_scale.dart';

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
        padding: EdgeInsets.fromLTRB(20.s, 12.s, 20.s, 20.s),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SheetHandle(),
            Gap(16.s),
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
            Gap(18.s),
            CustomButton(
              label: 'search'.tr(),
              height: 48.s,
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
      borderRadius: BorderRadius.circular(10.s),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.s),
        child: Row(
          children: [
            _Plate(asset: asset, color: color, surface: surface),
            Gap(10.s),
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
                  Gap(2.s),
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
            Gap(8.s),
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
      height: 42.s,
      width: 42.s,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: surface ?? theme.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: glyph == null
          ? Icon(
              Icons.tune_rounded,
              size: 20.s,
              color: color ?? theme.colorScheme.primary,
            )
          : AppImage(
              glyph,
              height: 20.s,
              width: 20.s,
              color: color ?? theme.colorScheme.primary,
            ),
    );
  }
}
