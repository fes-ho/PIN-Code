import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/features/authentication/data/api_client.dart';
import 'package:frontend/src/features/tasks/data/task_repository.dart';
import 'package:frontend/src/features/tasks/data/task_repository_remote.dart';
import 'package:frontend/src/utils/result.dart';

import '../../../../../testing/fakes/services/fake_api_client.dart';
import '../../../../../testing/models/task.dart';

void main() {
  group('TaskRepositoryRemote tests', () {
    late FakeApiClient fakeApiClient;
    late TaskRepository repository;

    setUp(() {
      fakeApiClient = FakeApiClient();
      repository = TaskRepositoryRemote(apiClient: fakeApiClient);
    });

    test('should get tasks', () async {
      final result = await repository.getTasks();
      final tasks = result.asOk.value;
      expect(tasks, [kTask1]);
    });

    test('should create task', () async {
      final result = await repository.createTask(kTask1);
      expect(result, isA<Ok<void>>());
    });
  });
}