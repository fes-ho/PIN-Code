import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HourAndMinutePickerWidget extends StatefulWidget {
  final int initialHour;
  final int initialMinute;
  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;

  const HourAndMinutePickerWidget({
    super.key,
    required this.initialHour,
    required this.initialMinute,
    required this.onHourChanged,
    required this.onMinuteChanged,
  });

  @override
  State<HourAndMinutePickerWidget> createState() => _HourAndMinutePickerWidgetState();
}

class _HourAndMinutePickerWidgetState extends State<HourAndMinutePickerWidget> {
  late final FixedExtentScrollController _hourController = FixedExtentScrollController(initialItem: widget.initialHour);
  late final FixedExtentScrollController _minuteController = FixedExtentScrollController(initialItem: widget.initialMinute);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
     
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 175,
              width: 100,
              child: ListWheelScrollView.useDelegate(
                controller: _hourController,
                overAndUnderCenterOpacity: 0.5,
                useMagnifier: true,
                magnification: 1.2,
                physics: const FixedExtentScrollPhysics(),
                // The itemExtent is the height of each item in the list
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  widget.onHourChanged(index);
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: 25,
                  builder: (context, index) {
                    final String formattedIndex = index.toString().padLeft(2, '0');
                    return ListTile(
                      title: Center(
                        child: Text(
                          formattedIndex, 
                          style: GoogleFonts.quicksand(
                            color: colorScheme.onSurface,
                            fontSize: 19.0, 
                            fontWeight: FontWeight.bold,
                          )
                        )
                      ),
                    );
                  }
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 17.5, right: 5), 
              child: Text(
                ':',
                style: GoogleFonts.quicksand(
                  color: colorScheme.onSurface,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 175,
              width: 100,
              child: ListWheelScrollView.useDelegate(
                controller: _minuteController,
                overAndUnderCenterOpacity: 0.5,
                useMagnifier: true,
                magnification: 1.2,
                physics: const FixedExtentScrollPhysics(),
                // The itemExtent is the height of each item in the list
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  widget.onMinuteChanged(index);
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: 60,
                  builder: (context, index) {
                    final String formattedIndex = index.toString().padLeft(2, '0');
                    return ListTile(
                      title: Center(
                        child: Text(
                          formattedIndex, 
                          style: GoogleFonts.quicksand(
                            color: colorScheme.onSurface,
                            fontSize: 19.0, 
                            fontWeight: FontWeight.bold,
                          )
                        )
                      ),
                    );
                  }
                )
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Hours',
                style: GoogleFonts.quicksand(
                  color: colorScheme.onSurface,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(width: 65), // Adjust the width to align the labels properly
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Minutes',
                style: GoogleFonts.quicksand(
                  color: colorScheme.onSurface,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  } 
}