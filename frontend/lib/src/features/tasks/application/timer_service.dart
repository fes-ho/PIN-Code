import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerService {
  final Map<String, Timer> _timers = {};
  final Map<String, int> _durations = {};
  final Map<String, Function(int)> _callbacks = {};
  final Map<String, bool> _isPaused = {};

  void startTimer(String taskId, int initialDuration, Function(int) onTick) {
    if (_timers.containsKey(taskId)) {
      _callbacks[taskId] = onTick;
      onTick(_durations[taskId]!);
      return;
    }

    _durations[taskId] = initialDuration;
    _callbacks[taskId] = onTick;
    _isPaused[taskId] = false;
    
    _timers[taskId] = Timer.periodic(const Duration(seconds: 1), (timer) {
      _durations[taskId] = (_durations[taskId] ?? 0) + 1;
      _callbacks[taskId]?.call(_durations[taskId]!);
    });
    debugPrint('Timer started for task: $taskId');
  }

  void pauseTimer(String taskId) {
    _timers[taskId]?.cancel();
    _timers.remove(taskId);
    _isPaused[taskId] = true;
    // Keep duration and callback for resuming
    debugPrint('Timer paused for task: $taskId. Duration: ${_durations[taskId]}');
  }

  void stopTimer(String taskId) {
    _timers[taskId]?.cancel();
    _timers.remove(taskId);
    _callbacks.remove(taskId);
    _durations.remove(taskId);
    _isPaused[taskId] = false;
    debugPrint('Timer stopped for task: $taskId');
  }

  int? getDuration(String taskId) {
    return _durations[taskId];
  }

  bool isRunning(String taskId) {
    return _timers.containsKey(taskId);
  }

  bool isPaused(String taskId) {
    return _isPaused[taskId] ?? false;
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

  void removeCallback(String taskId) {
    _callbacks.remove(taskId);
    debugPrint('Callback removed for task: $taskId');
  }
} 