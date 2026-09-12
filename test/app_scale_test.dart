import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skygate/core/components/custom_button.dart';
import 'package:skygate/core/utils/app_scale.dart';

/// Puts [child] on a window of exactly [size] and seeds [AppScale] from it,
/// the way the app root does.
/// [build] runs after the scale is seeded, which is the order the real app
/// gets: the root initialises AppScale, then every screen below it builds.
Widget host(Size size, WidgetBuilder build) => MediaQuery(
  data: MediaQueryData(size: size),
  child: Builder(
    builder: (context) {
      AppScale.init(context);
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Builder(builder: build),
      );
    },
  ),
);

void main() {
  setUp(AppScale.reset);
  tearDown(AppScale.reset);

  group('AppScale', () {
    test(
      'an uninitialised scale renders every dimension at its design value',
      () {
        expect(AppScale.widthRatio, 1.0);
        expect(AppScale.heightRatio, 1.0);
        expect(AppScale.textRatio, 1.0);
        expect(20.s, 20.0);
        expect(18.fs, 18.0);
        expect(230.vs, 230.0);
      },
    );

    testWidgets('the design width is the fixed point', (tester) async {
      await _pumpAt(tester, AppScale.designSize);

      expect(AppScale.widthRatio, 1.0);
      expect(20.s, 20.0);
      expect(18.fs, 18.0);
    });

    testWidgets('a narrower phone shrinks with it', (tester) async {
      // 320 is the narrowest width Android still ships.
      await _pumpAt(tester, const Size(320, 640));

      expect(AppScale.widthRatio, closeTo(320 / 412, 0.0001));
      expect(20.s, closeTo(20 * 320 / 412, 0.01));
      // Type is held back from tracking the box all the way down, so a
      // caption stays readable.
      expect(AppScale.textRatio, 0.85);
      expect(11.fs, closeTo(9.35, 0.01));
    });

    testWidgets('a wider phone grows with it', (tester) async {
      await _pumpAt(tester, const Size(480, 1000));

      expect(AppScale.widthRatio, closeTo(480 / 412, 0.0001));
      expect(20.s, closeTo(20 * 480 / 412, 0.01));
    });

    testWidgets('a tablet stops growing and takes the slack as margin', (
      tester,
    ) async {
      // 800/412 is 1.94 — matched literally, a 14pt caption would land at 27.
      await _pumpAt(tester, const Size(800, 1200));

      expect(AppScale.widthRatio, 1.2);
      expect(AppScale.heightRatio, 1.2);
      expect(AppScale.textRatio, 1.15);
      expect(20.s, 24.0);
    });

    testWidgets('height scales on its own axis', (tester) async {
      await _pumpAt(tester, const Size(412, 640));

      expect(AppScale.widthRatio, 1.0);
      expect(AppScale.heightRatio, closeTo(640 / 917, 0.0001));
      // A hero banner gives way on a short screen; everything beside it,
      // measured with `.s`, holds its design size.
      expect(230.vs, closeTo(230 * 640 / 917, 0.01));
      expect(230.s, 230.0);
    });

    testWidgets('an empty window is ignored rather than collapsing the app', (
      tester,
    ) async {
      await _pumpAt(tester, Size.zero);

      expect(AppScale.widthRatio, 1.0);
      expect(20.s, 20.0);
    });
  });

  group('a widget drawn through the scale', () {
    testWidgets('takes its design height at the design width', (tester) async {
      await _pumpAt(
        tester,
        AppScale.designSize,
        build: (_) => Center(
          child: CustomButton(label: 'x', width: 200.s, onPressed: () {}),
        ),
      );

      // CustomButton's own default height is 44 in design units.
      expect(tester.getSize(find.byType(CustomButton)).height, 44.0);
      expect(tester.getSize(find.byType(CustomButton)).width, 200.0);
    });

    testWidgets('and shrinks with a narrower one', (tester) async {
      await _pumpAt(
        tester,
        const Size(320, 640),
        build: (_) => Center(
          child: CustomButton(label: 'x', width: 200.s, onPressed: () {}),
        ),
      );

      final size = tester.getSize(find.byType(CustomButton));
      expect(size.height, closeTo(44 * 320 / 412, 0.01));
      expect(size.width, closeTo(200 * 320 / 412, 0.01));
    });
  });
}

Future<void> _pumpAt(
  WidgetTester tester,
  Size size, {
  WidgetBuilder build = _nothing,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(host(size, build));
}

Widget _nothing(BuildContext context) => const SizedBox.shrink();
