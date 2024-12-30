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

    return Consumer<TaskListState>(builder: (context, taskListState, child) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: taskListState.visibleTasks.length,
        itemBuilder: (context, index) {
          List<Task> tasks = List.from(taskListState.visibleTasks)
            ..sort((a, b) => b.priority.compareTo(a.priority));
          final task = tasks[index];
          final taskIcon =
              IconData(int.parse(task.icon), fontFamily: 'MaterialIcons');
          final isCompleted = task.isCompleted;
          return Card(
            margin: const EdgeInsets.only(bottom: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 1.5,
            color: colorScheme.primary,
            child: ListTile(
              leading: Icon(taskIcon, color: colorScheme.secondary),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      task.name,
                      style: GoogleFonts.quicksand(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < task.priority ? Icons.star : Icons.star_border,
                            size: 14,
                            color: index < task.priority
                                ? colorScheme.secondary
                                : colorScheme.outline,
                          );
                        }),
                      ),
                      const SizedBox(height: 8,),
                      Row(
                        children: [
                          Icon(
                            task.estimatedDuration != null
                            ? Icons.restore
                            : null
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
              subtitle: Text(
                task.description,
                style: GoogleFonts.quicksand(
                  color: colorScheme.onSurface,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              trailing: Transform.scale(scale: 1.5, child: Checkbox(
                value: isCompleted,
                checkColor: colorScheme.secondary,
                side: const BorderSide(
                  color: Colors.transparent
                ),
                fillColor: WidgetStatePropertyAll(colorScheme.surface),
                onChanged: (_) {
                  setState(() {
                    taskListState.completeTask(task);
                  });
                },
              ),),
              onTap: () {
                _showBottomSheet(context, task);
              },
            ),
          );
        },
      );
    });
  }
}
