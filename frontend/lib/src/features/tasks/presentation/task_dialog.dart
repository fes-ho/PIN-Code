import 'package:flutter/material.dart';
import 'package:frontend/src/features/tasks/domain/task.dart';
import 'package:frontend/src/features/tasks/presentation/create_task_view.dart';
import 'package:frontend/src/features/tasks/presentation/task_list_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/src/common_widgets/action_button.dart';
import 'package:frontend/src/features/tasks/presentation/task_timer.dart';
import 'package:get_it/get_it.dart';
import 'package:frontend/src/features/tasks/application/task_service.dart';
import 'package:frontend/src/features/tasks/presentation/estimated_time_dialog.dart';
import 'package:provider/provider.dart';

class TaskDialog extends StatefulWidget {
  final Task task;
  const TaskDialog({super.key, required this.task});

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  late Task _currentTask;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
  }

  Future<void> _showEstimatedTimeDialog(BuildContext context) async {
    final TaskService taskService = GetIt.I<TaskService>();
    final colorScheme = Theme.of(context).colorScheme;

    final int? estimatedDuration = await showDialog<int>(
      context: context,
      builder: (BuildContext context) => EstimatedTimeDialog(
        initialEstimatedDuration: _currentTask.estimatedDuration,
      ),
    );

    if (estimatedDuration != null && context.mounted) {
      try {
        final updatedTask = await taskService.updateTaskDuration(
          _currentTask.id!,
          _currentTask.duration ?? 0,
          estimatedDuration: estimatedDuration,
        );
        
        setState(() {
          _currentTask = updatedTask;
        });
        
        if (context.mounted) {
          context.read<TaskListState>().updateTask(updatedTask);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating estimated duration'),
              backgroundColor: colorScheme.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.5,
        right: MediaQuery.of(context).size.width * 0.03,
        left: MediaQuery.of(context).size.width * 0.03,
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(IconData(int.parse(_currentTask.icon), fontFamily: 'MaterialIcons'), color: colorScheme.onSecondary),
                const SizedBox(width: 8),
                Text(_currentTask.name,
                    style: GoogleFonts.lexendDeca(
                      color: colorScheme.onSecondary, 
                      fontSize: 18,
                    )
                ),
              ],
            ),
            const SizedBox(height: 12),
            TaskTimer(task: _currentTask),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.close, color: colorScheme.onSecondaryContainer),
                    label: Text('Delete',
                        style: GoogleFonts.quicksand(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                        )),
                    onPressed: () {
                      context.read<TaskListState>().removeTask(_currentTask);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondaryContainer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.check, color: colorScheme.onSecondaryContainer),
                    label: Text('Complete',
                        style: GoogleFonts.quicksand(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                        )),
                    onPressed: () {
                      context.read<TaskListState>().completeTask(_currentTask);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondaryContainer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ActionButton(
              icon: Icons.access_time,
              label: 'Time',
              onPressed: () => _showEstimatedTimeDialog(context),
            ),
            const SizedBox(height: 8),
            ActionButton(
              icon: Icons.edit, 
              label: 
                  'Edit',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateTaskScreen(task: _currentTask)),
                );
              },
              ),
          ],
        ),
      ),
    );
  }
}