import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/app_settings_local_storage.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final AppSettingsLocalStorage _storage;

  SettingsCubit(this._storage) : super(const SettingsState.initial());

  Future<void> loadSettings() async {
    emit(
      SettingsState(
        soundEnabled: _storage.soundEnabled,
        pushNotificationsEnabled: _storage.pushNotificationsEnabled,
        autoRefreshEnabled: _storage.autoRefreshEnabled,
        showClosedBranches: _storage.showClosedBranches,
        analyticsRealtimeEnabled: _storage.analyticsRealtimeEnabled,
        requireConfirmations: _storage.requireConfirmations,
        compactMode: _storage.compactMode,
        localeCode: _storage.localeCode,
      ),
    );
  }

  Future<void> setSoundEnabled(bool value) async {
    await _storage.setSoundEnabled(value);
    emit(state.copyWith(soundEnabled: value));
  }

  Future<void> setPushNotificationsEnabled(bool value) async {
    await _storage.setPushNotificationsEnabled(value);
    emit(state.copyWith(pushNotificationsEnabled: value));
  }

  Future<void> setAutoRefreshEnabled(bool value) async {
    await _storage.setAutoRefreshEnabled(value);
    emit(state.copyWith(autoRefreshEnabled: value));
  }

  Future<void> setShowClosedBranches(bool value) async {
    await _storage.setShowClosedBranches(value);
    emit(state.copyWith(showClosedBranches: value));
  }

  Future<void> setAnalyticsRealtimeEnabled(bool value) async {
    await _storage.setAnalyticsRealtimeEnabled(value);
    emit(state.copyWith(analyticsRealtimeEnabled: value));
  }

  Future<void> setRequireConfirmations(bool value) async {
    await _storage.setRequireConfirmations(value);
    emit(state.copyWith(requireConfirmations: value));
  }

  Future<void> setCompactMode(bool value) async {
    await _storage.setCompactMode(value);
    emit(state.copyWith(compactMode: value));
  }

  Future<void> setLocaleCode(String value) async {
    await _storage.setLocaleCode(value);
    emit(state.copyWith(localeCode: value));
  }

  Future<void> toggleLocale() async {
    await setLocaleCode(state.localeCode == 'ar' ? 'en' : 'ar');
  }
}
