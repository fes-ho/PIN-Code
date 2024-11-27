import 'package:flutter/material.dart';
import 'package:frontend/src/features/stats/presentation/mood_calendar.dart';
import 'package:frontend/src/features/stats/presentation/statistics_viewmodel.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({
    super.key,
    required this.viewModel,
  });

  final StatisticsViewmodel viewModel;

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MoodCalendar(
            viewModel: widget.viewModel,
          ),
          const Row(
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