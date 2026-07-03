import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'router/app_router.dart';
import 'theme/app_colors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Life OS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: AppColors.primary,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
