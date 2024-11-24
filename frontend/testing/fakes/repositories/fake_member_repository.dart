
import 'package:frontend/src/features/authentication/data/member_repositories/member_repository.dart';
import 'package:frontend/src/features/authentication/domain/member/member.dart';
import 'package:frontend/src/utils/result.dart';

import '../../models/member.dart';

class FakeMemberRepository implements MemberRepository {
  @override
  Future<Result<Member>> getMember() async {
    return Result.ok(member);
  }
}