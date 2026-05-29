import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsLocalStorage {
  static const _soundEnabledKey = 'settings_sound_enabled';
  static const _pushNotificationsKey = 'settings_push_notifications';
  static const _autoRefreshKey = 'settings_auto_refresh';
  static const _showClosedBranchesKey = 'settings_show_closed_branches';
  static const _analyticsRealtimeKey = 'settings_analytics_realtime';
  static const _requireConfirmationsKey = 'settings_require_confirmations';
  static const _compactModeKey = 'settings_compact_mode';
  static const _localeCodeKey = 'settings_locale_code';

  final SharedPreferences _prefs;

  AppSettingsLocalStorage(this._prefs);

  bool get soundEnabled => _prefs.getBool(_soundEnabledKey) ?? true;
  Future<void> setSoundEnabled(bool value) =>
      _prefs.setBool(_soundEnabledKey, value);

  bool get pushNotificationsEnabled =>
      _prefs.getBool(_pushNotificationsKey) ?? true;
  Future<void> setPushNotificationsEnabled(bool value) =>
      _prefs.setBool(_pushNotificationsKey, value);

  bool get autoRefreshEnabled => _prefs.getBool(_autoRefreshKey) ?? true;
  Future<void> setAutoRefreshEnabled(bool value) =>
      _prefs.setBool(_autoRefreshKey, value);

  bool get showClosedBranches =>
      _prefs.getBool(_showClosedBranchesKey) ?? true;
  Future<void> setShowClosedBranches(bool value) =>
      _prefs.setBool(_showClosedBranchesKey, value);

  bool get analyticsRealtimeEnabled =>
      _prefs.getBool(_analyticsRealtimeKey) ?? true;
  Future<void> setAnalyticsRealtimeEnabled(bool value) =>
      _prefs.setBool(_analyticsRealtimeKey, value);

  bool get requireConfirmations =>
      _prefs.getBool(_requireConfirmationsKey) ?? true;
  Future<void> setRequireConfirmations(bool value) =>
      _prefs.setBool(_requireConfirmationsKey, value);

  bool get compactMode => _prefs.getBool(_compactModeKey) ?? false;
  Future<void> setCompactMode(bool value) =>
      _prefs.setBool(_compactModeKey, value);

  String get localeCode => _prefs.getString(_localeCodeKey) ?? 'ar';
  Future<void> setLocaleCode(String value) =>
      _prefs.setString(_localeCodeKey, value);
}
