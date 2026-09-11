import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:skygate/core/constants/vip_trip_assets.dart';
import 'package:skygate/core/models/booking_city.dart';
import 'package:skygate/core/models/group_room_type.dart';
import 'package:skygate/core/models/traveler_audience.dart';
import 'package:skygate/features/vip_trip/controller/cubit/vip_trip_cubit.dart';
import 'package:skygate/features/vip_trip/models/private_trip_request_model.dart';

void main() {
  test('every VipTripAssets path exists on disk', () {
    final missing = VipTripAssets.all
        .where((path) => !File(path).existsSync())
        .toList();
    expect(missing, isEmpty, reason: 'Missing asset files: $missing');
  });

  test('VipTripAssets.all has no duplicates', () {
    expect(VipTripAssets.all.toSet().length, VipTripAssets.all.length);
  });

  test('every VIP asset sits in a folder pubspec bundles', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    for (final path in VipTripAssets.all) {
      final folder = '${path.substring(0, path.lastIndexOf('/'))}/';
      expect(pubspec, contains('- $folder'), reason: '$path is not bundled');
    }
  });

  group('the request body', () {
    late VipTripCubit cubit;

    setUp(() {
      cubit = VipTripCubit()
        ..setCount(TravelerAudience.adult, 2)
        ..setCount(TravelerAudience.child, 4)
        ..setCount(TravelerAudience.infant, 2)
        ..setStartDate(DateTime(2026, 2, 1))
        ..setEndDate(DateTime(2026, 2, 8))
        ..setNights(BookingCity.makkah, 4)
        ..setNights(BookingCity.madinah, 3)
        ..setRoomCounts({
          GroupRoomType.twin: 2,
          GroupRoomType.quad: 2,
          GroupRoomType.triple: 0,
        });
    });

    tearDown(() => cubit.close());

    test('sends the documented fields in the documented shape', () {
      final body = cubit.body();

      expect(body['people_count'], 8);
      expect(body['adult_count'], 2);
      expect(body['child_count'], 4);
      expect(body['infant_count'], 2);
      expect(body['preferred_start_date'], '2026-02-01');
      expect(body['preferred_end_date'], '2026-02-08');
      expect(body['requirements'], isA<String>());
    });

    /// Both id lists are declared "must match an existing stored value", and
    /// nothing publishes room-type ids — a fabricated one would fail the whole
    /// request rather than a single field.
    test('never invents room type or hotel ids', () {
      final body = cubit.body();
      expect(body.containsKey('room_type_ids'), isFalse);
      expect(body.containsKey('hotel_ids'), isFalse);
    });

    test('carries the per-city nights and the room quantities alongside', () {
      final body = cubit.body();
      expect(body['makkah_nights'], 4);
      expect(body['madinah_nights'], 3);
      expect(body['rooms'], [
        {'room_type': 'twin', 'count': 2},
        {'room_type': 'quad', 'count': 2},
      ]);
    });

    /// `requirements` is capped at 1000 characters by the API, so a long note
    /// must not be what makes six steps of work bounce.
    test('trims requirements to the length the API accepts', () {
      cubit.requirementsController.text = 'ب' * 1500;
      expect(
        (cubit.body()['requirements'] as String).length,
        VipTripCubit.maxRequirementsLength,
      );
    });
  });

  test('an end date the new start overtakes is dropped', () {
    final cubit = VipTripCubit()
      ..setStartDate(DateTime(2026, 2, 1))
      ..setEndDate(DateTime(2026, 2, 5));
    expect(cubit.endDate, isNotNull);

    cubit.setStartDate(DateTime(2026, 3, 1));
    expect(cubit.endDate, isNull, reason: 'the API rejects end <= start');
    cubit.close();
  });

  test('rooms set back to zero leave the step empty again', () {
    final cubit = VipTripCubit()..setRoomCounts({GroupRoomType.twin: 2});
    expect(cubit.hasRooms, isTrue);

    cubit.setRoomCounts({GroupRoomType.twin: 0});
    expect(cubit.hasRooms, isFalse);
    expect(cubit.totalRooms, 0);
    cubit.close();
  });

  group('PrivateTripStatus', () {
    /// A label nobody wrote down must never read as approved or priced.
    test('falls back to pending', () {
      expect(PrivateTripStatus.of(null), PrivateTripStatus.pending);
      expect(PrivateTripStatus.of(''), PrivateTripStatus.pending);
      expect(PrivateTripStatus.of('submitted'), PrivateTripStatus.pending);
    });

    test('reads the four the design draws', () {
      expect(PrivateTripStatus.of(['quoted']), PrivateTripStatus.quoted);
      expect(PrivateTripStatus.of('APPROVED'), PrivateTripStatus.approved);
      expect(PrivateTripStatus.of(' cancelled '), PrivateTripStatus.cancelled);
      expect(PrivateTripStatus.of('rejected'), PrivateTripStatus.cancelled);
    });

    test('only a live request can be withdrawn', () {
      expect(PrivateTripStatus.pending.canCancel, isTrue);
      expect(PrivateTripStatus.quoted.canCancel, isTrue);
      expect(PrivateTripStatus.approved.canCancel, isFalse);
      expect(PrivateTripStatus.cancelled.canCancel, isFalse);
    });
  });

  test('PrivateTripRequestModel reads the resource leniently', () {
    final request = PrivateTripRequestModel.fromJson(const {
      'id': 7,
      'adult_count': 2,
      'child_count': 4,
      'infant_count': 2,
      'preferred_start_date': '2026-02-01',
      'preferred_end_date': '2026-02-08',
      // The resource types both id lists as arrays of strings.
      'hotel_ids': ['3', '9'],
      'room_type_ids': ['1'],
      'requirements': 'سرير إضافي\r\nقريب من الحرم',
      'status': ['quoted'],
      'rooms': [
        {'room_type': 'quad', 'count': 2},
      ],
    });

    expect(request.hotelIds, [3, 9]);
    expect(request.roomTypeIds, [1]);
    // `people_count` was absent, so the head count is computed.
    expect(request.travelers, 8);
    expect(request.requirements, hasLength(2));
    expect(request.status, PrivateTripStatus.quoted);
    expect(request.roomCounts, {GroupRoomType.quad: 2});
    expect(request.days, 8);
  });

  test('every VIP translation key is present in both locales', () {
    final keys = [
      'private_trip_request_title',
      'private_trip_request',
      'private_trip_request_details',
      'private_trip_requests',
      'private_trip_request_sent',
      'select_people_count',
      'total_travelers_count',
      'travelers_count',
      'travelers_number',
      'select_trip_duration',
      'select_trip_duration_desc',
      'total_trip_duration',
      'applies_to_both_cities',
      'rooms_and_types',
      'rooms_count',
      'room_count_of',
      'other_requirements',
      'other_requirements_desc',
      'write_your_notes_here',
      'travelers',
      'room_types',
      'notes',
      'confirm_request',
      'congratulations',
      'back_to_home',
      'vip_request_number',
      'submit_private_trip_request',
      'no_private_trip_requests',
      'cancel_request',
      'cancel_request_question',
      'request_cancelled',
      'quote_details',
      'start_booking_steps',
      'step_of',
      'continue_step',
      'back_step',
      for (final status in PrivateTripStatus.values) status.labelKey,
      for (final city in BookingCity.values) ...[
        city.labelKey,
        city.nightsLabelKey,
        city.hotelLabelKey,
      ],
      for (final type in GroupRoomType.values) type.labelKey,
      for (final audience in TravelerAudience.values) audience.countLabelKey,
    ];

    // The bundled JSON is the source; codegen_loader.g.dart is what the app
    // actually loads, so a key added to one and not the other ships as a raw
    // key on screen.
    final generated = File(
      'lib/generated/codegen_loader.g.dart',
    ).readAsStringSync();

    for (final file in ['assets/lang/ar.json', 'assets/lang/en.json']) {
      final json =
          jsonDecode(File(file).readAsStringSync()) as Map<String, dynamic>;
      for (final key in keys) {
        expect(
          json.containsKey(key),
          isTrue,
          reason: '$key missing from $file',
        );
        expect(
          (json[key] as String).trim(),
          isNotEmpty,
          reason: '$key empty in $file',
        );
        expect(
          generated,
          contains('"$key"'),
          reason: '$key missing from codegen_loader.g.dart',
        );
      }
    }
  });
}
