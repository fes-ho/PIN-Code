import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/config.dart';
import 'package:frontend/src/services/exceptions/not_logged_in_member_exception.dart';
import 'package:frontend/src/services/member_service.dart';
import 'package:frontend/src/services/utils/headers/headers_factory.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'log_in_unit_test.mocks.dart';
import 'utils.dart';

@GenerateMocks([GoTrueClient])
void main() {
  late MockGoTrueClient mockAuthClient;

  setUp(() async {
    mockAuthClient = MockGoTrueClient();

    GetIt.I.registerSingleton<HeadersFactory>(HeadersFactory());
    GetIt.I.registerSingleton(Client());

    dotenv.testLoad(
        fileInput: '''
          API_URL=http://10.0.2.2:8000 
      ''',
      );
  });

  tearDown(() {
    GetIt.I.reset();
  });

  group('MemberService Tests', () {
    test('Throws NotLoggedInMemberException if there is no session or user provided',
        () async {
      // Arrange.
      when(mockAuthClient.currentSession).thenReturn(null);
      when(mockAuthClient.currentUser).thenReturn(null);

      GetIt.I.registerSingleton<GoTrueClient>(mockAuthClient);

      MemberService memberService = MemberService();

      // Act & Assert.
      expect(() async => await memberService.getMember(),
          throwsA(isA<NotLoggedInMemberException>()));
    });

    test('Returns Member if session and user are provided', () async {
      // Arrange.
      when(mockAuthClient.currentSession).thenReturn(defaultSession);
      when(mockAuthClient.currentUser).thenReturn(defaultMockUser);

      final mockHttpClient = MockClient((request) async {
        expect(request.url.toString(),
            '${Config.apiUrl}/members/test-user-id/username');
        return http.Response('test-username', 201);
      });

      GetIt.I.unregister<Client>();
      GetIt.I.registerSingleton<Client>(mockHttpClient);

      GetIt.I.registerSingleton<GoTrueClient>(mockAuthClient);

      MemberService memberService = MemberService();

      // Act.
      final member = await memberService.getMember();

      // Assert.
      expect(member.id, 'test-user-id');
      expect(member.username, 'test-username');
    });

    test('Throws excecption if the username endpoint fails',
        () async {
      // Arrange.
      when(mockAuthClient.currentSession).thenReturn(defaultSession);
      when(mockAuthClient.currentUser).thenReturn(defaultMockUser);

      final mockHttpClient = MockClient((request) async {
        return http.Response('Failed to get Username', 400);
      });

      GetIt.I.unregister<Client>();
      GetIt.I.registerSingleton<Client>(mockHttpClient);
      GetIt.I.registerSingleton<GoTrueClient>(mockAuthClient);

     MemberService memberService = MemberService(); 

      // Act & Assert.
      expect(() async => await memberService.getMember(), throwsException);
    });

    test('sign in method from supabase must be called', () async {
      // Arrange.
      const email = 'test@example.com';
      const password = 'password123';
      final mockResponse = AuthResponse();
      when(mockAuthClient.signInWithPassword(email: email, password: password))
          .thenAnswer((_) async => mockResponse);

      GetIt.I.registerSingleton<GoTrueClient>(mockAuthClient);
      
      MemberService memberService = MemberService();

      // Act.
      final response = await memberService.signIn(email, password);

      // Assert.
      expect(response, mockResponse);
      verify(mockAuthClient.signInWithPassword(
              email: email, password: password))
          .called(1);
    });

    test('returns current jwt', () {
      // Arrange.
      when(mockAuthClient.currentSession).thenReturn(defaultSession);

      GetIt.I.registerSingleton<GoTrueClient>(mockAuthClient);
      
      MemberService memberService = MemberService();

      // Act.
      final jwt = memberService.getJWT();

      // Assert.
      expect(jwt, sessionJwt);
    });

    test('returns empty string if no jwt is provided', () {
      // Arrange.
      when(mockAuthClient.currentSession).thenReturn(null);

      GetIt.I.registerSingleton<GoTrueClient>(mockAuthClient);

      MemberService memberService = MemberService();

      // Act.
      final jwt = memberService.getJWT();

      // Assert.
      expect(jwt, '');
    });
  });
}
