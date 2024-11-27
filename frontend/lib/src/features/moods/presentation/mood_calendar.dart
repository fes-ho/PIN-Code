import 'package:flutter/material.dart';
import 'package:frontend/src/features/moods/presentation/mood_emoji.dart';
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
  List<Mood> _moods = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    GetIt.I<MoodService>().getMemberMoods().then((result) => setState(() {
          _moods = result;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar<Mood>(
      focusedDay: DateTime.now(),
      firstDay: DateTime(2024, 9, 1),
      lastDay: DateTime(2025, 12, 21),
      eventLoader: (day) {
        return _moods
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
  }
}
