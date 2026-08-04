import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_x.dart';
import '../../../../shared/animations/fade_in.dart';
import '../../../../shared/cards/app_card.dart';

/// Barre de progression linéaire affichant le taux de complétion.
///
/// Le [completionRate] doit être compris entre 0.0 et 1.0.
class CompletionBar extends StatelessWidget {
  const CompletionBar({super.key, required this.completionRate});

  final double completionRate;

  double get _clampedRate => completionRate.clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final percentage = (_clampedRate * 100).round();

    return FadeIn(
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Taux de complétion',
                  style: context.text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.onSurface,
                  ),
                ),
                Text(
                  '$percentage%',
                  style: context.text.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _clampedRate,
                minHeight: 12,
                backgroundColor: context.colors.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.colors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
