import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:frontend/src/config.dart';
import 'package:frontend/src/features/streaks/services/streak_service.dart';
import 'package:frontend/src/features/tasks/domain/task.dart';
import 'package:frontend/src/utils/headers_factory.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import '../../authentication/application/member_service.dart';

class TaskService {
  late Client _client;
  late HeadersFactory _headersFactory;
  late MemberService _memberService;
  late StreakService _streakService;

  TaskService() {
    _client = GetIt.I<Client>();
    _headersFactory = GetIt.I<HeadersFactory>();
    _memberService = GetIt.I<MemberService>();
    _streakService = GetIt.I<StreakService>();
  }

  Future<Task> createTask(Task task) async {
    final taskJson = task.toJson();
    debugPrint('Creating task with data: $taskJson');
    
    final response = await _client.post(
      Uri.parse('${Config.apiUrl}/tasks'),
      headers: await _headersFactory.getDefaultHeaders(),
      body: jsonEncode(taskJson),
    );

    if (response.statusCode == 201) {
      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint('Received response: $responseJson');
      return Task.fromJson(responseJson);
    } else {
      throw Exception('Failed to create task');
    }
  }

  Future<Task> updateTask(Task task) async {
    final response = await _client.put(
      Uri.parse('${Config.apiUrl}/tasks/${task.id}'),
      headers: await _headersFactory.getDefaultHeaders(),
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to update task');
    }
  }

  Future<void> completeTask(Task task) async {
    final response = await _client.patch(
      Uri.parse('${Config.apiUrl}/tasks/${task.id}/complete'),
      headers: await _headersFactory.getDefaultHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to complete task');
    }
    await _streakService.getStreaks();
  }

  Future<void> deleteTask(Task task) async {
    final response = await _client.delete(
      Uri.parse('${Config.apiUrl}/tasks/${task.id}'),
      headers: await _headersFactory.getDefaultHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete task');
    }
  }

  Future<List<Task>> getTasks() async {
    var memberId = await _memberService.getMember().then((member) => member.id);
    final response = await get(
      Uri.parse('${Config.apiUrl}/members/$memberId/tasks'),
      headers: await _headersFactory.getDefaultHeaders()
    );

    if (response.statusCode == 200) {
      final List<dynamic> taskListJson = jsonDecode(response.body) as List<dynamic>;
      return taskListJson.map((json) => Task.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to retrieve tasks');
    }
  }

  Future<Task> updateTaskDuration(String taskId, int duration, {int? estimatedDuration}) async {
    final response = await _client.patch(
      Uri.parse('${Config.apiUrl}/tasks/$taskId/duration'),
      headers: await _headersFactory.getDefaultHeaders(),
      body: jsonEncode({
        'duration': duration,
        'estimated_duration': estimatedDuration,
      }),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to update task duration');
    }
  }
}