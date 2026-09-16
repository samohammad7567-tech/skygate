import 'package:flutter/widgets.dart';

class AppScale {
  AppScale._();
  static const Size designSize = Size(412, 917);

  static double _width = designSize.width;
  static double _height = designSize.height;
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

  static const double _maxRatio = 1.2;
  static double get widthRatio =>
      (_width / designSize.width).clamp(0.0, _maxRatio);

  static double get heightRatio =>
      (_height / designSize.height).clamp(0.0, _maxRatio);
  static double get textRatio => (_width / designSize.width).clamp(0.85, 1.15);
}

extension AppScaleExtension on num {
  double get s => this * AppScale.widthRatio;
  double get fs => this * AppScale.textRatio;
  double get vs => this * AppScale.heightRatio;
}
