import 'package:flutter/material.dart';
import 'package:frontend/src/features/tasks/domain/task/task.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/src/common_widgets/action_button.dart';
import 'package:frontend/src/features/time_tracking/presentation/time_tracking_widget.dart';
import 'package:frontend/src/features/time_tracking/presentation/time_tracking_viewmodel.dart';
import 'package:frontend/src/features/time_tracking/data/time_tracking_repository.dart';
import 'package:provider/provider.dart';

class TaskDialog extends StatelessWidget {
  final Task task;

  const TaskDialog({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      insetPadding: EdgeInsets.only(
        top: screenHeight * 0.42,
        right: MediaQuery.of(context).size.width * 0.03,
        left: MediaQuery.of(context).size.width * 0.03,
        bottom: 16,
      ),
      child: SingleChildScrollView(
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
                  Expanded(
                    child: Text(
                      task.name,
                      style: GoogleFonts.lexendDeca(
                        color: colorScheme.onSecondary, 
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TimeTrackingWidget(
                viewModel: TimeTrackingViewModel(
                  repository: context.read<TimeTrackingRepository>(),
                  task: task,
                ),
              ),
              const SizedBox(height: 8),
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
      ),
    );
  }
}