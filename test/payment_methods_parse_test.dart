import 'package:flutter_test/flutter_test.dart';
import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/constants/payment_assets.dart';
import 'package:skygate/core/utils/api_parse.dart';
import 'package:skygate/features/payments/models/payment_method_model.dart';

void main() {
  final response = <String, dynamic>{
    'data': {
      'items': [
        {
          'id': 1,
          'name': 'تحويل عن طريق البنك',
          'subtitle': 'بنك بيمو - البنك الدولي الإسلامي',
          'instructions':
              'رقم الحساب: RTG432432432p99890432\r\nرقم IBAN:BAN43143242342432432432',
          'image': 'payment-methods/June2025/S4F0HJelPq5X1Fr5yi6E.png',
          'is_active': true,
        },
        {
          'id': 3,
          'name': 'الدفع في المكتب',
          'subtitle': 'SKYGATE',
          'instructions': null,
          'image': null,
          'is_active': true,
        },
        {
          'id': 9,
          'name': 'موقوف',
          'instructions': null,
          'image': null,
          'is_active': 0,
        },
      ],
    },
    'message': 'Success',
    'status_code': 1,
  };

  test('reads the rows out of the data.items envelope', () {
    final methods = ApiParse.rowsOf(
      response['data'],
      PaymentMethodModel.fromJson,
    );

    expect(methods.length, 3);
    expect(methods.first.id, 1);
    expect(methods.first.name, 'تحويل عن طريق البنك');
  });

  test('splits the instructions block into one bullet per line', () {
    final methods = ApiParse.rowsOf(
      response['data'],
      PaymentMethodModel.fromJson,
    );

    expect(methods.first.instructions, [
      'رقم الحساب: RTG432432432p99890432',
      'رقم IBAN:BAN43143242342432432432',
    ]);
    expect(methods[1].instructions, isEmpty);
  });

  test('resolves the storage-relative image to an absolute URL', () {
    final methods = ApiParse.rowsOf(
      response['data'],
      PaymentMethodModel.fromJson,
    );

    expect(
      methods.first.image,
      '${ApiEndpoints.mediaPath}payment-methods/June2025/S4F0HJelPq5X1Fr5yi6E.png',
    );
    expect(methods[1].image, isNull);
    expect(
      ApiEndpoints.mediaUrl('https://cdn.test/a.png'),
      'https://cdn.test/a.png',
    );
  });

  test('drops a method the API flags inactive as the tinyint 0', () {
    final active = ApiParse.rowsOf(
      response['data'],
      PaymentMethodModel.fromJson,
    ).where((method) => method.isActive).toList();

    expect(active.map((method) => method.id), [1, 3]);
  });

  test('still reads a bare array in data, the shape the document shows', () {
    final methods = ApiParse.rowsOf([
      {'id': 4, 'name': 'شام كاش', 'is_active': true},
    ], PaymentMethodModel.fromJson);

    expect(methods.single.name, 'شام كاش');
  });
  test('brands a method only when its name says so', () {
    String logoOf(String name) =>
        PaymentMethodModel.fromJson({'name': name}).logoFallback;

    expect(logoOf('شام كاش'), PaymentAssets.shamCash);
    expect(logoOf('حوالة هرم'), PaymentAssets.alHaram);
    expect(logoOf('إيداع بنكي'), PaymentAssets.genericMethod);
    expect(logoOf('نقدي بالمكتب'), PaymentAssets.genericMethod);
    expect(logoOf('الدفع في المكتب'), PaymentAssets.genericMethod);
  });
}
