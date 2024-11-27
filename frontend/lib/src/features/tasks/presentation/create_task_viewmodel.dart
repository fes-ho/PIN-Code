import 'package:frontend/src/features/tasks/data/task_repository.dart';
import 'package:frontend/src/features/tasks/domain/task/task.dart';
import 'package:frontend/src/features/today/presentation/today_viewmodel.dart';
import 'package:frontend/src/utils/command.dart';
import 'package:frontend/src/utils/result.dart';
import 'package:logging/logging.dart';

class CreateTaskViewModel {
  CreateTaskViewModel({
    required TaskRepository taskRepository,
    required TodayViewModel todayViewModel,
  }) : _todayViewModel = todayViewModel, 
      _taskRepository = taskRepository {
    createTask = Command1(_createTask);
  }

  final TodayViewModel _todayViewModel;
  final TaskRepository _taskRepository;
  final _log = Logger('CreateTaskViewmodel');

  late Command1<void, Task> createTask;

  Future<Result<void>> _createTask(Task task) async {
    final resultCreate = await _taskRepository.createTask(task);
    switch (resultCreate) {
      case Ok<void>():
        _log.fine('Task created');
        _todayViewModel.add(task);
      case Error<void>():
        _log.warning('Failed to create task: ${resultCreate.error}');
        return resultCreate;
    }
    return resultCreate;
  }
}