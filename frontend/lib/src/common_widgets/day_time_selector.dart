import 'package:flutter/material.dart';
import 'package:frontend/src/features/habits/domain/day_time.dart';
import 'package:google_fonts/google_fonts.dart';

class DayTimeSelector extends StatelessWidget {
  final DayTime selectedDayTime;
  final Function(DayTime) onDayTimeChanged;

  const DayTimeSelector({
    super.key,
    required this.selectedDayTime,
    required this.onDayTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: DayTime.values.take(2).map((dayTime) {
            return Expanded(
              child: RadioListTile<DayTime>(
                title: Text(
                  _dayTimeToString(dayTime), 
                  style: GoogleFonts.quicksand(
                    color: colorScheme.onPrimary, 
                  )),
                value: dayTime,
                activeColor: colorScheme.secondary,
                groupValue: selectedDayTime,
                onChanged: (DayTime? value) {
                  if (value != null) {
                    onDayTimeChanged(value);
                  }
                },
              ),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: DayTime.values.skip(2).take(2).map((dayTime) {
            return Expanded(
              child: RadioListTile<DayTime>(
                title: Text(
                  _dayTimeToString(dayTime), 
                  style: GoogleFonts.quicksand(
                    color: colorScheme.onPrimary, 
                  )),
                value: dayTime,
                activeColor: colorScheme.secondary,
                groupValue: selectedDayTime,
                onChanged: (DayTime? value) {
                  if (value != null) {
                    onDayTimeChanged(value);
                  }
                },
              ),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: RadioListTile<DayTime>(
                title: Text(_dayTimeToString(DayTime.anytime)),
                value: DayTime.anytime,
                activeColor: colorScheme.secondary,
                groupValue: selectedDayTime,
                onChanged: (DayTime? value) {
                  if (value != null) {
                    onDayTimeChanged(value);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _dayTimeToString(DayTime dayTime) {
    switch (dayTime) {
      case DayTime.morning:
        return "Morning";
      case DayTime.afternoon:
        return "Afternoon";
      case DayTime.evening:
        return "Evening";
      case DayTime.night:
        return "Night";
      case DayTime.anytime:
        return "Any time";
    }
  }
}
