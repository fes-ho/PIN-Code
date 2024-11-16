import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/config.dart';
import 'package:frontend/src/services/exceptions/not_logged_in_member_exception.dart';
import 'package:frontend/src/services/member_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'log_in_test.mocks.dart';
import 'utils.dart';

// Mock para Supabase
@GenerateMocks([SupabaseClient, GoTrueClient])
void main() {
  late MemberService memberService;
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockAuthClient;
  bool isSupabaseInit = false;

  const defaultMockUser = User(
      id: 'test-user-id',
      appMetadata: {'provider': 'email'},
      userMetadata: {'name': 'Test User'},
      aud: 'authenticated',
      createdAt: "now");

  final session =
      Session(accessToken: sessionJwt, user: defaultMockUser, tokenType: "JWT");

  setUp(() async {
    memberService = MemberService();
    mockSupabaseClient = MockSupabaseClient();
    mockAuthClient = MockGoTrueClient();

    when(mockSupabaseClient.auth).thenReturn(mockAuthClient);

    if (!isSupabaseInit) {
      Supabase.initialize(url: 'url', anonKey: 'anonKey');
      isSupabaseInit = true;
    }

    await dotenv.load();

    Supabase.instance.client = mockSupabaseClient;
  });

  group('MemberService Tests', () {
    test('Debe lanzar NotLoggedInMemberException si no hay sesión o usuario',
        () async {
      // Arrange
      when(mockAuthClient.currentSession).thenReturn(null);
      when(mockAuthClient.currentUser).thenReturn(null);

      // Act & Assert
      expect(() async => await memberService.getMember(),
          throwsA(isA<NotLoggedInMemberException>()));
    });

    test('Debe retornar un Member válido si hay sesión y usuario', () async {
      // Arrange
      when(mockAuthClient.currentSession).thenReturn(session);
      when(mockAuthClient.currentUser).thenReturn(defaultMockUser);

      final mockHttpClient = MockClient((request) async {
        expect(request.url.toString(),
            '${Config.apiUrl}/members/test-user-id/username');
        return http.Response('test-username', 201);
      });

      MemberService(client: mockHttpClient);

      // Act
      final member = await memberService.getMember();

      // Assert
      expect(member.id, 'test-user-id');
      expect(member.username, 'test-username');
    });

    test('Debe lanzar una excepción si falla el endpoint de username',
        () async {
      // Arrange
      when(mockAuthClient.currentSession).thenReturn(session);
      when(mockAuthClient.currentUser).thenReturn(defaultMockUser);

      final mockHttpClient = MockClient((request) async {
        return http.Response('Failed to get Username', 400);
      });

      MemberService(client: mockHttpClient);

      // Act & Assert
      expect(() async => await memberService.getMember(), throwsException);
    });

    test('signIn debe llamar al método de Supabase', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      final mockResponse = AuthResponse();
      when(mockAuthClient.signInWithPassword(email: email, password: password))
          .thenAnswer((_) async => mockResponse);

      // Act
      final response = await memberService.signIn(email, password);

      // Assert
      expect(response, mockResponse);
      verify(mockAuthClient.signInWithPassword(
              email: email, password: password))
          .called(1);
    });

    test('getJWT debe retornar el token JWT actual', () {
      // Arrange
      when(mockAuthClient.currentSession).thenReturn(session);

      // Act
      final jwt = memberService.getJWT();

      // Assert
      expect(jwt, sessionJwt);
    });

    test('getJWT debe retornar un string vacío si no hay sesión', () {
      // Arrange
      when(mockAuthClient.currentSession).thenReturn(null);

      // Act
      final jwt = memberService.getJWT();

      // Assert
      expect(jwt, '');
    });
  });
}
