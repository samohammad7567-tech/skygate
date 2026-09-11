import 'package:flutter/widgets.dart';

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
  static double get cardWidth => isTablet ? 360 : width * 0.78;
  static double get buttonWidth => isTablet ? 420 : width - 32;
}
