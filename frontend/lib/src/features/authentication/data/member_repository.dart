import 'package:frontend/src/features/authentication/domain/member.dart';

import '../../../utils/result.dart';

/// Data source for user related data
abstract class UserRepository {
  /// Get current user
  Future<Result<Member>> getMember();
}