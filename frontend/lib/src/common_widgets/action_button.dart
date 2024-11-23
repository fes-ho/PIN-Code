
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const ActionButton({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton.icon(
      icon: Icon(icon, color: colorScheme.onSecondaryContainer),
      label: Text(label, style: GoogleFonts.quicksand(
        color: colorScheme.onSecondaryContainer,
        fontWeight: FontWeight.w600,
      )),
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.secondaryContainer,
        minimumSize: const Size(double.infinity, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}