import 'package:flutter/foundation.dart';
import 'package:frontend/src/features/tasks/domain/task/task.dart';
import 'package:frontend/src/features/time_tracking/data/time_tracking_repository.dart';
import 'package:frontend/src/utils/command.dart';
import 'package:frontend/src/utils/result.dart';
import 'package:logging/logging.dart';

class TimeTrackingViewModel extends ChangeNotifier {
  TimeTrackingViewModel({
    required TimeTrackingRepository repository,
    required Task task,
  }) : _repository = repository,
       _task = task {
    _repository.addListener(notifyListeners);
    _initCommands();
  }

  final TimeTrackingRepository _repository;
  final Task _task;
  final _log = Logger('TimeTrackingViewModel');

  late Command0 stopTracking;
  late Command0 pauseTracking;

  void _initCommands() {
    stopTracking = Command0(() async {
      final result = await _stopTracking();
      return result;
    });
    
    pauseTracking = Command0(() async {
      _repository.pauseTracking(_task.id);
      return Result.ok(null);
    });
  }

  void startTracking() {
    if (_task.estimated_duration != null) {
      _repository.startTimer(_task.id, _task.estimated_duration!);
    } else {
      _repository.startStopwatch(_task.id);
    }
    notifyListeners();
  }

  Future<Result<void>> _stopTracking() async {
    final result = await _repository.stopTracking(
      _task.id,
      estimatedDuration: _task.estimated_duration,
    );
    switch (result) {
      case Ok():
        _log.fine('Stopped tracking time');
      case Error():
        _log.warning('Failed to stop tracking time: ${result.error}');
    }
    return result;
  }

  Stream<int> get durationStream => _repository.getTrackedDurationStream(_task.id);
  bool get isTracking => _repository.isTracking(_task.id);
  bool get hasEstimatedDuration => _task.estimated_duration != null;
  bool get isPaused => _repository.isPaused(_task.id);

  String formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String secs = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$secs';
  }

  Duration? get trackedDuration {
    final seconds = _repository.getTrackedDuration(_task.id);
    return seconds != null ? Duration(seconds: seconds) : null;
  }

  @override
  void dispose() {
    _repository.removeListener(notifyListeners);
    super.dispose();
  }
} 