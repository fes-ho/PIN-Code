import 'dart:async';

import 'package:frontend/src/features/authentication/data/auth_apli_client.dart';
import 'package:frontend/src/features/authentication/domain/login_request/login_request.dart';
import 'package:frontend/src/features/authentication/domain/login_response/login_response.dart';
import 'package:frontend/src/utils/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/login_response.dart';

class FakeAuthApiClient extends AuthApiClient {
  FakeAuthApiClient() : super(clientFactory: () => SupabaseClient('supabaseUrl', 'supabaseKey'));

  @override
  Future<Result<LoginResponse>> login(LoginRequest loginRequest) async {
    // Simulate a successful login response
    if (loginRequest.email == 'EMAIL' && loginRequest.password == 'PASSWORD'){
      return Result.ok(kLoginResponse);
    }
    return Result.error(Exception('ERROR!'));
  }

  @override
  bool sessionExpired() {
    // Simulate session expiration check
    return false;
  }

  @override
  String getAuthToken() {
    // Return a fake auth token
    return 'fakeAuthToken';
  }

  @override
  Stream<AuthState> onAuthStateChange() {
    return Stream.value(AuthState(AuthChangeEvent.tokenRefreshed, kSession));
  }
}