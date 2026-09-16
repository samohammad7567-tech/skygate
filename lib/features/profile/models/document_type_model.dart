import 'package:skygate/core/models/umrah_document_model.dart';
import 'package:skygate/core/utils/api_parse.dart';

class DocumentTypeModel {
  int? id;
  String? code;
  String? name;

  DocumentTypeModel.fromJson(Map<String, dynamic> json) {
    id = ApiParse.intOf(json['id']);
    code = ApiParse.stringOf(
      json['code'] ?? json['slug'] ?? json['key'] ?? json['type'],
    );
    name = ApiParse.stringOf(json['name'] ?? json['title'] ?? json['label']);
  }
  bool matches(UmrahDocumentModel document) {
    final slug = _normalize(document.id);
    return slug.isNotEmpty && (_normalize(code) == slug);
  }

  static String _normalize(String? value) =>
      (value ?? '').toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  static int? idOf(List<DocumentTypeModel> types, UmrahDocumentModel document) {
    for (final type in types) {
      if (type.matches(document)) return type.id;
    }
    return null;
  }
}
