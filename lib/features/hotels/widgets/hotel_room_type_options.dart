import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:skygate/core/models/group_room_type.dart';
import 'package:skygate/core/utils/app_scale.dart';

class HotelRoomTypeOptions extends StatelessWidget {
  const HotelRoomTypeOptions({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final GroupRoomType? selected;
  final ValueChanged<GroupRoomType> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final type in GroupRoomType.values)
          InkWell(
            onTap: () => onSelected(type),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.s),
              color: type == selected
                  ? theme.colorScheme.surfaceContainerHighest
                  : Colors.transparent,
              alignment: AlignmentDirectional.center,
              child: Text(
                type.labelKey.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
