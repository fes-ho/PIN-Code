import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerService {
  final Map<String, Timer> _timers = {};
  final Map<String, int> _durations = {};
  final Map<String, Function(int)> _callbacks = {};

  void startTimer(String taskId, int initialDuration, Function(int) onTick) {
    _durations[taskId] = initialDuration;
    _callbacks[taskId] = onTick;
    
    _timers[taskId] = Timer.periodic(const Duration(seconds: 1), (timer) {
      _durations[taskId] = (_durations[taskId] ?? 0) + 1;
      _callbacks[taskId]?.call(_durations[taskId]!);
    });
    debugPrint('Timer started for task: $taskId');
  }

  void pauseTimer(String taskId) {
    _timers[taskId]?.cancel();
    _timers.remove(taskId);
    _callbacks.remove(taskId);
    debugPrint('Timer paused for task: $taskId');
  }

  void stopTimer(String taskId) {
    _timers[taskId]?.cancel();
    _timers.remove(taskId);
    _callbacks.remove(taskId);
    _durations.remove(taskId);
    debugPrint('Timer stopped for task: $taskId');
  }

  int? getDuration(String taskId) {
    return _durations[taskId];
  }

  bool isRunning(String taskId) {
    return _timers.containsKey(taskId);
  }

  void dispose() {
    for (var timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    _durations.clear();
    _callbacks.clear();
  }
} 