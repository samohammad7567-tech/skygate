import 'local_storage_service.dart';

/// The signed in user session: token, identity and biometric enrolment.
///
/// Holds the values in memory for synchronous reads and mirrors them to
/// [LocalStorageService] so they survive a restart. It stays free of any model
/// class, so mapping a login response onto [save] is the caller job:
///
/// ```dart
/// await SessionService.instance.save(
///   token: user.access_token,
///   userId: user.user_id,
///   fullName: user.full_name,
/// );
/// ```
class SessionService {
  SessionService._();

  static final SessionService instance = SessionService._();

  static const String _tokenKey = 'token';
  static const String _userIdKey = 'userId';
  static const String _mobileKey = 'mobile';
  static const String _fullNameKey = 'fullName';
  static const String _avatarKey = 'avatar';
  static const String _langKey = 'lang';
  static const String _statusKey = 'status';
  static const String _biometricsKeyKey = 'biometricsKey';
  static const String _biometricsEnabledKey = 'biometricsEnabled';

  static const List<String> _allKeys = [
    _tokenKey,
    _userIdKey,
    _mobileKey,
    _fullNameKey,
    _avatarKey,
    _langKey,
    _statusKey,
    _biometricsKeyKey,
    _biometricsEnabledKey,
  ];

  final LocalStorageService _storage = LocalStorageService.instance;

  String token = '';
  String userId = '';
  String mobile = '';
  String fullName = '';
  String avatar = '';
  String lang = '';
  String status = '';
  String biometricsKey = '';
  String biometricsEnabled = 'false';

  /// The FCM token. Deliberately not persisted: Firebase reissues it on every
  /// launch, see `PushNotificationService.refreshToken`.
  String fcmToken = '';

  bool get isLoggedIn => token.isNotEmpty;

  bool get isBiometricsEnabled => biometricsEnabled == 'true';

  /// Loads the persisted session into memory. Call once during startup, before
  /// deciding which screen to show.
  Future<void> load() async {
    token = await _storage.getString(_tokenKey);
    userId = await _storage.getString(_userIdKey);
    mobile = await _storage.getString(_mobileKey);
    fullName = await _storage.getString(_fullNameKey);
    avatar = await _storage.getString(_avatarKey);
    lang = await _storage.getString(_langKey);
    status = await _storage.getString(_statusKey);
    biometricsKey = await _storage.getString(_biometricsKeyKey);
    biometricsEnabled =
        await _storage.getString(_biometricsEnabledKey, fallback: 'false');
  }

  /// Stores the session. Omitted fields keep their current value, so a partial
  /// update (a new avatar, a refreshed token) does not wipe the rest.
  Future<void> save({
    String? token,
    String? userId,
    String? mobile,
    String? fullName,
    String? avatar,
    String? lang,
    String? status,
    String? biometricsKey,
    String? biometricsEnabled,
  }) async {
    this.token = token ?? this.token;
    this.userId = userId ?? this.userId;
    this.mobile = mobile ?? this.mobile;
    this.fullName = fullName ?? this.fullName;
    this.avatar = avatar ?? this.avatar;
    this.lang = lang ?? this.lang;
    this.status = status ?? this.status;
    this.biometricsKey = biometricsKey ?? this.biometricsKey;
    this.biometricsEnabled = biometricsEnabled ?? this.biometricsEnabled;

    await _storage.setString(_tokenKey, this.token);
    await _storage.setString(_userIdKey, this.userId);
    await _storage.setString(_mobileKey, this.mobile);
    await _storage.setString(_fullNameKey, this.fullName);
    await _storage.setString(_avatarKey, this.avatar);
    await _storage.setString(_langKey, this.lang);
    await _storage.setString(_statusKey, this.status);
    await _storage.setString(_biometricsKeyKey, this.biometricsKey);
    await _storage.setString(_biometricsEnabledKey, this.biometricsEnabled);
  }

  /// Clears the session from memory and from disk. Used on logout.
  Future<void> clear() async {
    token = '';
    userId = '';
    mobile = '';
    fullName = '';
    avatar = '';
    lang = '';
    status = '';
    biometricsKey = '';
    biometricsEnabled = 'false';
    fcmToken = '';

    await _storage.removeAll(_allKeys);
  }

  /// Authorization header for the current session.
  Map<String, String> get authHeader =>
      token.isEmpty ? const {} : {'Authorization': 'Bearer $token'};
}
