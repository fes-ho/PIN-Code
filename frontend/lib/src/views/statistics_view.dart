import 'package:flutter/material.dart';
import 'package:frontend/src/features/moods/components/mood_calendar.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          MoodCalendar(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Current streak: 0"),
              Text("Global streak: 0")
            ],
          )
        ],
      ),
    );
  }
}