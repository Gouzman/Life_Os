import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_x.dart';
import '../../../../shared/animations/fade_in.dart';

/// En-tête du Dashboard affichant le titre et le sous-titre de la page.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: context.text.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Aperçu de votre productivité',
            style: context.text.bodyLarge?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
