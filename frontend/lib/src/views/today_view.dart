import 'package:flutter/material.dart';
import 'package:frontend/src/features/moods/components/mood_button.dart';
import 'package:frontend/src/features/moods/components/mood_dialog.dart';
import 'package:frontend/src/features/moods/domain/mood.dart';
import 'package:frontend/src/features/moods/domain/type_of_mood.dart';
import 'package:frontend/src/features/moods/services/mood_service.dart';
import 'package:frontend/src/features/tasks/presentation/task_list_view.dart';
import 'package:frontend/src/features/tasks/presentation/task_list_state.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:frontend/src/features/tasks/presentation/create_task_view.dart';


class TodayView extends StatefulWidget {
  const TodayView({super.key});

  @override
  TodayViewState createState() => TodayViewState();
}

class TodayViewState extends State<TodayView> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  TypeOfMood _typeOfMood = TypeOfMood.great;

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
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),

            MoodButton(
              typeOfMood: _typeOfMood, 
              onAction: () async {
                await showMoodDialog(context);

                _typeOfMood = await GetIt.I<MoodService>().getMood() ?? TypeOfMood.great;

                setState(() {
                  
                });
              } 
            )
          ],
        ),
        backgroundColor: colorScheme.surfaceBright,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only( left: 15, right: 15, top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCalendar(),
              const SizedBox(height: 8),
              Divider(color: colorScheme.outlineVariant),
              const SizedBox(height: 8),
              //_buildProgressBar(),
              const Expanded(child: TaskListView()),
              // _buildTaskDetails(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTaskScreen()),
          );
        },
        backgroundColor: colorScheme.tertiary,
        child: Icon(Icons.add, color: colorScheme.onTertiary),
      ),
    );
  }

  Widget _buildCalendar() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 12, bottom: 3),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TableCalendar(
        headerVisible: false,
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.quicksand(
            color: colorScheme.onSecondaryContainer,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          weekendStyle: GoogleFonts.quicksand(
            color: colorScheme.onSecondaryContainer,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          return isSameDay(Provider.of<TaskListState>(context, listen: false).selectedDate, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          Provider.of<TaskListState>(context, listen: false).changeDay(selectedDay);
          setState(() {
          });
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
            shape: BoxShape.circle,
            border: Border.fromBorderSide(
                BorderSide(
                  width: 1.5,
                  color: colorScheme.primary,
                )
            ), 
          ),
          selectedDecoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
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
            color: colorScheme.onSecondaryContainer,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          weekendTextStyle: GoogleFonts.quicksand(
            color: colorScheme.onSecondaryContainer,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          outsideTextStyle: const TextStyle(color: Colors.grey),
        ),
        headerStyle: HeaderStyle(
          titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          formatButtonTextStyle: const TextStyle(color: Colors.white),
          formatButtonDecoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12.0),
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
          rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white),
        ),
      ),
    );
  }
}