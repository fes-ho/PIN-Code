import 'dart:convert';
import 'dart:io';

import 'package:frontend/src/features/authentication/domain/user/member_api_model.dart';
import 'package:frontend/src/utils/result.dart';

/// Adds the `Authentication` header to a header configuration.
typedef AuthHeaderProvider = String? Function();

class ApiClient {
  ApiClient({
    String? host,
    int? port,
    HttpClient Function()? clientFactory,
  })  : _host = host ?? 'localhost',
        _port = port ?? 8000,
        _clientFactory = clientFactory ?? (() => HttpClient());

  final String _host;
  final int _port;
  final HttpClient Function() _clientFactory;

  AuthHeaderProvider? _authHeaderProvider;

  set authHeaderProvider(AuthHeaderProvider authHeaderProvider) {
    _authHeaderProvider = authHeaderProvider;
  }

  Future<void> _authHeader(HttpHeaders headers) async {
    final header = _authHeaderProvider?.call();
    if (header != null) {
      headers.add(HttpHeaders.authorizationHeader, header);
    }
  }  
  
  Future<Result<MemberApiModel>> getUser() async {
    final client = _clientFactory();
    try {
      final request = await client.get(_host, _port, '/user');
      await _authHeader(request.headers);
      final response = await request.close();
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final user = MemberApiModel.fromJson(jsonDecode(stringData));
        return Result.ok(user);
      } else {
        return Result.error(const HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }
}