import 'dart:async';
import 'package:flutter/foundation.dart';

class HabitTimerService {
  final Map<String, Timer> _timers = {};
  final Map<String, int> _durations = {};
  final Map<String, Function(int)> _callbacks = {};
  final Map<String, bool> _isPaused = {};

  void startTimer(String habitId, int initialDuration, Function(int) onTick) {
    if (_timers.containsKey(habitId)) {
      _callbacks[habitId] = onTick;
      onTick(_durations[habitId]!);
      return;
    }

    _durations[habitId] = initialDuration;
    _callbacks[habitId] = onTick;
    _isPaused[habitId] = false;
    
    _timers[habitId] = Timer.periodic(const Duration(seconds: 1), (timer) {
      _durations[habitId] = (_durations[habitId] ?? 0) + 1;
      _callbacks[habitId]?.call(_durations[habitId]!);
    });
    debugPrint('Timer started for habit: $habitId');
  }

  void pauseTimer(String habitId) {
    _timers[habitId]?.cancel();
    _timers.remove(habitId);
    _isPaused[habitId] = true;
    // Keep duration and callback for resuming
    debugPrint('Timer paused for habit: $habitId. Duration: ${_durations[habitId]}');
  }

  void stopTimer(String habitId) {
    _timers[habitId]?.cancel();
    _timers.remove(habitId);
    _callbacks.remove(habitId);
    _durations.remove(habitId);
    _isPaused[habitId] = false;
    debugPrint('Timer stopped for habit: $habitId');
  }

  int? getDuration(String habitId) {
    return _durations[habitId];
  }

  bool isRunning(String habitId) {
    return _timers.containsKey(habitId);
  }

  bool isPaused(String habitId) {
    return _isPaused[habitId] ?? false;
  }

  void dispose() {
    for (var timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    _durations.clear();
    _callbacks.clear();
    _isPaused.clear();
  }

  void removeCallback(String habitId) {
    _callbacks.remove(habitId);
    debugPrint('Callback removed for habit: $habitId');
  }
} 