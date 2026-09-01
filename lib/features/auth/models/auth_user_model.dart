/// Session returned by `auth/login` and `auth/register`.
///
/// The OpenAPI document declares both responses as an empty object, so the
/// shape is read defensively: every other endpoint wraps its payload in
/// `{data, message, status_code}`, and the token may arrive as `token` or
/// `access_token`, at the root or beside the profile. Each of those is
/// tolerated so a backend tweak cannot crash the login card.
class AuthUserModel {
  String? token;
  String? refreshToken;
  int? id;

  /// `full_name` in the register contract; `name` is accepted too.
  String? name;

  /// `mobile` in the register contract; `phone` is accepted too.
  String? phone;

  String? email;
  String? avatar;

  /// Pilgrim record created alongside the account. `app/pilgrim-documents`
  /// needs it as `pilgrim_id`.
  int? pilgrimId;

  AuthUserModel.fromJson(Map<String, dynamic> json) {
    final body = _map(json['data']) ?? json;
    final user = _map(body['user']) ?? body;
    final pilgrim = _map(body['pilgrim']) ?? _map(user['pilgrim']);

    token = _string(body['token']) ?? _string(body['access_token']);
    refreshToken = _string(body['refresh_token']);

    id = _int(user['id']);
    name = _string(user['full_name']) ?? _string(user['name']);
    phone = _string(user['mobile']) ?? _string(user['phone']);
    email = _string(user['email']);
    avatar = _string(user['photo_url']) ?? _string(user['avatar']);
    pilgrimId = _int(pilgrim?['id']) ?? _int(user['pilgrim_id']);
  }

  static Map<String, dynamic>? _map(dynamic value) =>
      value is Map<String, dynamic> ? value : null;

  static String? _string(dynamic value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }

  static int? _int(dynamic value) =>
      value is int ? value : int.tryParse('${value ?? ''}');
}
