import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/features/tasks/presentation/create_task_view.dart';
import 'package:frontend/src/features/tasks/presentation/create_task_viewmodel.dart';
import 'package:frontend/src/features/today/presentation/today_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../testing/app.dart';
import '../../../../../testing/fakes/repositories/fake_task_repository.dart';
import '../../../../../testing/mocks.dart';
import '../../../../../testing/models/task.dart';

void main() {
  group('CreateTaskView tests', (){
    late MockGoRouter goRouter;
    late CreateTaskViewModel createTaskViewModel;
    late TodayViewModel todayViewModel;
    late FakeTaskRepository taskRepository;

    setUp(() {
      goRouter = MockGoRouter();
      taskRepository = FakeTaskRepository();
      todayViewModel = TodayViewModel(taskRepository: taskRepository);
      createTaskViewModel = CreateTaskViewModel(taskRepository: taskRepository, todayViewModel: todayViewModel);
    });

    Future<void> loadScreen(WidgetTester tester) async {
      await testApp(
        tester,
        CreateTaskView(viewModel: createTaskViewModel),
        goRouter: goRouter,
      );
    }

    testWidgets('should load screen', (WidgetTester tester) async {
      await loadScreen(tester);
      expect(find.byType(CreateTaskView), findsOneWidget);
    });

    testWidgets('should validate form', (WidgetTester tester) async {
      await loadScreen(tester);

      await tester.tap(find.text('Create task'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter the task name'), findsOneWidget);
    });

    testWidgets('should create task', (WidgetTester tester) async {
      await loadScreen(tester);

      await tester.enterText(find.byType(TextFormField), kTask2.name);
      await tester.tap(find.text('Create task'));
      await tester.pumpAndSettle(Duration(seconds: 3));

      expect(todayViewModel.tasks.length, 1);
      expect(todayViewModel.tasks.first.name, kTask2.name);
      verify(() => goRouter.go('/')).called(1);
    });
  });
}