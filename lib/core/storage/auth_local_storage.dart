import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalStorage {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';

  final SharedPreferences _prefs;

  AuthLocalStorage(this._prefs);

  Future<void> saveToken(String token) => _prefs.setString(_tokenKey, token);
  String? getToken() => _prefs.getString(_tokenKey);

  Future<void> saveUserId(String id) => _prefs.setString(_userIdKey, id);
  String? getUserId() => _prefs.getString(_userIdKey);

  Future<void> saveUserName(String name) =>
      _prefs.setString(_userNameKey, name);
  String? getUserName() => _prefs.getString(_userNameKey);

  Future<void> clear() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_userNameKey);
  }

  bool get isLoggedIn => getToken() != null && getToken()!.isNotEmpty;
}
