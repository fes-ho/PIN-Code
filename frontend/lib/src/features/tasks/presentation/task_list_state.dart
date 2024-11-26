import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:frontend/src/features/tasks/domain/task.dart';
import 'package:frontend/src/features/tasks/application/task_service.dart';
import 'package:get_it/get_it.dart';

class TaskListState extends ChangeNotifier
{
  // All the user tasks
  final List<Task> _tasks = [];
  // Only the tasks that are visible
  final List<Task> _visibleTasks = [];
  DateTime _selectedDate = DateTime.now();
  late TaskService _taskService;

  TaskListState() {
    _taskService = GetIt.I<TaskService>();
    loadTasksFromApi();
  }

  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);
  UnmodifiableListView<Task> get visibleTasks => UnmodifiableListView(_visibleTasks);
  DateTime get selectedDate => _selectedDate;
  
  void changeDay(DateTime date) {
    _selectedDate = date;
    _visibleTasks.clear();
    _visibleTasks.addAll(UnmodifiableListView(_tasks.where((task) => task.date.day == date.day)));
    notifyListeners();
  }

  void add(Task task) {
    if (task.id != null) {
      _tasks.add(task);
      if (task.date.day == _selectedDate.day) {
        _visibleTasks.add(task);
      }
      notifyListeners();
    } else {
      debugPrint('Attempted to add task without UUID');
    }
  }

  Future<void> loadTasksFromApi() async {
    final tasks = await _taskService.getTasks();
    refresh(tasks);
  }

  void refresh(List<Task> tasks) {
    _tasks.clear();
    _tasks.addAll(tasks);
    _visibleTasks.clear();
    _visibleTasks.addAll(UnmodifiableListView(_tasks.where((task) => task.date.day == _selectedDate.day)));
    notifyListeners();
  }

  void remove(Task task) {
    _tasks.remove(task);
    // Assume that the task is in the visible list
    _visibleTasks.remove(task);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    if (updatedTask.id == null) {
      debugPrint('Cannot update task without UUID');
      return;
    }

    final taskIndex = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (taskIndex != -1) {
      _tasks[taskIndex] = updatedTask;
      
      // Update visible tasks if the task is visible
      final visibleIndex = _visibleTasks.indexWhere((t) => t.id == updatedTask.id);
      if (visibleIndex != -1) {
        _visibleTasks[visibleIndex] = updatedTask;
      }
      
      notifyListeners();
    } else {
      debugPrint('Task not found for update: ${updatedTask.id}');
    }
  }
}