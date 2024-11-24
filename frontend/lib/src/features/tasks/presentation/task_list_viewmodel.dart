import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:frontend/src/features/tasks/data/task_repository.dart';
import 'package:frontend/src/features/tasks/domain/task.dart';
import 'package:frontend/src/utils/command.dart';
import 'package:frontend/src/utils/result.dart';
import 'package:logging/logging.dart';

class TaskListViewModel extends ChangeNotifier
{
  TaskListViewModel({
    required TaskRepository taskRepository,
  }) : _taskRepository = taskRepository {
    getTasks = Command0(_getTasks);
  }

  // All the user tasks
  final List<Task> _tasks = [];
  // Only the tasks that are visible
  final List<Task> _visibleTasks = [];
  DateTime _selectedDate = DateTime.now();
  final _log = Logger('TaskListViewModel');

  final TaskRepository _taskRepository;

  late Command0 getTasks;

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
    _tasks.add(task);
    if (task.date.day == _selectedDate.day) {
      _visibleTasks.add(task);
    }
    notifyListeners();
  }

  Future<Result<List<Task>>> _getTasks() async {
    final result = await _taskRepository.getTasks();
    switch(result) {
      case Ok<List<Task>>():
        refresh(result.value);
        _log.fine('Tasks loaded');
      case Error<List<Task>>():
        _log.warning('Failed to load tasks: ${result.error}');
        return result;
    }
    return result;
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
}