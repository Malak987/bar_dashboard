part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final bool soundEnabled;
  final bool pushNotificationsEnabled;
  final bool autoRefreshEnabled;
  final bool showClosedBranches;
  final bool analyticsRealtimeEnabled;
  final bool requireConfirmations;
  final bool compactMode;
  final String localeCode;

  const SettingsState({
    required this.soundEnabled,
    required this.pushNotificationsEnabled,
    required this.autoRefreshEnabled,
    required this.showClosedBranches,
    required this.analyticsRealtimeEnabled,
    required this.requireConfirmations,
    required this.compactMode,
    required this.localeCode,
  });

  const SettingsState.initial()
      : soundEnabled = true,
        pushNotificationsEnabled = true,
        autoRefreshEnabled = true,
        showClosedBranches = true,
        analyticsRealtimeEnabled = true,
        requireConfirmations = true,
        compactMode = false,
        localeCode = 'ar';

  bool get isArabic => localeCode == 'ar';

  SettingsState copyWith({
    bool? soundEnabled,
    bool? pushNotificationsEnabled,
    bool? autoRefreshEnabled,
    bool? showClosedBranches,
    bool? analyticsRealtimeEnabled,
    bool? requireConfirmations,
    bool? compactMode,
    String? localeCode,
  }) {
    return SettingsState(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      pushNotificationsEnabled:
          pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      autoRefreshEnabled: autoRefreshEnabled ?? this.autoRefreshEnabled,
      showClosedBranches: showClosedBranches ?? this.showClosedBranches,
      analyticsRealtimeEnabled:
          analyticsRealtimeEnabled ?? this.analyticsRealtimeEnabled,
      requireConfirmations: requireConfirmations ?? this.requireConfirmations,
      compactMode: compactMode ?? this.compactMode,
      localeCode: localeCode ?? this.localeCode,
    );
  }

  @override
  List<Object?> get props => [
        soundEnabled,
        pushNotificationsEnabled,
        autoRefreshEnabled,
        showClosedBranches,
        analyticsRealtimeEnabled,
        requireConfirmations,
        compactMode,
        localeCode,
      ];
}
