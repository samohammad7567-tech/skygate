class AuthUserModel {
  String? token;
  String? refreshToken;
  int? id;
  String? name;
  String? phone;

  String? email;
  String? avatar;
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
