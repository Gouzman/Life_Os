import 'package:dun/core/widgets/app_scaffold.dart';
import 'package:dun/features/focus_mode/presentation/screens/focus_mode_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExecutionScreen extends StatelessWidget {
  const ExecutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskId = GoRouterState.of(context).uri.queryParameters['taskId'];

    if (taskId == null || taskId.isEmpty) {
      return AppScaffold(
        body: Center(
          child: Text(
            'Aucune tâche active.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    return FocusModeScreen(taskId: taskId);
  }
}
