import 'package:frontend/src/features/authentication/data/api_client.dart';
import 'package:frontend/src/features/authentication/data/member_repository.dart';
import 'package:frontend/src/features/authentication/domain/member.dart';
import 'package:frontend/src/features/authentication/domain/user/member_api_model.dart';
import 'package:frontend/src/utils/result.dart';

class MemberRepositoryRemote implements UserRepository {
  MemberRepositoryRemote({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Member? _cachedData;

  @override
  Future<Result<Member>> getMember() async {
    if (_cachedData != null) {
      return Future.value(Result.ok(_cachedData!));
    }

    final result = await _apiClient.getUser();
    switch (result) {
      case Ok<MemberApiModel>():
        final user = Member(
          id: result.value.id,
          username: result.value.username,
        );
        _cachedData = user;
        return Result.ok(user);
      case Error<MemberApiModel>():
        return Result.error(result.error);
    }
  }
}