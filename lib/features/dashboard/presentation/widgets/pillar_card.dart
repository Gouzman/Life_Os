import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';

class PillarCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int progress;
  final Color color;

  const PillarCard({
    super.key,
    required this.title,
    required this.icon,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedProgress = progress.clamp(0, 100) / 100;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Icon(icon, size: 22, color: color),
            ),
          ),
          const Spacer(),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(AppSpacing.sm),
          LinearProgressIndicator(
            value: normalizedProgress,
            minHeight: 5,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: AppColors.surfaceHigh,
            color: color,
          ),
          const Gap(AppSpacing.sm),
          Text(
            '$progress%',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
