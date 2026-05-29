import 'dart:html' as html;

class NotificationSoundService {
  NotificationSoundService._internal();

  static final NotificationSoundService instance =
      NotificationSoundService._internal();

  factory NotificationSoundService() => instance;

  final html.AudioElement _audio = html.AudioElement()
    ..src = 'assets/assets/sounds/notification_alert.wav'
    ..preload = 'auto';

  bool _isPrimed = false;

  Future<void> primeFromUserGesture() async {
    if (_isPrimed) return;
    try {
      _audio.volume = 0;
      await _audio.play();
      _audio.pause();
      _audio.currentTime = 0;
      _audio.volume = 1;
      _isPrimed = true;
    } catch (_) {
      // المتصفح قد يمنع التشغيل قبل أول gesture حقيقي
    }
  }

  Future<void> playStrongAlert() async {
    try {
      _audio.pause();
      _audio.currentTime = 0;
      _audio.volume = 1;
      await _audio.play();
    } catch (_) {
      // على الويب قد يحتاج المستخدم interaction أولاً
    }
  }

  Future<void> dispose() async {
    _audio.pause();
  }
}
