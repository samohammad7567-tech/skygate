import 'package:flutter/widgets.dart';

/// Scales the Umrah side's hand-tuned dimensions to the device it is drawn on.
///
/// Every mockup under `screens/` is 412 wide, and every literal in
/// `lib/features` and `lib/core` was measured against one — so 412 is what a
/// raw number here means, and [designSize] says so out loud.
///
/// `lib/tourism` is drawn against 435x926 and scales itself with
/// `flutter_screenutil`; nothing here touches it. That is also why these
/// extensions are named `.s` / `.fs` / `.vs` instead of borrowing ScreenUtil's
/// own names. ScreenUtil already defines `.w`, `.h`, `.r`, `.sp`, `.sw` and
/// `.sh` on `num`, and `.sh` there means a *fraction of the screen height* —
/// `1.sh` is the full height. Reusing any of those would leave a file's
/// dimensions meaning one of two very different things depending only on its
/// imports.
class AppScale {
  AppScale._();

  /// The canvas the Umrah screens were drawn on.
  static const Size designSize = Size(412, 917);

  static double _width = designSize.width;
  static double _height = designSize.height;

  /// Reads the window the app is actually in. Called once from the app root,
  /// where `MediaQuery` re-runs the build on a rotation or a resize, so the
  /// ratios below follow the device rather than the launch geometry.
  ///
  /// Left uncalled — a widget test that pumps one screen on its own — the
  /// ratios stay at 1.0 and every dimension renders at its design value.
  static void init(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (size.isEmpty) return;
    _width = size.width;
    _height = size.height;
  }

  @visibleForTesting
  static void reset() {
    _width = designSize.width;
    _height = designSize.height;
  }

  /// Widened past this a phone is a tablet, and matching its width would blow
  /// the type and the padding up with it. Past the cap the layout keeps its
  /// proportions and the extra width becomes margin instead.
  static const double _maxRatio = 1.2;

  /// Narrower than the design the ratio is left alone — shrinking with the
  /// device is the safe direction, and a floor above the true ratio is what
  /// makes a 320-wide phone overflow.
  static double get widthRatio =>
      (_width / designSize.width).clamp(0.0, _maxRatio);

  static double get heightRatio =>
      (_height / designSize.height).clamp(0.0, _maxRatio);

  /// Type is held closer to its design size than the boxes around it: a
  /// caption tracked all the way down to a 320-wide phone stops being
  /// readable. Every `Text` in the app carries `maxLines` and an ellipsis, so
  /// the line that no longer fits truncates rather than overflows.
  static double get textRatio => (_width / designSize.width).clamp(0.85, 1.15);
}

/// The three scales the Umrah side uses. See [AppScale] for why they are not
/// called `.w`, `.sp` and `.h`.
extension AppScaleExtension on num {
  /// Width-driven, and what almost everything takes: padding, gaps, corner
  /// radii, icon sizes, and the fixed heights — a button, a chip, a row — that
  /// should stay in proportion with the width beside them rather than stretch
  /// on a tall screen.
  double get s => this * AppScale.widthRatio;

  /// Font sizes.
  double get fs => this * AppScale.textRatio;

  /// Height-driven, for the few boxes that genuinely track the screen's
  /// height: a hero header, a map pane, a sheet's resting height.
  double get vs => this * AppScale.heightRatio;
}
