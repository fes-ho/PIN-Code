import 'dart:ffi';

import 'package:frontend/src/features/authentication/data/api_client.dart';
import 'package:frontend/src/features/authentication/data/auth_apli_client.dart';
import 'package:frontend/src/features/authentication/data/shared_preferences_service.dart';
import 'package:frontend/src/features/authentication/domain/login_request/login_request.dart';
import 'package:frontend/src/features/authentication/domain/login_response/login_response.dart';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../utils/result.dart';
import 'auth_repository.dart';

class AuthRepositoryRemote extends AuthRepository {
  AuthRepositoryRemote({
    required ApiClient apiClient,
    required AuthApiClient authApiClient,
    required SharedPreferencesService sharedPreferencesService,
  })  : _apiClient = apiClient,
        _authApiClient = authApiClient,
        _sharedPreferencesService = sharedPreferencesService {
    _apiClient.authHeaderProvider = _authHeaderProvider;
  }

  final AuthApiClient _authApiClient;
  final ApiClient _apiClient;
  final SharedPreferencesService _sharedPreferencesService;

  bool? _isAuthenticated;
  String? _authToken;
  final _log = Logger('AuthRepositoryRemote');

  /// Fetch token from shared preferences
  Future<void> _fetch() async {
    final result = await _sharedPreferencesService.fetchToken();
    switch (result) {
      case Ok<String?>():
        _authToken = result.value;
        _isAuthenticated = result.value != null;
      case Error<String?>():
        _log.severe(
          'Failed to fech Token from SharedPreferences',
          result.error,
        );
    }
  }

  @override
  Future<bool> get isAuthenticated async {
    // Status is cached
    if (_authApiClient.sessionExpired()) {
      _isAuthenticated = false;
    }
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }
    // No status cached, fetch from storage
    await _sharedPreferencesService.saveToken(_authApiClient.getAuthToken());
    await _fetch();
    return _isAuthenticated ?? false;
  }

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authApiClient.login(
        LoginRequest(
          email: email,
          password: password,
        ),
      );
      switch (result) {
        case Ok<LoginResponse>():
          _log.info('User logged int');
          // Set auth status
          _isAuthenticated = true;
          _authToken = result.value.session.accessToken;
          _authSubscriptionProvider();
          // Store in Shared preferences
          return await _sharedPreferencesService.saveToken(result.value.session.accessToken);
        case Error<LoginResponse>():
          _log.warning('Error logging in: ${result.error}');
          return Result.error(result.error);
      }
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> logout() async {
    _log.info('User logged out');
    try {
      // Clear stored auth token
      final result = await _sharedPreferencesService.saveToken(null);
      if (result is Error<void>) {
        _log.severe('Failed to clear stored auth token');
      }

      // Clear token in ApiClient
      _authToken = null;

      // Clear authenticated status
      _isAuthenticated = false;
      return result;
    } finally {
      notifyListeners();
    }
  }

  void _authSubscriptionProvider() {
    _log.info('Setting up auth subscription');
    try {
      final authStream = _authApiClient.onAuthStateChange();
      authStream.listen((data) {
        final AuthChangeEvent event = data.event;
        final Session? session = data.session;

        if(event == AuthChangeEvent.tokenRefreshed){
          _authToken = session?.accessToken;
          _sharedPreferencesService.saveToken(session?.accessToken);
        }
    });
    } finally {
      notifyListeners();
    }
  }

  String? _authHeaderProvider() =>
      _authToken != null ? 'Bearer $_authToken' : null;
}