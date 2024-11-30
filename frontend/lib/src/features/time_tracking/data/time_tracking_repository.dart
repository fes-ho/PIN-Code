import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:frontend/src/utils/result.dart';
import 'package:frontend/src/features/time_tracking/data/time_tracking_service.dart';

class TimeTrackingRepository extends ChangeNotifier {
  TimeTrackingRepository({
    required TimeTrackingService service,
  }) : _service = service;

  final TimeTrackingService _service;
  final Map<String, Timer> _activeTimers = {};
  final Map<String, Stopwatch> _activeStopwatches = {};
  final Map<String, int> _trackedDurations = {};
  final Map<String, bool> _isPaused = {};

  Stream<int> getTrackedDurationStream(String taskId) async* {
    while (_activeTimers.containsKey(taskId) || _activeStopwatches.containsKey(taskId)) {
      yield getTrackedDuration(taskId) ?? 0;
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  void startTimer(String taskId, int estimatedDuration) {
    if (_activeTimers.containsKey(taskId)) return;
    
    if (!_trackedDurations.containsKey(taskId)) {
      _trackedDurations[taskId] = 0;
    }
    
    final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _trackedDurations[taskId] = (_trackedDurations[taskId] ?? 0) + 1;
      notifyListeners();
    });
    _activeTimers[taskId] = timer;
    _isPaused[taskId] = false;
  }

  void startStopwatch(String taskId) {
    if (_activeStopwatches.containsKey(taskId)) return;
    
    final stopwatch = Stopwatch()..start();
    
    if (_trackedDurations.containsKey(taskId)) {
      _trackedDurations[taskId] = _trackedDurations[taskId]! + stopwatch.elapsed.inSeconds;
    } else {
      _trackedDurations[taskId] = 0;
    }
    
    _activeStopwatches[taskId] = stopwatch;
    _isPaused[taskId] = false;
    notifyListeners();
  }

  Future<Result<void>> stopTracking(String taskId, {int? estimatedDuration}) async {
    int? finalDuration;
    
    if (_activeTimers.containsKey(taskId)) {
      _activeTimers[taskId]?.cancel();
      _activeTimers.remove(taskId);
      finalDuration = _trackedDurations[taskId];
    }
    
    if (_activeStopwatches.containsKey(taskId)) {
      final stopwatch = _activeStopwatches[taskId]!;
      stopwatch.stop();
      finalDuration = (_trackedDurations[taskId] ?? 0) + stopwatch.elapsed.inSeconds;
      _activeStopwatches.remove(taskId);
      _isPaused[taskId] = true;
    }

    if (finalDuration != null) {
      final result = await _service.updateTaskDuration(
        taskId, 
        finalDuration,
        estimatedDuration: estimatedDuration,
      );
      
      if (result is Ok) {
        _trackedDurations[taskId] = finalDuration;
        notifyListeners();
      }
      return result;
    }
    return Result.ok(null);
  }

  int? getTrackedDuration(String taskId) {
    if (_activeStopwatches.containsKey(taskId)) {
      return (_trackedDurations[taskId] ?? 0) + _activeStopwatches[taskId]!.elapsed.inSeconds;
    }
    return _trackedDurations[taskId];
  }

  bool isTracking(String taskId) {
    return _activeTimers.containsKey(taskId) || _activeStopwatches.containsKey(taskId);
  }

  void pauseTracking(String taskId) {
    if (_activeTimers.containsKey(taskId)) {
      _activeTimers[taskId]?.cancel();
      _activeTimers.remove(taskId);
      _isPaused[taskId] = true;
      notifyListeners();
    }
    
    if (_activeStopwatches.containsKey(taskId)) {
      final stopwatch = _activeStopwatches[taskId]!;
      stopwatch.stop();
      _trackedDurations[taskId] = (_trackedDurations[taskId] ?? 0) + stopwatch.elapsed.inSeconds;
      _activeStopwatches.remove(taskId);
      _isPaused[taskId] = true;
      notifyListeners();
    }
  }

  bool isPaused(String taskId) {
    return _isPaused[taskId] ?? false;
  }

  void startTracking(String taskId, int? estimatedDuration) {
    _isPaused[taskId] = false;
    if (estimatedDuration != null) {
      startTimer(taskId, estimatedDuration);
    } else {
      startStopwatch(taskId);
    }
  }

  @override
  void dispose() {
    for (var timer in _activeTimers.values) {
      timer.cancel();
    }
    _activeTimers.clear();
    _activeStopwatches.clear();
    _trackedDurations.clear();
    _isPaused.clear();
    super.dispose();
  }
} 