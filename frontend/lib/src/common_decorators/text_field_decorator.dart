
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldDecorator {
  static InputDecoration getTextFieldDecoration({
    required String hintText,
    required ColorScheme colorScheme,
    required TextEditingController controller,
    required Function() onClear,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.quicksand(
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
      fillColor: colorScheme.secondary,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.outline,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      errorStyle: GoogleFonts.quicksand(
          color: colorScheme.error,
          fontWeight: FontWeight.bold,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.error,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.secondary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: colorScheme.error,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      suffixIcon: controller.text.isNotEmpty
          ? IconButton(
              onPressed: () {
                controller.clear();
                onClear();
              },
              icon: const Icon(Icons.clear),
            )
          : null,
    );
  }
}
