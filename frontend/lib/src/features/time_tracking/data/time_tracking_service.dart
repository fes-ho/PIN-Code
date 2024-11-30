import 'package:frontend/src/features/time_tracking/data/time_tracking_api_client.dart';
import 'package:frontend/src/utils/result.dart';

class TimeTrackingService {
  TimeTrackingService({
    required TimeTrackingApiClient apiClient,
  }) : _apiClient = apiClient;

  final TimeTrackingApiClient _apiClient;

  Future<Result<void>> updateTaskDuration(String taskId, int duration, {int? estimatedDuration}) async {
    return _apiClient.updateTaskDuration(taskId, duration, estimatedDuration: estimatedDuration);
  }
} 