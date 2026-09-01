import 'package:flutter/widgets.dart';

/// Responsive sizing helpers. Call [init] from the first widget that has a
/// [BuildContext] with a valid [MediaQuery].
class ScreenSize {
  ScreenSize._();

  static double width = 0;
  static double height = 0;

  static void init(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    width = size.width;
    height = size.height;
  }

  static bool get isMobile => width < 600;

  static bool get isTablet => width >= 600;

  /// Width of a horizontally scrolling offer card.
  static double get cardWidth => isTablet ? 360 : width * 0.78;

  /// Width of a full-bleed primary button inside the default page padding.
  static double get buttonWidth => isTablet ? 420 : width - 32;
}
