import 'dart:io';

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
  String? memberId;

  @override
  Future<Result<MemberApiModel>> getMember() async {
    return Result.ok(memberApiModel);
  }

  @override
  Future<Result<List<Task>>> getTasks() async {
    requestCount++;
    return Result.ok([kTask1]);
  }

  @override
  Future<Result<void>> createTask(Task task) async {
    return Result.ok(null);
  }

  @override
  Future<void> authHeader(HttpHeaders headers) {
    // TODO: implement authHeader
    throw UnimplementedError();
  }

  @override
  // TODO: implement clientFactory
  HttpClient Function() get clientFactory => throw UnimplementedError();

  @override
  Future<String> getMemberId() {
    // TODO: implement getMemberId
    throw UnimplementedError();
  }

  @override
  // TODO: implement host
  get host => throw UnimplementedError();

  @override
  // TODO: implement port
  get port => throw UnimplementedError();
}