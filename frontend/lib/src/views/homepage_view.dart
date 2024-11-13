import 'package:flutter/material.dart';
import 'package:frontend/src/components/task_list.dart';
import 'package:frontend/src/domain/task.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:frontend/src/views/create_task.dart';


class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  HomePageViewState createState() => HomePageViewState();
}

class HomePageViewState extends State<HomePageView> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final List<Task> tasks = [
    Task(
      id: '1',
      name: 'Drink water',
      date: DateTime.now(),
      description: 'Drink 8 glasses of water',
      icon: '57815',
      isCompleted: false,
    ),
    Task(
      id: '2',
      name: 'Go for a walk',
      date: DateTime.now(),
      description: 'Walk for 30 minutes',
      icon: '57815',
      isCompleted: false,
    ),
    Task(
      id: '3',
      name: 'Read a book',
      date: DateTime.now(),
      description: 'Read for 1 hour',
      icon: '57815',
      isCompleted: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          DateFormat('MMMM, d').format(_focusedDay),
          style: GoogleFonts.lexendDeca(
            color: colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
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
              Expanded(child: TaskList(tasks: tasks)),
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
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay; // update `_focusedDay` here as well
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

  // Widget _buildTaskDetails() {
  //   return Container(
  //     padding: const EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[900],
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Column(
  //       children: [
  //         const Row(
  //           children: [
  //             Icon(Icons.water_drop, color: Colors.blue),
  //             SizedBox(width: 8),
  //             Text('Drink water', style: TextStyle(color: Colors.white, fontSize: 18)),
  //           ],
  //         ),
  //         const SizedBox(height: 12),
  //         Row(
  //           children: [
  //             Expanded(
  //               child: ElevatedButton.icon(
  //                 icon: const Icon(Icons.close, color: Colors.purple),
  //                 label: const Text('Delete', style: TextStyle(color: Colors.purple)),
  //                 onPressed: () {},
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.grey[800],
  //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 8),
  //             Expanded(
  //               child: ElevatedButton.icon(
  //                 icon: const Icon(Icons.check, color: Colors.purple),
  //                 label: const Text('Complete', style: TextStyle(color: Colors.purple)),
  //                 onPressed: () {},
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.grey[800],
  //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 8),
  //         _buildActionButton(Icons.access_time, 'Time'),
  //         const SizedBox(height: 8),
  //         _buildActionButton(Icons.edit, 'Edit'),
  //       ],
  //     ),
  //   );
  // }

//   Widget _buildActionButton(IconData icon, String label) {
//     return ElevatedButton.icon(
//       icon: Icon(icon, color: Colors.purple),
//       label: Text(label, style: const TextStyle(color: Colors.purple)),
//       onPressed: () {},
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.grey[800],
//         minimumSize: const Size(double.infinity, 40),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }
}