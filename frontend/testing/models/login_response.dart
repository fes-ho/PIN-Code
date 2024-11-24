
import 'package:frontend/src/features/authentication/domain/login_response/login_response.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final kLoginResponse = LoginResponse(
  user: kUser,
  session: kSession,
);

final kUser = User(
  id: 'ID',
  appMetadata: {'key': 'APP_METADATA'},
  userMetadata: {'key': 'USER_METADATA'},
  aud: 'AUD',
  createdAt: DateTime.now().toIso8601String(),
);

final kSession = Session(
  accessToken: 'ACCESS_TOKEN',
  tokenType: 'TOKEN_TYPE',
  user: kUser,
);