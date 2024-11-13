import 'package:frontend/src/services/member_service.dart';

class HeadersBuilder {
  late Map<String, String> _headers;

  HeadersBuilder() {
    reset();
  }

  void reset() {
    _headers = {};
  }

  void addAuthorization() { 
    String jwt = MemberService().getJWT();

    _headers.putIfAbsent('Authorization',() => 'Bearer $jwt');
  }

  void addJsonFormat() {
    _headers.putIfAbsent('Content-Type',() => 'application/json; charset=UTF-8');
  }

  Map<String, String> build() {
    return _headers;
  }
}