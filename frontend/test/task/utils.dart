import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/domain/task.dart';

final Task task = Task(
  id: '1',
  name: 'Test Task',
  description: 'This is a test task',
  icon: 'icon',
  date: DateTime.parse('2024-11-16T12:00:00Z'),
  memberId: '123',
  isCompleted: false,
);

void compareTasks(Task firstTask, Task secondTask) {
  expect(firstTask.id, secondTask.id);
  expect(firstTask.name, secondTask.name);
  expect(firstTask.description, secondTask.description);
  expect(firstTask.icon, secondTask.icon);
  expect(firstTask.date, secondTask.date);
}
