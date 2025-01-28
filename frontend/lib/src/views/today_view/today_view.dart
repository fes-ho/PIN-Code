import 'package:flutter/material.dart';
import 'package:frontend/src/features/habits/presentation/create_habit_view.dart';
import 'package:frontend/src/features/habits/presentation/habit_list_state.dart';
import 'package:frontend/src/features/habits/presentation/habit_list_view.dart';
import 'package:frontend/src/features/moods/components/mood_button.dart';
import 'package:frontend/src/features/moods/components/mood_dialog.dart';
import 'package:frontend/src/features/moods/domain/type_of_mood.dart';
import 'package:frontend/src/features/moods/services/mood_service.dart';
import 'package:frontend/src/features/tasks/presentation/task_list_view.dart';
import 'package:frontend/src/features/tasks/presentation/task_list_state.dart';
import 'package:frontend/src/views/today_view/activity_button.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:frontend/src/features/tasks/presentation/create_task_view.dart';
import 'package:frontend/src/features/chatbot/presentation/chatbot_widget.dart';

enum ActivityInTodayView { habits, tasks }

class TodayView extends StatefulWidget {
  const TodayView({super.key});

  @override
  TodayViewState createState() => TodayViewState();
}

class TodayViewState extends State<TodayView> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  TypeOfMood _typeOfMood = TypeOfMood.great;
  ActivityInTodayView _activityInTodayView = ActivityInTodayView.tasks;

  @override
  void initState() {
    super.initState();
    GetIt.I<MoodService>().getMood().then((res) {
      setState(() {
        _typeOfMood = res ?? TypeOfMood.great;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('MMMM, d').format(_focusedDay),
              style: GoogleFonts.lexendDeca(
                color: colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            MoodButton(
                typeOfMood: _typeOfMood,
                onAction: () async {
                  await showMoodDialog(context);

                  _typeOfMood = await GetIt.I<MoodService>().getMood() ??
                      TypeOfMood.great;

                  setState(() {});
                })
          ],
        ),
        backgroundColor: colorScheme.surfaceBright,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ChatbotWidget(),
              _buildCalendar(),
              const SizedBox(height: 16),
              Row(
                children: [
                  ActivityButton(
                      text: "Habits",
                      isSelected:
                          _isActivitySelected(ActivityInTodayView.habits),
                      onPressed: () => setState(() {
                            _activityInTodayView = ActivityInTodayView.habits;
                          })),
                  ActivityButton(
                      text: "To do",
                      isSelected:
                          _isActivitySelected(ActivityInTodayView.tasks),
                      onPressed: () => setState(() {
                            _activityInTodayView = ActivityInTodayView.tasks;
                          })),
                  IconButton.outlined(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => createActivityWidget()),
                      );
                    },
                    icon: const Icon(Icons.add),
                    color: colorScheme.secondary,
                  )
                ],
              ),
              const SizedBox(height: 15,),
              Expanded(child: buildActivityContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 12, bottom: 3),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TableCalendar(
        headerVisible: false,
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.quicksand(
            color: colorScheme.onPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          weekendStyle: GoogleFonts.quicksand(
            color: colorScheme.onPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(
              Provider.of<TaskListState>(context, listen: false).selectedDate,
              day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          Provider.of<TaskListState>(context, listen: false)
              .changeDay(selectedDay);

          Provider.of<HabitListState>(context, listen: false)
              .changeDay(selectedDay);
          setState(() {});
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.fromBorderSide(BorderSide(
                width: 1.5,
                color: colorScheme.primary,
              )),
              borderRadius: BorderRadius.circular(5)),
          selectedDecoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.rectangle,
              border: Border.all(color: colorScheme.primary),
              ),
          defaultDecoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border.all(color: colorScheme.surface)),
          weekendDecoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border.all(color: colorScheme.surface)),
          selectedTextStyle: GoogleFonts.quicksand(
            color: colorScheme.onPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
          todayTextStyle: GoogleFonts.quicksand(
            color: colorScheme.onSecondaryContainer,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          defaultTextStyle: GoogleFonts.quicksand(
            color: colorScheme.onPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          weekendTextStyle: GoogleFonts.quicksand(
            color: colorScheme.onPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          outsideTextStyle: const TextStyle(color: Colors.grey),
        ),
        headerStyle: HeaderStyle(
          titleTextStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          formatButtonTextStyle: const TextStyle(color: Colors.white),
          formatButtonDecoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12.0),
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
          rightChevronIcon:
              const Icon(Icons.chevron_right, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildActivityContent() {
    Map<ActivityInTodayView, Widget> contentInTodayView = {
      ActivityInTodayView.habits: const HabitListView(),
      ActivityInTodayView.tasks: const TaskListView()
    };

    return contentInTodayView[_activityInTodayView] ??
        const Text("Error building view");
  }

  Widget createActivityWidget() {
    Map<ActivityInTodayView, Widget> createActivityInTodayView = {
      ActivityInTodayView.habits: const CreateHabitScreen(),
      ActivityInTodayView.tasks: const CreateTaskScreen()
    };

    return createActivityInTodayView[_activityInTodayView] ??
        const Text("Error in creating activity");
  }

  bool _isActivitySelected(ActivityInTodayView activity) {
    return _activityInTodayView == activity;
  }
}
