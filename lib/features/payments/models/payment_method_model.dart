import 'package:skygate/core/constants/payment_assets.dart';
import 'package:skygate/core/utils/api_parse.dart';

/// `PaymentMethodResource` — one option of "طريقة التحويل".
///
/// The card prints [name], [subtitle] and every line of [instructions] as a
/// bullet, so the whole body of a method is authored by the back office rather
/// than hardcoded per provider.
class PaymentMethodModel {
  int? id;
  String? name;

  /// The grey line under the name, e.g. "قم بالدفع في أقرب فرع".
  String? subtitle;

  /// The bulleted steps the payer follows. Already localised by the
  /// `Accept-Language` header.
  List<String> instructions = const [];

  /// Provider logo. Falls back to a bundled one when the API sends none —
  /// see [logoFallback].
  String? image;

  bool isActive = true;

  PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    name = ApiParse.stringOf(json['name']);
    subtitle = ApiParse.stringOf(json['subtitle']);
    instructions = ApiParse.stringsOf(json['instructions']);
    image = ApiParse.stringOf(json['image']);
    isActive = json['is_active'] != false;
  }

  /// Bundled logo to show while [image] is null, matched on the provider's
  /// name. Anything unrecognised falls back to the شام كاش mark rather than an
  /// empty box.
  String get logoFallback {
    final value = name?.toLowerCase() ?? '';
    final isHaram =
        value.contains('haram') ||
        value.contains('هرم') ||
        value.contains('الحرم');
    return isHaram ? PaymentAssets.alHaram : PaymentAssets.shamCash;
  }
}
