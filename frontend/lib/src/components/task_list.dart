import 'package:flutter/material.dart';
import 'package:frontend/src/domain/task.dart';

class TaskList extends StatefulWidget {
  final List<Task> tasks;

  const TaskList({super.key, required this.tasks});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.tasks.length,
      itemBuilder: (context, index) {
        final task = widget.tasks[index];
        final taskIcon = IconData(int.parse(task.icon), fontFamily: 'MaterialIcons');
        final isCompleted = task.isCompleted;
        return Card(
          margin: const EdgeInsets.only(bottom: 15.0),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: colorScheme.outlineVariant, width: 1.0),
            borderRadius: BorderRadius.circular(15.0), // Borde circular
          ),
          elevation: 1.5,
          color: colorScheme.surface,
          shadowColor: colorScheme.outline,
          child: ListTile(
            leading: Icon(taskIcon, color: colorScheme.secondary),
            title: Text(
              task.name,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            subtitle: Text(
              task.description,
              style: TextStyle(
                color: colorScheme.onSurface,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            trailing: IconButton(
              icon: Icon(isCompleted ? Icons.check_circle : Icons.radio_button_unchecked),
              color: isCompleted ? colorScheme.primary : colorScheme.outline,
              onPressed: () {
                setState(() {
                  task.isCompleted = !task.isCompleted;
                });
              },
            ),
          ),
        );
      },
    );
  }
}