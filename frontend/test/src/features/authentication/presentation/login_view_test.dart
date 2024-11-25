import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/features/authentication/presentation/login_view.dart';
import 'package:frontend/src/features/authentication/presentation/login_viewmodel.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import '../../../../../testing/app.dart';
import '../../../../../testing/fakes/repositories/fake_auth_repository.dart';
import '../../../../../testing/mocks.dart';

void main() {
  group('LoginView tests', () {
    late LoginViewModel viewModel;
    late MockGoRouter goRouter;
    late FakeAuthRepository fakeAuthRepository;

    setUp(() {
      goRouter = MockGoRouter();
      fakeAuthRepository = FakeAuthRepository();
      viewModel = LoginViewModel(authRepository: fakeAuthRepository);
    });

    Future<void> loadScreen(WidgetTester tester) async {
      await testApp(
        tester, 
        LoginView(viewModel: viewModel),
        goRouter: goRouter,
      );
    }
    
    testWidgets('should load screen', (WidgetTester tester) async {
      await mockNetworkImages(() async{
        await loadScreen(tester);
        expect(find.byType(LoginView), findsOneWidget);
      });
    });

    testWidgets('should perform login', (WidgetTester tester) async {
      await mockNetworkImages(() async{
        await loadScreen(tester);

        expect(fakeAuthRepository.token, null);

        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();

        expect(fakeAuthRepository.token, 'TOKEN');

        verify(() => goRouter.go('/')).called(1);
      });
    });
  });
}