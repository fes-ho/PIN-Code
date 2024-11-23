import 'package:frontend/src/utils/headers_builder.dart';

class HeadersFactory {
  Future<Map<String, String>> getDefaultHeaders() async {
    HeadersBuilder builder = HeadersBuilder();
    builder.addJsonFormat();
    await builder.addAuthorization();
    return builder.build();
  }
}