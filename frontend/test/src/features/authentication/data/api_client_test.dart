import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/features/authentication/data/api_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../testing/mocks.dart';
import '../../../../../testing/models/member.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  dotenv.testLoad(
    fileInput: '''
      API_HOST=API_HOST
      API_PORT=1234
      URL=URL
      ANON_KEY=ANON_KEY
    ''',
  );
  group('ApiClient', () {
    late MockHttpClient mockHttpClient;
    late ApiClient apiClient;
    late SupabaseClient? supabaseClient;

    setUp((){
      mockHttpClient = MockHttpClient();
      apiClient = ApiClient(clientFactory: () => mockHttpClient);
      supabaseClient = SupabaseClient(
        'http://local:8000',
        'supabaseKey',
    );
    });

    test('should get member', () async {
      final memberId = member.id;
      mockHttpClient.mockGet('/members/$memberId', memberApiModel);
      final result = await apiClient.getMember();
      expect(result.asOk.value, memberApiModel);
    });
  });
}