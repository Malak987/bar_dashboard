import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class NotificationSoundService {
  NotificationSoundService._internal();

  static final NotificationSoundService instance =
      NotificationSoundService._internal();

  factory NotificationSoundService() => instance;

  final AudioPlayer _player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);

  Future<void> primeFromUserGesture() async {}

  Future<void> playStrongAlert() async {
    try {
      await _player.stop();
      await _player.play(
        AssetSource('sounds/notification_alert.wav'),
        volume: 1.0,
      );
    } catch (_) {
      await SystemSound.play(SystemSoundType.alert);
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
