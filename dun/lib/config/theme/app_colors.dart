import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color amber = Color(0xFFFFC82C);
  static const Color deepGraphite = Color(0xFF15171C);
  static const Color carbon = Color(0xFF1D2027);
  static const Color slate = Color(0xFF2A2F39);
  static const Color fog = Color(0xFFE8ECF1);
  static const Color steel = Color(0xFF9AA4B2);
  static const Color signalBlue = Color(0xFF2A9DFF);
  static const Color mint = Color(0xFF45D6A8);

  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: amber,
    onPrimary: Colors.black,
    secondary: mint,
    onSecondary: Colors.black,
    error: Color(0xFFFF6B6B),
    onError: Colors.black,
    surface: carbon,
    onSurface: fog,
  );

  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1A1E27),
    onPrimary: Colors.white,
    secondary: signalBlue,
    onSecondary: Colors.white,
    error: Color(0xFFD73A49),
    onError: Colors.white,
    surface: Color(0xFFF5F7FA),
    onSurface: Color(0xFF161A23),
  );
}
