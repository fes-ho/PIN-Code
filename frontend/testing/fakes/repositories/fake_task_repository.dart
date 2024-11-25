import 'package:frontend/src/features/tasks/data/task_repository.dart';
import 'package:frontend/src/features/tasks/domain/task/task.dart';
import 'package:frontend/src/utils/result.dart';

class FakeTaskRepository extends TaskRepository{
  List<Task> tasks = List.empty(growable: true);
  int sequentialId = 0;

  @override
  Future<Result<void>> createTask(Task task) async{
    final taskWithId = task.copyWith(id: (sequentialId++).toString());
    tasks.add(taskWithId);
    return Result.ok(null);
  }

  @override
  Future<Result<List<Task>>> getTasks() async {
    return Result.ok(tasks);
  }
}