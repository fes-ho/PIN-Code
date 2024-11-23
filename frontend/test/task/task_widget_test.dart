import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/common_widgets/rounded_icon_button.dart';
import 'package:frontend/src/features/tasks/application/task_service.dart';
import 'package:frontend/src/features/tasks/presentation/create_task_view.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'task_widget_test.mocks.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'utils.dart';

@GenerateMocks([TaskService])
void main() {
  late MockTaskService mockTaskService;

  group('Create Task page', () {
    setUp(() {
      mockTaskService = MockTaskService();
      when(mockTaskService.createTask(any)).thenAnswer((_) async => task);

      GetIt.I.registerSingleton<TaskService>(mockTaskService);
    });

    tearDown(() {
      GetIt.I.reset();
    });

    testWidgets('Renderiza correctamente los elementos principales',
        (WidgetTester tester) async {
      // Renderiza la pantalla
      await tester.pumpWidget(
        const MaterialApp(
          home: CreateTaskScreen(),
        ),
      );

      // Comprueba que los elementos principales estén presentes
      expect(find.text('New task'), findsOneWidget); // Título
      expect(find.byType(TextFormField), findsWidgets); // Campos de texto
      expect(find.byType(RoundedIconButton), findsOneWidget); // Botón de icono
      expect(find.byType(ElevatedButton), findsOneWidget); // Botón de crear
    });
  });
}
