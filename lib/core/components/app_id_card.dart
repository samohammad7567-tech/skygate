import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/my_trips_assets.dart';
import 'package:skygate/core/utils/app_scale.dart';

class AppIdCard extends StatelessWidget {
  const AppIdCard({super.key, required this.header, required this.child});
  final Widget header;
  final Widget child;

  static const double _radius = 18;
  static const double _rule = 6;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_radius),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(18.s, 16.s, 18.s, 16.s),
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              border: Border(
                bottom: BorderSide(color: AppColors.accent, width: _rule),
              ),
            ),
            child: header,
          ),
          Container(
            color: AppColors.surface,
            child: Stack(
              children: [
                PositionedDirectional(
                  start: 0,
                  end: 0,
                  bottom: 0,
                  child: Opacity(
                    opacity: 0.14,
                    child: AppImage(
                      MyTripsAssets.cardWatermark,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.s, 18.s, 16.s, 18.s),
                  child: child,
                ),
              ],
            ),
          ),
          Container(height: 18.s, color: AppColors.primaryDark),
        ],
      ),
    );
  }
}

class AppCardRule extends StatelessWidget {
  const AppCardRule({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: AppColors.accentSoft, height: 1.s),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.s),
          child: Transform.rotate(
            angle: 0.785398,
            child: Container(height: 6.s, width: 6.s, color: AppColors.accent),
          ),
        ),
        Expanded(
          child: Divider(color: AppColors.accentSoft, height: 1.s),
        ),
      ],
    );
  }
}
