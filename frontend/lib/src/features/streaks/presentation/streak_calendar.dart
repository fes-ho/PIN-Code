import 'package:flutter/material.dart';
import 'package:frontend/src/features/streaks/domain/streak.dart';
import 'package:frontend/src/features/streaks/services/streak_service.dart';
import 'package:get_it/get_it.dart';
import 'package:table_calendar/table_calendar.dart';

class StreakCalendar extends StatefulWidget {
  const StreakCalendar({super.key});

  @override
  State<StreakCalendar> createState() => _StreakCalendarState();
}

class _StreakCalendarState extends State<StreakCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final _streakService = GetIt.I<StreakService>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _streakService,
      builder: (context, child) {
        return TableCalendar<Streak>(
          focusedDay: DateTime.now(),
          firstDay: DateTime(2024, 9, 1),
          lastDay: DateTime(2025, 12, 21),
          eventLoader: (day) {
            return (_streakService.streaks)
              .where((streak) =>
                  streak.date.day == day.day &&
                  streak.date.month == day.month &&
                  streak.date.year == day.year)
              .toList();
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if (events.isEmpty) {
                return const SizedBox();
              }
              return Icon(
                Icons.local_fire_department, 
                color: Colors.orange[900],
                size: 35
              );
            },
          ),
          availableCalendarFormats: const {
            CalendarFormat.month: 'Month',
          },
          onFormatChanged: (format) => setState(() {
            _calendarFormat = format;
          }),
          calendarFormat: _calendarFormat,
        );
      },
    );
  }
}
