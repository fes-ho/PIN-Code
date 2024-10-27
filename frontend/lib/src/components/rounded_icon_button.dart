import 'package:flutter/material.dart';

class RoundedIconButton extends StatefulWidget {
  final IconData initialIcon;
  final ValueChanged<IconData> onIconChanged;

  const RoundedIconButton({
    super.key,
    required this.initialIcon,
    required this.onIconChanged,
  });

  @override
  State<RoundedIconButton> createState() => _RoundedIconButtonState();
}

class _RoundedIconButtonState extends State<RoundedIconButton> {
  late IconData icon = widget.initialIcon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: ShapeDecoration(
        color: colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: IconButton(
        onPressed: () => print("gola"), 
        icon: Icon(
          icon,
          color: colorScheme.onSecondary,
        ),
      ),
    );
  }
}