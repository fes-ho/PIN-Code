import 'package:frontend/src/features/authentication/data/api_client.dart';
import 'package:frontend/src/features/tasks/data/task_repository.dart';
import 'package:frontend/src/features/tasks/domain/task.dart';
import 'package:frontend/src/utils/result.dart';

class TaskRepositoryRemote implements TaskRepository{
  TaskRepositoryRemote({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<Result<List<Task>>> getTasks() async {
    try {
      final result = await _apiClient.getTasks();
      if (result is Error<List<Task>>) {
        return Result.error(result.error);
      }
      final tasksApi = result.asOk.value;
      return Result.ok(tasksApi);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> createTask(Task task) async {
    try {
      final result = await _apiClient.createTask(task);
      if (result is Error<void>) {
        return Result.error(result.error);
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}