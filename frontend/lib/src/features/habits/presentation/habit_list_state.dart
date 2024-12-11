import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:frontend/src/features/streaks/services/streak_service.dart';
import 'package:frontend/src/features/habits/domain/habit.dart';
import 'package:frontend/src/features/habits/application/habit_service.dart';
import 'package:get_it/get_it.dart';

class HabitListState extends ChangeNotifier
{
  // All the user habits
  final List<Habit> _habits = [];
  // Only the habits that are visible
  final List<Habit> _visibleHabits = [];
  DateTime _selectedDate = DateTime.now();
  late HabitService _habitService;

  HabitListState() {
    _habitService = GetIt.I<HabitService>();
    loadHabitsFromApi();
  }

  UnmodifiableListView<Habit> get habits => UnmodifiableListView(_habits);
  UnmodifiableListView<Habit> get visibleHabits => UnmodifiableListView(_visibleHabits);
  DateTime get selectedDate => _selectedDate;
  
  void changeDay(DateTime date) {
    _selectedDate = date;
    _visibleHabits.clear();
    _visibleHabits.addAll(UnmodifiableListView(_habits));
    notifyListeners();
  }

  void completeHabit(Habit habit) {
    try {
      _habitService.completeHabit(habit);
    } catch (e) {
      debugPrint('Failed to complete habit: $e');
      return;
    }
    habit.isCompleted = !habit.isCompleted;
    notifyListeners();
  }

  void add(Habit habit) {
    if (habit.id != null) {
      final habitIndex = _habits.indexWhere((t) => t.id == habit.id);
      if (habitIndex != -1) {
        _habits[habitIndex] = habit;
        final visibleIndex = _visibleHabits.indexWhere((t) => t.id == habit.id);
        if (visibleIndex != -1) {
          _visibleHabits[visibleIndex] = habit;
        }
      } else {
        _habits.add(habit);
        _visibleHabits.add(habit);
      }
      notifyListeners();
    } else {
      debugPrint('Attempted to add habit without UUID');
    }
  }

  Future<void> loadHabitsFromApi() async {
    final habits = await _habitService.getHabits();
    refresh(habits);
  }

  void refresh(List<Habit> habits) {
    _habits.clear();
    _habits.addAll(habits);
    _visibleHabits.clear();
    _visibleHabits.addAll(UnmodifiableListView(_habits));
    notifyListeners();
  }

  void remove(Habit habit) {
    _habits.remove(habit);
    // Assume that the task is in the visible list
    _visibleHabits.remove(habit);
    notifyListeners();
  }
  
  void removeHabit(Habit habit) {
    try {
      _habitService.deleteHabit(habit);
    } catch (e) {
      debugPrint('Failed to delete habit: $e');
      return;
    }
    remove(habit);
  }

  void updateHabit(Habit updatedHabit) {
    if (updatedHabit.id == null) {
      debugPrint('Cannot update habit without UUID');
      return;
    }

    final habitIndex = _habits.indexWhere((t) => t.id == updatedHabit.id);
    if (habitIndex != -1) {
      _habits[habitIndex] = updatedHabit;
      
      // Update visible habits if the habit is visible
      final visibleIndex = _visibleHabits.indexWhere((t) => t.id == updatedHabit.id);
      if (visibleIndex != -1) {
        _visibleHabits[visibleIndex] = updatedHabit;
      }
      
      notifyListeners();
    } else {
      debugPrint('Task not found for update: ${updatedHabit.id}');
    }
  }
}