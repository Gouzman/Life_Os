import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:life_os/core/domain/value_objects/energy_level.dart';
import 'package:life_os/features/missions/domain/entities/mission_instance.dart';
import 'package:life_os/features/missions/domain/entities/mission_template.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';

/// Shows detailed information about a single mission before the user starts.
class MissionDetailCard extends StatelessWidget {
  final MissionInstance mission;
  final MissionTemplate template;
  final String lifeAreaName;

  const MissionDetailCard({
    super.key,
    required this.mission,
    required this.template,
    required this.lifeAreaName,
  });

  @override
  Widget build(BuildContext context) {
    final start = mission.scheduledStart;
    final end = mission.scheduledEnd;
    final remaining = end.difference(DateTime.now());
    final remainingLabel = remaining.isNegative
        ? 'Heure depassee'
        : _formatDuration(remaining);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            template.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Gap(AppSpacing.sm),
          Text(
            template.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const Gap(AppSpacing.xl),

          // Time info
          _InfoRow(
            icon: Icons.play_circle_outline,
            label: 'Debut',
            value: _formatTime(start),
          ),
          const Gap(AppSpacing.sm),
          _InfoRow(
            icon: Icons.stop_circle_outlined,
            label: 'Fin',
            value: _formatTime(end),
          ),
          const Gap(AppSpacing.sm),
          _InfoRow(
            icon: Icons.timer_outlined,
            label: 'Duree restante',
            value: remainingLabel,
          ),
          const Gap(AppSpacing.sm),
          _InfoRow(
            icon: Icons.stars_outlined,
            label: 'XP a gagner',
            value: '+${template.xpReward} XP',
          ),
          const Gap(AppSpacing.sm),
          _InfoRow(
            icon: Icons.category_outlined,
            label: 'Domaine',
            value: lifeAreaName,
          ),
          const Gap(AppSpacing.sm),
          _InfoRow(
            icon: Icons.battery_charging_full,
            label: 'Energie requise',
            value: _energyLabel(template.energyLevel),
          ),
          const Gap(AppSpacing.sm),
          _InfoRow(
            icon: Icons.priority_high,
            label: 'Importance',
            value: '${template.importance}/10',
          ),
          const Gap(AppSpacing.xl),

          // Start button
          FilledButton.icon(
            onPressed: () =>
                context.push('/focus-mode', extra: {'missionId': mission.id}),
            icon: const Icon(Icons.rocket_launch_outlined),
            label: const Text('Commencer'),
          ),
        ],
      ),
    );
  }

  static String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  static String _formatDuration(Duration d) {
    if (d.inMinutes < 60) return '${d.inMinutes} min';
    final h = d.inHours;
    final min = d.inMinutes.remainder(60);
    return min == 0 ? '${h}h' : '${h}h ${min}min';
  }

  static String _energyLabel(EnergyLevel level) {
    switch (level) {
      case EnergyLevel.low:
        return 'Basse';
      case EnergyLevel.medium:
        return 'Moyenne';
      case EnergyLevel.high:
        return 'Haute';
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const Gap(AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
