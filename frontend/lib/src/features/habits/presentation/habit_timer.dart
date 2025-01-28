import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/src/features/habits/application/habit_timer_service.dart';
import 'package:frontend/src/features/habits/domain/habit.dart';
import 'package:frontend/src/features/habits/application/habit_service.dart';
import 'package:frontend/src/features/habits/presentation/habit_list_state.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class HabitTimer extends StatefulWidget {
  final Habit habit;
  
  const HabitTimer({super.key, required this.habit});

  @override
  State<HabitTimer> createState() => _TaskTimerState();
}

class _TaskTimerState extends State<HabitTimer> {
  late int _elapsedSeconds;
  late int _remainingSeconds;
  bool _isRunning = false;
  bool _isPaused = false;
  bool _isCountingUp = false;
  final HabitService _habitService = GetIt.I<HabitService>();
  final HabitTimerService _habitTimerService = GetIt.I<HabitTimerService>();

  @override
  void initState() {
    super.initState();
    
    if (widget.habit.id != null) {
      // Get duration from timer service or task
      _elapsedSeconds = _habitTimerService.getDuration(widget.habit.id!) ?? widget.habit.duration ?? 0;
      
      // Restore timer state
      _isRunning = _habitTimerService.isRunning(widget.habit.id!);
      _isPaused = _habitTimerService.isPaused(widget.habit.id!);
      
      // If timer is running or paused, register callback
      if (_isRunning || _isPaused) {
        _habitTimerService.startTimer(widget.habit.id!, _elapsedSeconds, (duration) {
          if (mounted) {
            setState(() {
              _elapsedSeconds = duration;
              if (widget.habit.estimatedDuration != null) {
                _remainingSeconds = widget.habit.estimatedDuration! - _elapsedSeconds;
                _isCountingUp = _remainingSeconds <= 0;
              }
            });
          }
        });
      }
    } else {
      _elapsedSeconds = widget.habit.duration ?? 0;
    }

    // Initialize countdown state
    if (widget.habit.estimatedDuration != null) {
      _remainingSeconds = widget.habit.estimatedDuration! - _elapsedSeconds;
      _isCountingUp = _remainingSeconds <= 0;
    } else {
      _remainingSeconds = 0;
      _isCountingUp = true;
    }
  }

  void _startTimer() {
    if (widget.habit.id == null) return;

    setState(() {
      _isRunning = true;
      _isPaused = false;
    });
    
    _habitTimerService.startTimer(widget.habit.id!, _elapsedSeconds, (duration) {
      setState(() {
        _elapsedSeconds = duration;
        if (widget.habit.estimatedDuration != null) {
          _remainingSeconds = widget.habit.estimatedDuration! - _elapsedSeconds;
          _isCountingUp = _remainingSeconds <= 0;
        }
      });
    });
  }

  void _pauseTimer() {
    if (widget.habit.id == null) return;
    
    _habitTimerService.pauseTimer(widget.habit.id!);
    setState(() {
      _isRunning = false;
      _isPaused = true;
    });
  }

  Future<void> _stopTimer() async {
    if (widget.habit.id == null) return;

    _habitTimerService.stopTimer(widget.habit.id!);
    setState(() {
      _isRunning = false;
      _isPaused = false;
    });

    try {
      final updatedTask = await _habitService.updateHabitDuration(
        widget.habit.id!, 
        _elapsedSeconds,
        estimatedDuration: widget.habit.estimatedDuration,
      );
      
      if (context.mounted) {
        context.read<HabitListState>().updateHabit(updatedTask);
      }
    } catch (e) {
      debugPrint('Failed to update task duration: $e');
    }
  }

  String _formatTime(int seconds) {
    if (seconds < 0) seconds = 0;
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
    final bool hasEstimatedDuration = widget.habit.estimatedDuration != null;
    
    return Column(
      children: [
        Text(
          hasEstimatedDuration 
              ? 'Timer (${_formatTime(widget.habit.estimatedDuration!)})'
              : 'Stopwatch',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          hasEstimatedDuration && !_isCountingUp
              ? _formatTime(_remainingSeconds)
              : _formatTime(_elapsedSeconds),
          style: TextStyle(
            color: colorScheme.primary,
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

  @override
  void dispose() {
    // Don't stop the timer service when disposing, just remove the callback
    if (widget.habit.id != null && _isRunning) {
      _habitTimerService.removeCallback(widget.habit.id!);
    }
    super.dispose();
  }
}