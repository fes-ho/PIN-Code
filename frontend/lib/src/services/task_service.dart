import 'dart:convert';
import 'package:frontend/src/config.dart';
import 'package:frontend/src/domain/task.dart';
import 'package:frontend/src/services/utils/headers/headers_factory.dart';
import 'package:http/http.dart';

Future<Task> createTask(Task task) async {
  final response = await post(
    Uri.parse('${Config.apiUrl}/tasks'),
    headers: HeadersFactory.getDefaultHeaders(),
    body: jsonEncode(task.toJson()),  
  );

  if (response.statusCode == 201) {
    return Task.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create task');
  }
}