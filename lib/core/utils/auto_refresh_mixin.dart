import 'dart:async';
import 'package:flutter/material.dart';

/// Mixin لأي StatefulWidget بحيث يقدر يعمل polling تلقائي
mixin AutoRefreshMixin<T extends StatefulWidget>
on State<T>, WidgetsBindingObserver {
  Timer? _refreshTimer;
  bool _isAppActive = true;

  /// الفاصل الزمني بين كل refresh (افتراضي 30 ثانية)
  Duration get refreshInterval => const Duration(seconds: 30);

  /// الدالة اللي بتنفذ كل interval
  Future<void> onRefresh();

  /// هل نعمل refresh أول مرة عند فتح الصفحة؟
  bool get refreshOnInit => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (refreshOnInit) {
        onRefresh();
      }
      _startTimer();
    });
  }

  @override
  void dispose() {
    _stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _isAppActive = true;
      onRefresh();
      _startTimer();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _isAppActive = false;
      _stopTimer();
    }
  }

  void _startTimer() {
    _stopTimer();
    _refreshTimer = Timer.periodic(refreshInterval, (_) {
      if (_isAppActive && mounted) {
        onRefresh();
      }
    });
  }

  void _stopTimer() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<void> manualRefresh() async {
    await onRefresh();
  }

  void pauseRefresh() => _stopTimer();

  void resumeRefresh() {
    if (_refreshTimer == null) _startTimer();
  }
}