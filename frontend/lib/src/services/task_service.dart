import 'dart:convert';
import 'package:frontend/src/config.dart';
import 'package:frontend/src/domain/task.dart';
import 'package:frontend/src/services/utils/headers/headers_factory.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'member_service.dart';

class TaskService {
  late Client _client;
  late HeadersFactory _headersFactory;
  late String _memberId;

  TaskService() {
    _client = GetIt.I<Client>();
    _headersFactory = GetIt.I<HeadersFactory>();
    _memberId = GetIt.I<MemberService>().getCurrentUserId();
  }

  Future<Task> createTask(Task task) async {
    final response = await _client.post(
      Uri.parse('${Config.apiUrl}/tasks'),
      headers: await _headersFactory.getDefaultHeaders(),
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 201) {
      return Task.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create task');
    }
  }

  Future<List<Task>> getTasks() async {
    final response = await get(
      Uri.parse('${Config.apiUrl}/members/$_memberId/tasks'),
      headers: await _headersFactory.getDefaultHeaders()
    );

    if (response.statusCode == 200) {
      final List<dynamic> taskListJson = jsonDecode(response.body) as List<dynamic>;
      return taskListJson.map((json) => Task.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to retrieve tasks');
    }
  }
}