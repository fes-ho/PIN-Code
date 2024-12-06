import 'package:flutter/material.dart';
import 'package:frontend/src/features/moods/components/mood_calendar.dart';
import 'package:frontend/src/features/streaks/presentation/streak_calendar.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'MoodCalendar'),
              Tab(text: 'StreakCalendar'),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: TabBarView(
                controller: _tabController,
                children: const [
                  MoodCalendar(),
                  StreakCalendar(),
                ],
              ),
            ),
            const Expanded(child: StreakInfo()),
          ],
        ),
      ),
    );
  }
}

// Define the StreakInfo widget
class StreakInfo extends StatelessWidget {
  const StreakInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text("Current streak: 0"),
        Text("Global streak: 0"),
      ],
    );
  }
}