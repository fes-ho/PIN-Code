import 'package:flutter/material.dart';
import 'package:frontend/src/constants/app_palette.dart';

class AppTheme{
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: const Color(AppPalette.turquoiseAccent),
      onPrimary: const Color(AppPalette.green),
      secondary: const Color(AppPalette.green),
      onSecondary: const Color(AppPalette.turquoise),
      surface: const Color(AppPalette.white),
      onSurface: const Color(AppPalette.green),
      error: const Color(AppPalette.red),
      onError: const Color(AppPalette.white),
    )
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorSchemeSeed: const Color(0xFF264E5D),
  );
}
