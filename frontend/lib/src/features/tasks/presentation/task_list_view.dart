import 'package:flutter/material.dart';
import 'package:frontend/src/features/tasks/domain/task.dart';
import 'package:frontend/src/features/tasks/presentation/task_list_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/src/features/tasks/presentation/task_dialog.dart';
import 'package:provider/provider.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  void _showBottomSheet(BuildContext context, Task task) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      pageBuilder: (BuildContext context, _, __) {
        return TaskDialog(task: task);
      },
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<TaskListState>(
      builder: (context, taskListState, child) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: taskListState.visibleTasks.length,
          itemBuilder: (context, index) {
            final task = taskListState.visibleTasks[index];
            final taskIcon =
                IconData(int.parse(task.icon), fontFamily: 'MaterialIcons');
            final isCompleted = task.isCompleted;
            return Card(
              margin: const EdgeInsets.only(bottom: 15.0),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: colorScheme.outlineVariant, width: 1.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 1.5,
              color: colorScheme.surface,
              shadowColor: colorScheme.outline,
              child: ListTile(
                leading: Icon(taskIcon, color: colorScheme.secondary),
                title: Text(
                  task.name,
                  style: GoogleFonts.quicksand(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text(
                  task.description,
                  style: GoogleFonts.quicksand(
                    color: colorScheme.onSurface,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked),
                  color: isCompleted ? colorScheme.primary : colorScheme.outline,
                  onPressed: () {
                    setState(() {
                      task.isCompleted = !task.isCompleted;
                    });
                  },
                ),
                onTap: () {
                  _showBottomSheet(context, task);
                },
              ),
            );
          },
        );
      }
    );
  }
}