import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/src/features/authentication/domain/member_api/member_api_model.dart';
import 'package:frontend/src/features/tasks/domain/task/task.dart';
import 'package:frontend/src/utils/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Adds the `Authentication` header to a header configuration.
typedef AuthHeaderProvider = String? Function();

class ApiClient {
  ApiClient({
    String? host,
    int? port,
    HttpClient Function()? clientFactory,
    SupabaseClient Function()? supabaseClient,
  })  : _host = host ?? dotenv.get("API_HOST"),
        _port = port ?? int.parse(dotenv.get("API_PORT")),
        _clientFactory = clientFactory ?? (() => HttpClient()),
        _supabaseClient = supabaseClient ?? (() => Supabase.instance.client); 

  final SupabaseClient Function() _supabaseClient;
  final String _host;
  final int _port;
  final HttpClient Function() _clientFactory;

  AuthHeaderProvider? _authHeaderProvider;
  String? _memberId;

  set authHeaderProvider(AuthHeaderProvider authHeaderProvider) {
    _authHeaderProvider = authHeaderProvider;
  }

  Future<void> _authHeader(HttpHeaders headers) async {
    final header = _authHeaderProvider?.call();
    if (header != null) {
      headers.add(HttpHeaders.authorizationHeader, header);
    }
  }

  Future<String> _getMemberId() async {
    if (_memberId != null) {
      return _memberId!;
    }
    final client = _supabaseClient();
    final id = client.auth.currentUser?.id;
    if (id == null) {
      throw Exception('User is not authenticated');
    }
    return id;
  }

  Future<Result<MemberApiModel>> getMember() async {
    final client = _clientFactory();
    try {
      String memberId = await _getMemberId();
      final request = await client.get(_host, _port, '/members/$memberId');
      await _authHeader(request.headers);
      final response = await request.close();
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final user = MemberApiModel.fromJson(jsonDecode(stringData));
        return Result.ok(user);
      } else {
        return Result.error(const HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<List<Task>>> getTasks() async {
    final client = _clientFactory();
    try {
      String memberId = await _getMemberId();
      final request = await client.get(_host, _port, '/members/$memberId/tasks');
      await _authHeader(request.headers);
      final response = await request.close();
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final taskList = (jsonDecode(stringData) as List)
            .map((dynamic json) => Task.fromJson(json as Map<String, dynamic>))
            .toList();
        return Result.ok(taskList);
      } else {
        return Result.error(const HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> createTask(Task task) async {
    final client = _clientFactory();
    try {
      final request = await client.post(_host, _port, '/tasks');
      await _authHeader(request.headers);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(task));
      final response = await request.close();
      if (response.statusCode == 201) {
        return Result.ok(null);
      } else {
        return Result.error(const HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }
}
