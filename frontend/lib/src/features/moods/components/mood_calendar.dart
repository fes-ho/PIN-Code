import 'package:flutter/material.dart';
import 'package:frontend/src/features/moods/components/mood_emoji.dart';
import 'package:frontend/src/features/moods/domain/mood.dart';
import 'package:frontend/src/features/moods/services/mood_service.dart';
import 'package:get_it/get_it.dart';
import 'package:table_calendar/table_calendar.dart';

class MoodCalendar extends StatefulWidget {
  const MoodCalendar({super.key});

  @override
  State<MoodCalendar> createState() => _MoodCalendarState();
}

class _MoodCalendarState extends State<MoodCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final _moodService = GetIt.I<MoodService>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _moodService,
      builder: (context, child) {
        return TableCalendar<Mood>(
          focusedDay: DateTime.now(),
          firstDay: DateTime(2024, 9, 1),
          lastDay: DateTime(2025, 12, 21),
          eventLoader: (day) {
            return (_moodService.moods)
              .where((mood) =>
                  mood.day.day == day.day &&
                  mood.day.month == day.month &&
                  mood.day.year == day.year)
              .toList();
          },
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            if (events.isEmpty) {
              return const SizedBox();
            }
            Mood mood = events.first;

            return MoodEmoji(mood: mood.typeOfMood);
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
