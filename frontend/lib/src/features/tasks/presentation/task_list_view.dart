import 'package:flutter/material.dart';
import 'package:frontend/src/features/tasks/domain/task/task.dart';
import 'package:frontend/src/features/today/presentation/today_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/src/features/tasks/presentation/task_dialog.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({
    super.key,
    required this.viewModel,
  });

  final TodayViewModel viewModel;

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {

  @override
  void initState() {
    super.initState();
    widget.viewModel.getTasks.execute();
  }

  @override
  void didUpdateWidget(covariant TaskListView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

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

    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: widget.viewModel.visibleTasks.length,
          itemBuilder: (context, index) {
            final task = widget.viewModel.visibleTasks[index];
            final taskIcon =
                IconData(int.parse(task.icon), fontFamily: 'MaterialIcons');
            final isCompleted = task.is_completed;
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
                      final updatedTask = task.copyWith(is_completed: !task.is_completed);
                      widget.viewModel.update(updatedTask);
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