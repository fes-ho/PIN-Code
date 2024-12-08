import 'package:flutter/material.dart';
import 'package:frontend/src/features/moods/components/mood_calendar.dart';
import 'package:frontend/src/features/streaks/presentation/streak_calendar.dart';
import 'package:frontend/src/features/streaks/services/streak_service.dart';
import 'package:get_it/get_it.dart';

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
            Expanded(child: StreakInfo()),
          ],
        ),
      ),
    );
  }
}

// Define the StreakInfo widget
class StreakInfo extends StatelessWidget {
  StreakInfo({super.key});

  final _streakService = GetIt.I<StreakService>();
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _streakService,
      builder: (context, child) {
        return Row (
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Current Streak: ${_streakService.currentStreak}'),
          Text('Longest Streak: ${_streakService.bestStreak}'),
        ],
      );
      }     );
  }
}