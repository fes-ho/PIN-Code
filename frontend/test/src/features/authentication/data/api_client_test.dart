import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/features/authentication/data/api_client.dart';
import 'package:frontend/src/utils/result.dart';
import 'package:mock_supabase_http_client/mock_supabase_http_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../testing/mocks.dart';
import '../../../../../testing/models/member.dart';
import '../../../../../testing/models/task.dart';

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
    late String _memberId;

    setUp((){
      mockHttpClient = MockHttpClient();
      apiClient = ApiClient(clientFactory: () => mockHttpClient);
      apiClient.memberId = member.id;
      Supabase.initialize(
        url: 'https://mock.supabase.co', // Does not matter what URL you pass here as long as it's a valid URL
        anonKey: 'fakeAnonKey', // Does not matter what string you pass here
        httpClient: MockSupabaseHttpClient(),
      );
    });

    test('should get member', () async {
      mockHttpClient.mockGet('/members/ID', memberApiModel);
      final result = await apiClient.getMember();
      expect(result.asOk.value, memberApiModel);
    });

    test('should get member tasks', () async {
      final tasks = [kTask1]; 
      mockHttpClient.mockGet('/members/ID/tasks', tasks);
      final result = await apiClient.getTasks();
      expect(result.asOk.value, tasks);
    });

    test('should create task', () async {
      mockHttpClient.mockPost('/tasks', kTask1);
      final result = await apiClient.createTask(kTask1);
      expect(result, isA<Ok<void>>());
    });
  });
}