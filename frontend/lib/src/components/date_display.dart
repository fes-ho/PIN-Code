import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DateDisplayWidget extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateChanged;

  const DateDisplayWidget({
    super.key,
    required this.initialDate,
    required this.onDateChanged
  });

  @override
  State<DateDisplayWidget> createState() => _DateDisplayWidgetState();
}

class _DateDisplayWidgetState extends State<DateDisplayWidget> {
  late DateTime date = widget.initialDate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null && pickedDate != date) {
          setState(() {
            date = pickedDate;
          });
          widget.onDateChanged(pickedDate);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: colorScheme.outline, 
            width: 2.0,
          )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.calendar_today,
                color: colorScheme.secondary,
                size: 24.0,
              ),
              Text(
                DateFormat('dd/MM/yyyy').format(date),
                style: GoogleFonts.quicksand(
                  color: colorScheme.onSurface,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 22.0),
            ],
          ),
        ),
      ),
    );
  }
}