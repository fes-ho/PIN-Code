import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/services/member_service.dart';
import 'package:frontend/src/views/log_in_view.dart';
import 'package:frontend/src/views/splash_loading_view.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'log_in_test.mocks.dart';
import 'log_in_widgets_test.mocks.dart';
import 'utils.dart';

@GenerateMocks([MemberService])
void main() {
  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockAuthClient;
  const testMail = 'test@example.com';
  const testPassword = 'password123';
 bool isSupabaseInit = false;
  group('LogIn Page', () {
setUp(() async {
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
    
    testWidgets('navigates to SplashLoadingView when Sign In is pressed', (WidgetTester tester) async {
      // Arrange
      final mockMemberService = MockMemberService();
      when(mockMemberService.signIn(testMail, testPassword))
        .thenAnswer((_) async => AuthResponse(session: session, user: defaultMockUser));

      await tester.pumpWidget(MaterialApp(
        home: const LogIn(),
        routes: {
          SplashLoadingView.routeName: (_) => const SplashLoadingView(),
        },
      ));

      await tester.enterText(find.byType(TextField).first, testMail);
      await tester.enterText(find.byType(TextField).at(1), testPassword);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert that SplashLoadingView is displayed
      expect(find.byType(SplashLoadingView), findsOneWidget);
    });
  });
}
