import 'package:flutter/material.dart';

class PrioritySelector extends StatelessWidget {
  final int selectedPriority;
  final Function(int) onPriorityChanged;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final priority = index + 1;
        return IconButton(
          icon: Icon(
            priority <= selectedPriority ? Icons.star : Icons.star_border,
            color: priority <= selectedPriority ? Colors.amber : colorScheme.outline,
          ),
          onPressed: () => onPriorityChanged(priority),
        );
      }),
    );
  }
} 