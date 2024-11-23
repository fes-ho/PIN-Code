import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/features/tasks/domain/task.dart';
import 'package:frontend/src/features/authentication/application/member_service.dart';
import 'package:frontend/src/features/tasks/application/task_service.dart';
import 'package:frontend/src/utils/headers_factory.dart';
import 'package:frontend/src/features/tasks/presentation/task_list_state.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../log_in/log_in_unit_test.mocks.dart';
import 'task_unit_test.mocks.dart';
import 'utils.dart';

@GenerateMocks([HeadersFactory])
void main() {
  group('TaskService', () {
    tearDown(() {
      GetIt.I.reset();
    });

    setUp(() async {
      MockHeadersFactory mockHeadersFactory = MockHeadersFactory();
      MockMemberService mockMemberService = MockMemberService();

      when(mockHeadersFactory.getDefaultHeaders())
          .thenAnswer((_) async => <String, String>{});

      GetIt.I.registerSingleton<HeadersFactory>(mockHeadersFactory);
      GetIt.I.registerSingleton<MemberService>(mockMemberService);
      
      
      dotenv.testLoad(
        fileInput: '''
          API_URL=http://10.0.2.2:8000 
      ''',
      );
    });

    test('createTask should return a Task when the API call is successful',
        () async {
      // Arrange.
      final mockClient = MockClient((request) async {
        Map<String, dynamic> json = task.toJson();
        json.putIfAbsent('id', () => '1');

        return http.Response(jsonEncode(json), 201);
      });

      GetIt.I.registerSingleton<Client>(mockClient);

      final taskService = TaskService();

      // Act.
      final createdTask = await taskService.createTask(task);

      // Assert.
      compareTasks(createdTask, task);
    });

    test('createTask should throw an exception when the API call fails',
        () async {
      // Arrange.
      final mockClient = MockClient((request) async {
        return http.Response('Failed to create task', 400);
      });

      GetIt.I.registerSingleton<Client>(mockClient);

      final taskService = TaskService();

      // Act & Assert.
      expect(() async => await taskService.createTask(task), throwsException);
    });

    test('adding tasks increase task_list length', () {
      // Arrange.
      final taskList = TaskListState();
      final task = Task(
        id: '1',
        name: 'Task 1',
        description: 'Description 1',
        date: DateTime.now(),
        icon: '12345',
        isCompleted: false,
      );

      // Act.
      taskList.add(task);

      // Assert.
      expect(taskList.tasks.length, 1);
    });
  });
}
