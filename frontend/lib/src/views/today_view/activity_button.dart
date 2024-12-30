import 'package:flutter/material.dart';

class ActivityButton extends StatelessWidget {
  const ActivityButton(
      {super.key,
      required this.text,
      required this.isSelected,
      required this.onPressed});

  final String text;
  final bool isSelected;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.transparent))),
          backgroundColor:
              WidgetStatePropertyAll(_getBackgroundColor(context))),
      child: Text(
        text,
        style: TextStyle(color: _getTextColor(context)),
      ),
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return isSelected ? colorScheme.secondary : colorScheme.surface;
  }

  Color _getTextColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return isSelected ? colorScheme.primary : colorScheme.secondary;
  }
}
