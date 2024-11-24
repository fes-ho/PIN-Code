import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/features/authentication/domain/member/member.dart';
import 'package:frontend/src/features/authentication/application/member_service.dart';
import 'package:frontend/src/features/tasks/application/task_service.dart';
import 'package:frontend/src/features/tasks/presentation/task_list_viewmodel.dart';
import 'package:frontend/src/views/custom_navigation_bar.dart';
import 'package:frontend/src/features/authentication/presentation/login_view.dart';
import 'package:frontend/src/common_widgets/splash_loading.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../tasks/presentation/create_task_view_test.mocks.dart';
import 'log_in_view_test.mocks.dart';
import '../application/utils.dart';

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
      TaskService mockTaskService = MockTaskService();

      when(mockMemberService.signIn(any, any)).thenAnswer((_) async =>
          AuthResponse(session: defaultSession, user: defaultMockUser));

      when(mockMemberService.getMember())
          .thenAnswer((_) async => Member(username: 'username', id: 'id'));

      when(mockTaskService.getTasks())
          .thenAnswer((_) async => []);

      GetIt.I.registerSingleton<MemberService>(mockMemberService);
      GetIt.I.registerSingleton<TaskService>(mockTaskService);

      // Act.
      await tester.pumpWidget(
        ChangeNotifierProvider (
          create: (context) => TaskListState(),
          child: MaterialApp(
            home: const LogIn(),
            routes: {
              SplashLoading.routeName: (_) => const SplashLoading(),
              MainNavigationView.routeName: (_) => const MainNavigationView()
            },
          ),
        )
      );

      await tester.enterText(find.byType(TextField).first, testMail);
      await tester.enterText(find.byType(TextField).at(1), testPassword);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Assert.
      expect(find.byType(MainNavigationView), findsOneWidget);
    });
  });
}
