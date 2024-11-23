import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/result.dart';
import '../domain/login_request/login_request.dart';
import '../domain/login_response/login_response.dart';

class AuthApiClient {
  AuthApiClient({
    SupabaseClient Function()? clientFactory,
  })  : _clientFactory = clientFactory ?? (() => Supabase.instance.client);

  final SupabaseClient Function() _clientFactory;

  Future<Result<LoginResponse>> login(LoginRequest loginRequest) async {
    final client = _clientFactory();
    try {
      final request = await client.auth.signInWithPassword(email: loginRequest.email, password: loginRequest.password);
      final session = request.session;
      final user = request.user;
      if (session == null) {
        return Result.error(Exception('Session is null'));
      }
      if (user == null) {
        return Result.error(Exception('User is null'));
      }
      return Result.ok(LoginResponse(session: session, user: user));
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.dispose();
    }
  }
}