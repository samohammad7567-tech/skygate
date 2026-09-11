import 'package:skygate/core/constants/api_endpoints.dart';
import 'package:skygate/core/constants/payment_assets.dart';
import 'package:skygate/core/utils/api_parse.dart';

class PaymentMethodModel {
  int? id;
  String? name;
  String? subtitle;
  List<String> instructions = const [];
  String? image;

  bool isActive = true;

  PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    name = ApiParse.stringOf(json['name']);
    subtitle = ApiParse.stringOf(json['subtitle']);
    instructions = ApiParse.linesOf(json['instructions']);
    image = ApiEndpoints.mediaUrl(ApiParse.stringOf(json['image']));
    isActive = ApiParse.boolOf(json['is_active']);
  }
  String get logoFallback {
    final value = name?.toLowerCase() ?? '';
    bool has(List<String> words) => words.any(value.contains);

    if (has(['haram', 'هرم', 'الحرم'])) return PaymentAssets.alHaram;
    if (has(['sham', 'شام'])) return PaymentAssets.shamCash;
    return PaymentAssets.genericMethod;
  }
}
