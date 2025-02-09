import 'package:flutter/material.dart';

class ColorProfile {
  // Light theme color scheme
  static const light = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF007678),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFB6FFFF),
      secondary: Color(0xFF009653),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFEBD1FF),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xff131313),
      onSurfaceVariant: Color(0xFF577E7E),//for highlight textFormFields
      surfaceContainer: Color(0xFFECECEC),
      surfaceContainerHigh: Color(0xFFE7E7E7),
      error: Color(0xFFB00020),
      onError: Color(0xFFA25353),
      outline: Color(0xFFB26D6D),
      outlineVariant: Color(0xFFD0D0D0));

  // Dark theme color scheme
  static const dark = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF009698),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFF005454),
      secondary: Color(0xFF00C46D),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFF470073),
      surface: Color(0xFF181818),
      onSurface: Color(0xFFFFFFFF),
      onSurfaceVariant: Color(0xFF003C3D),//for highlight textFormFields
      surfaceContainer: Color(0xFF1E1E1E),
      surfaceContainerHigh: Color(0xFF252525),
      error: Color(0xFFD30024),
      onError: Color(0xFFA25353),
      outline: Color(0xFFB26D6D),
      outlineVariant: Color(0xFF2C2C2C));
}
