import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:life_os/core/domain/value_objects/energy_level.dart';
import 'package:life_os/features/missions/domain/entities/mission_instance.dart';
import 'package:life_os/features/missions/domain/entities/mission_template.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';

/// Displays the current priority mission with its key metadata.
///
/// Receives its data from the Dashboard provider layer – it contains no
/// business logic of its own.
class HeroMissionCard extends StatelessWidget {
  final MissionInstance mission;
  final MissionTemplate template;
  final String lifeAreaName;

  const HeroMissionCard({
    super.key,
    required this.mission,
    required this.template,
    required this.lifeAreaName,
  });

  String _formatDuration(Duration d) {
    if (d.inMinutes < 60) return '${d.inMinutes} min';
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    return m == 0 ? '${h}h' : '${h}h ${m}min';
  }

  String _energyLabel(EnergyLevel level) {
    switch (level) {
      case EnergyLevel.low:
        return 'Energie basse';
      case EnergyLevel.medium:
        return 'Energie moyenne';
      case EnergyLevel.high:
        return 'Energie haute';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _StatusPill(
                icon: template.critical ? Icons.flag : Icons.flag_outlined,
                label: template.critical
                    ? 'Mission prioritaire'
                    : 'Mission planifiee',
                color: template.critical
                    ? AppColors.accent
                    : AppColors.textSecondary,
              ),
              _StatusPill(
                icon: Icons.category_outlined,
                label: lifeAreaName,
                color: AppColors.textSecondary,
              ),
            ],
          ),
          const Gap(AppSpacing.lg),
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
              height: 1.4,
            ),
          ),
          const Gap(AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              _MissionMeta(
                icon: Icons.schedule,
                label: _formatDuration(template.duration),
              ),
              _MissionMeta(
                icon: Icons.battery_charging_full,
                label: _energyLabel(template.energyLevel),
              ),
              _MissionMeta(
                icon: Icons.stars_outlined,
                label: '+${template.xpReward} XP',
              ),
            ],
          ),
          const Gap(AppSpacing.lg),
          FilledButton.icon(
            onPressed: () =>
                context.push('/today', extra: {'missionId': mission.id}),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Voir la mission'),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatusPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 14),
            const Gap(AppSpacing.xs),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MissionMeta extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MissionMeta({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 16),
        const Gap(AppSpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
