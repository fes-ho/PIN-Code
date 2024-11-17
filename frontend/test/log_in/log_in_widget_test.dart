import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/domain/member.dart';
import 'package:frontend/src/services/member_service.dart';
import 'package:frontend/src/views/initialpage_view.dart';
import 'package:frontend/src/views/log_in_view.dart';
import 'package:frontend/src/views/main_view.dart';
import 'package:frontend/src/views/splash_loading_view.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'log_in_widget_test.mocks.dart';
import 'utils.dart';

@GenerateMocks([MemberService])
void main() {
  String testMail = 'pacopepe@pacopepe.es';
  String testPassword = 'pacopepe';

  group('LogIn Page', () {
    tearDown(() {
      GetIt.I.reset();
    });

    testWidgets(
        'navigates to an authorizated view when Sign In button is pressed',
        (WidgetTester tester) async {
      // Arrange.
      dotenv.testLoad(
        fileInput: '''
          API_URL=http://10.0.2.2:8000 
      ''',
      );
      
      MockMemberService mockMemberService = MockMemberService();

      when(mockMemberService.signIn(any, any)).thenAnswer((_) async =>
          AuthResponse(session: defaultSession, user: defaultMockUser));

      when(mockMemberService.getMember())
          .thenAnswer((_) async => Member(username: 'username', id: 'id'));

      GetIt.I.registerSingleton<MemberService>(mockMemberService);

      // Act.
      await tester.pumpWidget(MaterialApp(
        home: const LogIn(),
        routes: {
          SplashLoadingView.routeName: (_) => const SplashLoadingView(),
          InitialPageView.routeName: (_) => const InitialPageView()
        },
      ));

      await tester.enterText(find.byType(TextField).first, testMail);
      await tester.enterText(find.byType(TextField).at(1), testPassword);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert.
      expect(find.byType(MainView), findsOneWidget);
    });
  });
}
