import 'package:supabase_flutter/supabase_flutter.dart';

String sessionJwt = 'jwt-token';

const defaultMockUser = User(
    id: 'test-user-id',
    appMetadata: {'provider': 'email'},
    userMetadata: {'name': 'Test User'},
    aud: 'authenticated',
    createdAt: "now");

final session =
    Session(accessToken: sessionJwt, user: defaultMockUser, tokenType: "JWT");
