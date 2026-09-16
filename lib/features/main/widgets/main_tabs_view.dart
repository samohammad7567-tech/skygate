import 'package:flutter/material.dart';
import 'package:skygate/core/utils/app_scale.dart';
import 'package:skygate/features/sos/widgets/sos_button.dart';

class MainTabsView extends StatelessWidget {
  const MainTabsView({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.hasVisited,
  });

  final List<Widget> tabs;
  final int currentIndex;
  final bool Function(int index) hasVisited;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IndexedStack(
          index: currentIndex,
          children: [
            for (var i = 0; i < tabs.length; i++)
              if (hasVisited(i)) tabs[i] else const SizedBox.shrink(),
          ],
        ),
        PositionedDirectional(
          start: 10.s,
          bottom: SosButton.bottomInset.s,
          child: SafeArea(child: SosButton()),
        ),
      ],
    );
  }
}
