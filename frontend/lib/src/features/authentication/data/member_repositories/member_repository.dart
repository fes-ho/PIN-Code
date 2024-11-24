import 'package:frontend/src/features/authentication/domain/member/member.dart';
import 'package:frontend/src/utils/result.dart';

/// Data source for user related data
abstract class MemberRepository {
  /// Get current user
  Future<Result<Member>> getMember();
}