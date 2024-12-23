import 'package:flutter/material.dart';

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final void Function() onPressed;

  const RoundedIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: ShapeDecoration(
        color: colorScheme.tertiary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: IconButton(
        onPressed: onPressed, 
        icon: Icon(
          icon,
          color: colorScheme.surface,
        ),
      ),
    );
  }
}