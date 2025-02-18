import 'package:frontend/src/features/authentication/application/member_service.dart';
import 'package:get_it/get_it.dart';

class HeadersBuilder {
  late Map<String, String> _headers;

  HeadersBuilder() {
    reset();
  }

  void reset() {
    _headers = {};
  }

  Future addAuthorization() async{ 
    String jwt = await GetIt.I<MemberService>().getJWT();

    _headers.putIfAbsent('Authorization',() => 'Bearer $jwt');
  }

  void addJsonFormat() {
    _headers.putIfAbsent('Content-Type',() => 'application/json; charset=UTF-8');
  }

  Map<String, String> build() {
    return _headers;
  }
}