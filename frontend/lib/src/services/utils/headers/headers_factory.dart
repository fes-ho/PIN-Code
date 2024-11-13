import 'package:frontend/src/services/utils/headers/headers_builder.dart';

abstract class HeadersFactory {
  static Map<String, String> getDefaultHeaders() {
    HeadersBuilder builder = HeadersBuilder();
    builder.addJsonFormat();
    builder.addAuthorization();
    return builder.build();
  }
}