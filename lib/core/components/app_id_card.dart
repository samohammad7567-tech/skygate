import 'package:flutter/material.dart';
import 'package:skygate/core/components/app_image.dart';
import 'package:skygate/core/constants/app_colors.dart';
import 'package:skygate/core/constants/my_trips_assets.dart';

/// The printed-card frame the app shows for a pilgrim's ID card and for a
/// luggage tag: a navy band ruled off in gold, a white face, and a navy foot.
///
/// All three faces in the design (pilgrim front, pilgrim back, luggage tag)
/// are this frame with different contents, so the chrome lives here and the
/// sheets pass only what sits on it.
class AppIdCard extends StatelessWidget {
  const AppIdCard({super.key, required this.header, required this.child});

  /// Drawn on the navy band — a title pair, or a portrait beside a name.
  final Widget header;

  /// The white face under the gold rule.
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
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              border: Border(
                bottom: BorderSide(color: AppColors.accent, width: _rule),
              ),
            ),
            child: header,
          ),
          // The face carries the printed card's watermark: the mosque skyline
          // sitting on its bottom edge, faint enough to read through.
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
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                  child: child,
                ),
              ],
            ),
          ),
          // The foot is the card's own edge rather than a content row, so it
          // carries no padding — it only closes the face in navy.
          Container(height: 18, color: AppColors.primaryDark),
        ],
      ),
    );
  }
}

/// The thin gold rule with the diamond in its middle that separates the
/// blocks on a card face.
class AppCardRule extends StatelessWidget {
  const AppCardRule({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.accentSoft, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Transform.rotate(
            angle: 0.785398,
            child: Container(height: 6, width: 6, color: AppColors.accent),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.accentSoft, height: 1)),
      ],
    );
  }
}
