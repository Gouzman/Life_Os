import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/router_paths.dart';
import '../../../../core/extensions/build_context_x.dart';
import '../../../../shared/animations/fade_in.dart';
import '../../../../shared/buttons/app_button.dart';

class EmptyHistory extends StatelessWidget {
  const EmptyHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Padding(
        padding: context.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Icon(
              Icons.history_outlined,
              size: 80,
              color: context.colors.onSurfaceVariant.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 24),
            Text(
              'Aucun historique',
              style: context.text.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Commencez par créer et compléter\nvos premières tâches.',
              textAlign: TextAlign.center,
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            AppButton(
              label: 'Créer une tâche',
              icon: const Icon(Icons.add),
              onPressed: () => context.go(RouterPaths.tasks),
            ),
          ],
        ),
      ),
    );
  }
}
