
import 'package:flutter/material.dart';
import 'package:frontend/src/features/tasks/domain/task/task.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/src/common_widgets/action_button.dart';

class TaskDialog extends StatelessWidget {
  final Task task;

  const TaskDialog({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.6,
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
                Icon(IconData(int.parse(task.icon), fontFamily: 'MaterialIcons'), color: colorScheme.onSecondary),
                const SizedBox(width: 8),
                Text(task.name,
                    style: GoogleFonts.lexendDeca(
                      color: colorScheme.onSecondary, 
                      fontSize: 18,
                    )
                ),
              ],
            ),
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
                    onPressed: () {},
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
                    onPressed: () {},
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
            const ActionButton(icon: Icons.access_time, label: 'Time'),
            const SizedBox(height: 8),
            const ActionButton(icon: Icons.edit, label: 'Edit'),
          ],
        ),
      ),
    );
  }
}