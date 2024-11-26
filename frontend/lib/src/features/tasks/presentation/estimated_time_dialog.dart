import 'package:flutter/material.dart';
import 'package:frontend/src/common_widgets/hour_and_minute_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class EstimatedTimeDialog extends StatefulWidget {
  final int? initialEstimatedDuration;
  
  const EstimatedTimeDialog({
    super.key,
    this.initialEstimatedDuration,
  });

  @override
  State<EstimatedTimeDialog> createState() => _EstimatedTimeDialogState();
}

class _EstimatedTimeDialogState extends State<EstimatedTimeDialog> {
  late int _selectedHour;
  late int _selectedMinute;

  @override
  void initState() {
    super.initState();
    if (widget.initialEstimatedDuration != null) {
      _selectedHour = widget.initialEstimatedDuration! ~/ 3600;
      _selectedMinute = (widget.initialEstimatedDuration! % 3600) ~/ 60;
    } else {
      _selectedHour = 0;
      _selectedMinute = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Estimated Duration',
              style: GoogleFonts.lexendDeca(
                color: colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            HourAndMinutePickerWidget(
              initialHour: _selectedHour,
              initialMinute: _selectedMinute,
              onHourChanged: (hour) => _selectedHour = hour,
              onMinuteChanged: (minute) => _selectedMinute = minute,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel',
                    style: GoogleFonts.quicksand(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final totalSeconds = (_selectedHour * 3600) + (_selectedMinute * 60);
                    Navigator.pop(context, totalSeconds);
                  },
                  child: Text('Save',
                    style: GoogleFonts.quicksand(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 