import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';

class LifeScoreCard extends StatelessWidget {
  final int score;
  final int completedMissions;
  final int plannedMissions;

  const LifeScoreCard({
    super.key,
    this.score = 84,
    this.completedMissions = 3,
    this.plannedMissions = 5,
  });

  @override
  Widget build(BuildContext context) {
    final progress = plannedMissions == 0
        ? 0.0
        : (completedMissions / plannedMissions).clamp(0.0, 1.0).toDouble();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Life Score',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(AppSpacing.lg),
          Text(
            '$score%',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Gap(AppSpacing.sm),
          Text(
            '$completedMissions/$plannedMissions missions validees',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const Gap(AppSpacing.md),
          LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: AppColors.surfaceHigh,
            color: AppColors.success,
          ),
        ],
      ),
    );
  }
}
