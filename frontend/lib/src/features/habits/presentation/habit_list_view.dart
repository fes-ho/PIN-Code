import 'package:flutter/material.dart';
import 'package:frontend/src/features/habits/domain/category.dart';
import 'package:frontend/src/features/habits/domain/habit.dart';
import 'package:frontend/src/features/habits/presentation/habit_list_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/src/features/habits/presentation/habit_dialog.dart';
import 'package:provider/provider.dart';

class HabitListView extends StatefulWidget {
  const HabitListView({super.key});

  @override
  State<HabitListView> createState() => _HabitListViewState();
}

class _HabitListViewState extends State<HabitListView> {
  void _showBottomSheet(BuildContext context, Habit habit) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      pageBuilder: (BuildContext context, _, __) {
        return HabitDialog(habit: habit);
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

  Color _getColorByCategoria(Category categoria) {
    switch (categoria) {
      case Category.sleep:
        return Colors.purple.shade100;
      case Category.work:
        return Colors.orange.shade100;
      case Category.hydration:
        return Colors.cyan.shade100;
      case Category.exercise:
        return Colors.yellow.shade100;
      case Category.food:
        return Colors.green.shade100;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<HabitListState>(builder: (context, habitListState, child) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: habitListState.visibleHabits.length,
        itemBuilder: (context, index) {
          List<Habit> habits = List.from(habitListState.visibleHabits);
          final habit = habits[index];
          final habitIcon =
              IconData(int.parse(habit.icon), fontFamily: 'MaterialIcons');
          final isCompleted = habit.isCompleted;
          return Card(
            margin: const EdgeInsets.only(bottom: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 1.5,
            color: _getColorByCategoria(habit.category),
            child: ListTile(
              leading: Icon(habitIcon, color: colorScheme.secondary, size: 35,),
              title: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [  
                      Row(
                        children: [
                          Chip(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            backgroundColor: _getColorByCategoria(habit.category),
                            label: Text(
                              habit.frequency.toString().split('.').last,
                              style: GoogleFonts.quicksand(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 12))),
                          const SizedBox(width: 8),
                          Chip(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            backgroundColor: _getColorByCategoria(habit.category),
                            label: Text(
                              habit.dayTime.toString().split('.').last,
                              style: GoogleFonts.quicksand(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w400,
                                fontSize: 12)
                              )
                            ),
                        ] 
                      ),
                      const SizedBox(height: 8), 
                      Text(
                        habit.name,
                        style: GoogleFonts.quicksand(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        )
                      )  
                    ],),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      const SizedBox(height: 8,),
                      Row(
                        children: [
                          Icon(
                            habit.estimatedDuration != null
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
                habit.description,
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
                    habitListState.completeHabit(habit);
                  });
                },
              ),),
              onTap: () {
                _showBottomSheet(context, habit);
              },
            ),
          );
        },
      );
    });
  }
}
