import 'package:flutter/widgets.dart';

/// The silhouette of `HomeAssets.artworkPlate`, so the Kaaba photo on the
/// custom-trip card can be cut to the same shape as the blue plate it sits on.
///
/// Coordinates are copied straight from the export's path and scaled from its
/// viewBox onto whatever box the clipper is given.
class ArtworkPlateClipper extends CustomClipper<Path> {
  const ArtworkPlateClipper();

  static const Size _viewBox = Size(145, 234);

  @override
  Path getClip(Size size) {
    final sx = size.width / _viewBox.width;
    final sy = size.height / _viewBox.height;
    Offset at(double x, double y) => Offset(x * sx, y * sy);

    final start = at(20.4903, 70.9725);
    final path = Path()..moveTo(start.dx, start.dy);

    void curve(Offset c1, Offset c2, Offset end) =>
        path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, end.dx, end.dy);

    // Up the curved edge that faces the copy, then round into the top corner.
    curve(at(29.9625, 39.0933), at(53.2564, 16.2028), at(61.7381, 8.67729));
    curve(at(63.7458, 6.89585), at(66.3508, 6), at(69.035, 6));
    path.lineTo(at(123, 6).dx, at(123, 6).dy);
    curve(at(129.627, 6), at(135, 11.3726), at(135, 18));
    // Straight outer edge down to the bottom corner.
    path.lineTo(at(135, 212).dx, at(135, 212).dy);
    curve(at(135, 218.627), at(129.627, 224), at(123, 224));
    path.lineTo(at(19.5947, 224).dx, at(19.5947, 224).dy);
    curve(at(13.7975, 224), at(8.87017, 219.858), at(8.19998, 214.1));
    curve(at(5.58949, 191.671), at(1.7613, 134.006), start);

    return path..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
