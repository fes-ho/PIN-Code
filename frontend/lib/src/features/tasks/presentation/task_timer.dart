import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/src/features/tasks/domain/task.dart';
import 'package:frontend/src/features/tasks/application/task_service.dart';
import 'package:frontend/src/features/tasks/presentation/task_list_state.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class TaskTimer extends StatefulWidget {
  final Task task;
  
  const TaskTimer({super.key, required this.task});

  @override
  State<TaskTimer> createState() => _TaskTimerState();
}

class _TaskTimerState extends State<TaskTimer> {
  Timer? _timer;
  late int _elapsedSeconds;
  bool _isRunning = false;
  bool _isPaused = false;
  final TaskService _taskService = GetIt.I<TaskService>();

  @override
  void initState() {
    super.initState();
    _elapsedSeconds = widget.task.duration ?? 0;
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = true;
    });
  }

  Future<void> _stopTimer() async {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
    });
    
    if (widget.task.id == null) {
      debugPrint('Cannot update duration: Task has no ID');
      return;
    }

    try {
      final updatedTask = await _taskService.updateTaskDuration(
        widget.task.id!, 
        _elapsedSeconds,
        estimatedDuration: widget.task.estimatedDuration,
      );
      
      if (context.mounted) {
        context.read<TaskListState>().updateTask(updatedTask);
      }
    } catch (e) {
      debugPrint('Failed to update task duration: $e');
    }
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    
    return '${hours.toString().padLeft(2, '0')}:'
           '${minutes.toString().padLeft(2, '0')}:'
           '${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool hasEstimatedDuration = widget.task.estimatedDuration != null;
    
    return Column(
      children: [
        Text(
          hasEstimatedDuration 
              ? 'Timer (${_formatTime(widget.task.estimatedDuration!)})'
              : 'Stopwatch',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _formatTime(_elapsedSeconds),
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: (!_isRunning || _isPaused) ? _startTimer : null,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _isRunning ? _pauseTimer : null,
              icon: const Icon(Icons.pause),
              label: const Text('Pause'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondary,
                foregroundColor: colorScheme.onSecondary,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: (_isRunning || _isPaused) ? _stopTimer : null,
              icon: const Icon(Icons.stop),
              label: const Text('Stop'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
