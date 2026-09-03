import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../global_widgets/svg_icon.dart';
// ignore_for_file: deprecated_member_use

enum BottomNavigationItem { home, nearestProvider, add, alarm }

class CustomBottomNavigationBar extends StatelessWidget {
  final BottomNavigationItem selectedItem;

  final Function(BottomNavigationItem item) onSelect;

  const CustomBottomNavigationBar(
      {Key? key, required this.selectedItem, required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...BottomNavigationItem.values.map<Widget>((e) => BottomItem(
                  item: e,
                  selectedItem: selectedItem,
                  onSelect: onSelect,
                )),
          ],
        ),
      ),
    );
  }
}

class BottomItem extends StatelessWidget {
  final BottomNavigationItem item;
  final BottomNavigationItem selectedItem;
  final Function(BottomNavigationItem item) onSelect;

  const BottomItem(
      {Key? key,
      required this.item,
      required this.selectedItem,
      required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool selected = selectedItem == item;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              children: [
                SvgIcon(
                  getResourcePathForItem(item),
                  size: 25,
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(selected ? 1 : 0.5),
                ),
                if (selected)
                  const SizedBox(
                    height: 3.3,
                  ),
                if (selected)
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.blue.shade100,
                    ),
                  ),
              ],
            ),
          ),
          onTap: () {
            onSelect(item);
          },
        ),
      ],
    );
  }
}

String getResourcePathForItem(BottomNavigationItem item) {
  switch (item) {
    case BottomNavigationItem.home:
      return 'icons/home_icon.svg';
    case BottomNavigationItem.nearestProvider:
      return 'icons/location.svg';
    case BottomNavigationItem.add:
      return 'icons/add_icon.svg';
    case BottomNavigationItem.alarm:
      return 'icons/bell.svg';
  }
}
