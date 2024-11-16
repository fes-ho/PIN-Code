import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/domain/task.dart';
import 'package:frontend/src/services/task_service.dart';
import 'package:frontend/src/services/utils/headers/headers_factory.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'task_unit_test.mocks.dart';

@GenerateMocks([HeadersFactory])
void main() {
  final Task task = Task(
    id: '1',
    name: 'Test Task',
    description: 'This is a test task',
    icon: 'icon',
    date: DateTime.parse('2024-11-16T12:00:00Z'),
    memberId: '123',
  );

  group('TaskService', () {
    test('createTask should return a Task when the API call is successful',
        () async {
      // Arrange.
      await dotenv.load(fileName: ".env");

      MockHeadersFactory mockHeadersFactory = MockHeadersFactory();

      when(mockHeadersFactory.getDefaultHeaders())
          .thenReturn(<String, String>{});

      final mockClient = MockClient((request) async {
        Map<String, dynamic> json = task.toJson();
        json.putIfAbsent('id', () => '1');

        return http.Response(jsonEncode(json), 201);
      });

      final taskService =
          TaskService(client: mockClient, headersFactory: mockHeadersFactory);

      // Act.
      final createdTask = await taskService.createTask(task);

      // Assert.
      expect(createdTask.id, task.id);
      expect(createdTask.name, task.name);
      expect(createdTask.description, task.description);
      expect(createdTask.icon, task.icon);
      expect(createdTask.date, task.date);
    });

    test('createTask should throw an exception when the API call fails',
        () async {
      // Arrange.
      await dotenv.load(fileName: ".env");

      MockHeadersFactory mockHeadersFactory = MockHeadersFactory();

      when(mockHeadersFactory.getDefaultHeaders())
          .thenReturn(<String, String>{});

      final mockClient = MockClient((request) async {
        return http.Response('Failed to create task', 400);
      });

      final taskService =
          TaskService(client: mockClient, headersFactory: mockHeadersFactory);

      // Act & Assert.
      expect(() async => await taskService.createTask(task), throwsException);
    });
  });
}
