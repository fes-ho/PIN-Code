import 'package:flutter/material.dart';
import 'package:frontend/src/features/moods/presentation/mood_emoji.dart';
import 'package:frontend/src/features/moods/domain/mood.dart';
import 'package:frontend/src/features/stats/presentation/statistics_viewmodel.dart';
import 'package:table_calendar/table_calendar.dart';

class MoodCalendar extends StatefulWidget {
  const MoodCalendar({
    super.key,
    required this.viewModel,
  });

  final StatisticsViewmodel viewModel;

  @override
  State<MoodCalendar> createState() => _MoodCalendarState();
}

class _MoodCalendarState extends State<MoodCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    widget.viewModel.getMemberMoods.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant MoodCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.viewModel.getMemberMoods.removeListener(_onResult);
    widget.viewModel.getMemberMoods.addListener(_onResult);
  }

  @override
  void dispose() {
    widget.viewModel.getMemberMoods.removeListener(_onResult);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel, 
      builder: (context, child) {
        return TableCalendar<Mood>(
          focusedDay: DateTime.now(),
          firstDay: DateTime(2024, 9, 1),
          lastDay: DateTime(2025, 12, 21),
          eventLoader: (day) {
            return widget.viewModel.moods
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
    });
  }
  void _onResult() {
    setState(() {});
  }
}