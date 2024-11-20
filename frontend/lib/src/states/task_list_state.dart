
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:frontend/src/domain/task.dart';

class TaskListState extends ChangeNotifier {
  final List<Task> _tasks = [];

  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);
}