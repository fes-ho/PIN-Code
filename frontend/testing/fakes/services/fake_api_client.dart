import 'package:frontend/src/features/authentication/data/api_client.dart';
import 'package:frontend/src/features/authentication/domain/member_api/member_api_model.dart';
import 'package:frontend/src/features/tasks/domain/task/task.dart';
import 'package:frontend/src/utils/result.dart';

import '../../models/member.dart';
import '../../models/task.dart';

class FakeApiClient implements ApiClient {
  // Should not increase when using cached data
  int requestCount = 0;

  @override
  AuthHeaderProvider? authHeaderProvider;

  @override
  Future<Result<MemberApiModel>> getMember() async {
    return Result.ok(memberApiModel);
  }

  @override
  Future<Result<List<Task>>> getTasks() async {
    requestCount++;
    return Result.ok([kTask]);
  }

  @override
  Future<Result<void>> createTask(Task task) async {
    return Result.ok(null);
  }
}