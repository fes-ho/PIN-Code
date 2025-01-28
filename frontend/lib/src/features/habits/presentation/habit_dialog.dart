import 'package:flutter/material.dart';
import 'package:frontend/src/features/habits/domain/habit.dart';
import 'package:frontend/src/features/habits/presentation/create_habit_view.dart';
import 'package:frontend/src/features/habits/presentation/habit_list_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/src/common_widgets/action_button.dart';
import 'package:frontend/src/features/habits/presentation/habit_timer.dart';
import 'package:get_it/get_it.dart';
import 'package:frontend/src/features/habits/application/habit_service.dart';
import 'package:frontend/src/features/tasks/presentation/estimated_time_dialog.dart';
import 'package:provider/provider.dart';
import 'package:frontend/src/common_widgets/priority_selector.dart';

class HabitDialog extends StatefulWidget {
  final Habit habit;
  const HabitDialog({super.key, required this.habit});

  @override
  State<HabitDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<HabitDialog> {
  late Habit _currentHabit;

  @override
  void initState() {
    super.initState();
    _currentHabit = widget.habit;
  }

  Future<void> _showEstimatedTimeDialog(BuildContext context) async {
    final HabitService habitService = GetIt.I<HabitService>();
    final colorScheme = Theme.of(context).colorScheme;

    final int? estimatedDuration = await showDialog<int>(
      context: context,
      builder: (BuildContext context) => EstimatedTimeDialog(
        initialEstimatedDuration: _currentHabit.estimatedDuration,
      ),
    );

    if (estimatedDuration != null && context.mounted) {
      try {
        final updatedHabit = await habitService.updateHabitDuration(
          _currentHabit.id!,
          _currentHabit.duration ?? 0,
          estimatedDuration: estimatedDuration,
        );
        
        setState(() {
          _currentHabit = updatedHabit;
        });
        
        if (context.mounted) {
          context.read<HabitListState>().updateHabit(updatedHabit);
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
        top: MediaQuery.of(context).size.height * 0.45,
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
                Icon(IconData(int.parse(_currentHabit.icon), fontFamily: 'MaterialIcons'), color: colorScheme.onSecondary),
                const SizedBox(width: 8),
                Text(_currentHabit.name,
                    style: GoogleFonts.lexendDeca(
                      color: colorScheme.onSecondary, 
                      fontSize: 18,
                    )
                ),
              ],
            ),
            const SizedBox(height: 12),
            HabitTimer(habit: _currentHabit),
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
                      context.read<HabitListState>().removeHabit(_currentHabit);
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
                      context.read<HabitListState>().completeHabit(_currentHabit);
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
              label: 'Edit',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateHabitScreen(habit: _currentHabit)),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}