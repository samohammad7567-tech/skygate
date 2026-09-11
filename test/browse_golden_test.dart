import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skygate/core/models/group_room_type.dart';
import 'package:skygate/core/themes/light_theme.dart';
import 'package:skygate/core/utils/cache_util.dart';
import 'package:skygate/features/carriers/views/flights_screen.dart';
import 'package:skygate/features/carriers/views/maritime_transport_screen.dart';
import 'package:skygate/features/carriers/views/trains_screen.dart';
import 'package:skygate/features/carriers/views/transport_screen.dart';
import 'package:skygate/features/hotels/models/hotel_filter.dart';
import 'package:skygate/features/hotels/views/hotels_browse_screen.dart';
import 'package:skygate/features/hotels/widgets/hotel_filter_sheet.dart';
import 'package:skygate/generated/codegen_loader.g.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    TestWidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    await CacheUtil.init();
  });

  Widget host(Widget child) => EasyLocalization(
    supportedLocales: const [Locale('ar'), Locale('en')],
    path: 'assets/lang',
    fallbackLocale: const Locale('ar'),
    startLocale: const Locale('ar'),
    assetLoader: const CodegenLoader(),
    child: Builder(
      builder: (context) => MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: LightTheme.theme,
        home: child,
      ),
    ),
  );

  Future<void> shoot(WidgetTester tester, Widget child, String name) async {
    tester.view.physicalSize = const Size(412, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(host(child));
    await tester.pumpAndSettle();
    await _decodeImages(tester);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/$name.png'),
    );
  }

  testWidgets('flights', (t) => shoot(t, const FlightsScreen(), '40_flights'));
  testWidgets('trains', (t) => shoot(t, const TrainsScreen(), '41_trains'));
  testWidgets(
    'maritime',
    (t) => shoot(t, const MaritimeTransportScreen(), '42_maritime'),
  );
  testWidgets(
    'transport',
    (t) => shoot(t, const TransportScreen(), '43_transport'),
  );
  testWidgets(
    'hotels browse',
    (t) => shoot(t, const HotelsBrowseScreen(), '44_hotels_browse'),
  );

  testWidgets('hotel filter sheet', (tester) async {
    await shoot(
      tester,
      Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: HotelFilterSheet(
            filter: HotelFilter(
              roomType: GroupRoomType.single,
              from: DateTime(2026, 8, 18),
              to: DateTime(2026, 8, 18),
              minRating: 4,
            ),
          ),
        ),
      ),
      '45_hotel_filter_sheet',
    );

    // Expanding the room row swaps the body for the option list.
    await tester.tap(find.text('غرفة فردية').first);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/46_hotel_filter_rooms.png'),
    );
  });
}

Future<void> _decodeImages(WidgetTester tester) async {
  await tester.runAsync(() async {
    for (final element in tester.elementList(find.byType(Image))) {
      final image = element.widget as Image;
      await precacheImage(image.image, element);
    }
  });
  await tester.pumpAndSettle();
}
