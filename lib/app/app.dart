import 'package:flutter/material.dart';

import '../core/widgets/main_shell.dart';
import 'theme/app_theme.dart';

class LifeOSApp extends StatelessWidget {

  const LifeOSApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      theme: AppTheme.darkTheme,

      home: const MainShell(),
    );
  }
}
