import 'dart:convert';
import 'dart:io';

import 'package:frontend/src/features/authentication/data/api_client.dart';
import 'package:frontend/src/utils/result.dart';

class TimeTrackingApiClient {
  TimeTrackingApiClient({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Result<void>> updateTaskDuration(String taskId, int duration, {int? estimatedDuration}) async {
    final client = _apiClient.clientFactory();
    try {
      final request = await client.patch(
        _apiClient.host,
        _apiClient.port,
        '/tasks/$taskId/duration',
      );
      await _apiClient.authHeader(request.headers);
      request.headers.contentType = ContentType.json;
      
      final data = {
        'duration': duration,
        if (estimatedDuration != null) 'estimated_duration': estimatedDuration,
      };
      
      request.write(jsonEncode(data));
      final response = await request.close();
      
      if (response.statusCode == 200) {
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