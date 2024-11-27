import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:frontend/src/features/moods/data/mood_repositories/mood_repository.dart';
import 'package:frontend/src/features/moods/domain/mood.dart';
import 'package:frontend/src/features/moods/domain/type_of_mood.dart';
import 'package:frontend/src/features/tasks/data/task_repository.dart';
import 'package:frontend/src/features/tasks/domain/task/task.dart';
import 'package:frontend/src/utils/command.dart';
import 'package:frontend/src/utils/result.dart';
import 'package:logging/logging.dart';

class TodayViewModel extends ChangeNotifier
{
  TodayViewModel({
    required TaskRepository taskRepository,
    required MoodRepository moodRepository,
  }) : _moodRepository = moodRepository,
       _taskRepository = taskRepository {
    getTodayMood = Command0(_getTodayMood);
    manageMood = Command1(_manageMood);
    getTasks = Command0(_getTasks);
  }

  final TaskRepository _taskRepository;
  final MoodRepository _moodRepository;

  late Command0 getTasks;
  late Command0 getTodayMood;
  late Command1<void, TypeOfMood> manageMood;

  // All the user tasks
  final List<Task> _tasks = [];
  // Only the tasks that are visible
  final List<Task> _visibleTasks = [];
  Mood? _todayMood;
  DateTime _selectedDate = DateTime.now();

  final _log = Logger('TaskListViewModel');

  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);
  UnmodifiableListView<Task> get visibleTasks => UnmodifiableListView(_visibleTasks);
  DateTime get selectedDate => _selectedDate;
  TypeOfMood get typeOfMood => _todayMood?.typeOfMood ?? TypeOfMood.great;

  Future<Result<Mood>> _getTodayMood() async {
    final result = await _moodRepository.getMood();
    switch(result) {
      case Ok<Mood>():
        _todayMood = result.asOk.value;
        _log.fine('Today mood loaded');
      case Error<Mood>():
        _log.warning('Failed to load today mood: ${result.error}');
        return result;
    }
    return result;
  }

  Future<Result<void>> _manageMood(TypeOfMood typeOfMood) async{
    try {
      if (_todayMood == null) {
        final moodCreated = await _moodRepository.createMood(typeOfMood);
        if (moodCreated is Ok<Mood>) {
          _todayMood = moodCreated.asOk.value;
        }
        return Result.ok(null);
      }

      if (_todayMood!.typeOfMood == typeOfMood) {
        final moodDeleted = await _moodRepository.deleteMood(_todayMood!.id!);
        if (moodDeleted is Ok<void>) {
          _todayMood = null;
        }
        return Result.ok(null);
      }

      final moodUpdated = await _moodRepository.updateMood(_todayMood!.id!, typeOfMood);
      if (moodUpdated is Ok<Mood>) {
        _todayMood = moodUpdated.asOk.value;
      }
      return Result.ok(null);

    } finally{
      notifyListeners();
    }
  }
  
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
        refresh(result.asOk.value);
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

  void update(Task task) {
    final index = _tasks.indexWhere((element) => element.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      // Assume that the task is in the visible list
      _visibleTasks[_visibleTasks.indexWhere((element) => element.id == task.id)] = task;
    }
  }

  void remove(Task task) {
    _tasks.remove(task);
    // Assume that the task is in the visible list
    _visibleTasks.remove(task);
    notifyListeners();
  }
}