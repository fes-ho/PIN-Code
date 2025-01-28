import 'package:flutter/material.dart';
import 'package:frontend/src/features/habits/domain/frequency.dart';

class FrequencySelector extends StatelessWidget {
  final Frequency selectedFrequency;
  final Function(Frequency) onFrequencyChanged;

  const FrequencySelector({
    super.key,
    required this.selectedFrequency,
    required this.onFrequencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Lista que determina cuál botón está activo
    final isSelected = [
      selectedFrequency == Frequency.daily,
      selectedFrequency == Frequency.weekly,
      selectedFrequency == Frequency.monthly,
    ];

    final colorScheme = Theme.of(context).colorScheme;

    return ToggleButtons(
      borderRadius: BorderRadius.circular(20),
      borderColor: colorScheme.secondary,
      selectedBorderColor: colorScheme.secondary,
      fillColor: colorScheme.secondary,
      selectedColor: colorScheme.surface, 
      color: colorScheme.secondary, 
      isSelected: isSelected, 
      onPressed: (int index) {
        // Llama a la función proporcionada por el padre
        onFrequencyChanged(Frequency.values[index]);
      },
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text("Daily"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text("Weekly"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text("Monthly"),
        ),
      ],
    );
  }
}