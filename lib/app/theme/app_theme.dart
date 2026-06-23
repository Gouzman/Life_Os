import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {

  static ThemeData darkTheme = ThemeData(

    useMaterial3: true,

    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.background,

    textTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    ),

    cardTheme: const CardThemeData(
      color: AppColors.card,
      elevation: 0,
    ),

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      surface: AppColors.surface,
    ),
  );
}
