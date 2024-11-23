import 'package:frontend/src/features/tasks/domain/task.dart';
import 'package:frontend/src/utils/result.dart';

abstract class TaskRepository
{
  // Creates a new [Task].
  Future<Result<void>> createTask(Task task);

  // Returns the list of [Tasks] for the current user.
  Future<Result<List<Task>>> getTasks();
}