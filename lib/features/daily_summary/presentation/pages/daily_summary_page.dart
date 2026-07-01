import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../dashboard/presentation/providers/dashboard_providers.dart';
import '../../../missions/domain/entities/mission_status.dart';
import '../../../planner/presentation/providers/planner_providers.dart';

/// End-of-day summary screen.
///
/// Reads the final state of the [DailyPlan] from the provider layer and
/// presents a read-only recap. Contains no business logic.
class DailySummaryPage extends ConsumerWidget {
  const DailySummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(dailyPlanProvider);
    final templates = ref.watch(missionTemplatesProvider);
    final xp = ref.watch(xpTodayProvider);
    final lifeScore = ref.watch(lifeScoreProvider);
    final progress = ref.watch(todayProgressProvider);
    final completed = ref.watch(completedMissionsCountProvider);
    final planned = ref.watch(plannedMissionsCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.go('/focus'),
          color: AppColors.textPrimary,
        ),
        title: Text(
          'Bilan du jour',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: planAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(
              'Erreur : $e',
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
          data: (plan) {
            final templateMap =
                templates.whenOrNull(
                  data: (t) => {for (final tmpl in t) tmpl.id: tmpl},
                ) ??
                {};

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SummaryHeader(
                    xp: xp,
                    lifeScore: lifeScore,
                    progress: progress,
                    completed: completed,
                    planned: planned,
                  ),
                  const Gap(AppSpacing.xl),
                  Text(
                    'Missions du jour',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(AppSpacing.md),
                  ...plan.missionInstances.map(
                    (m) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _MissionSummaryRow(
                        title: templateMap[m.templateId]?.title ?? m.templateId,
                        xp: templateMap[m.templateId]?.xpReward ?? 0,
                        status: m.status,
                      ),
                    ),
                  ),
                  const Gap(AppSpacing.xl),
                  FilledButton.icon(
                    onPressed: () => context.go('/focus'),
                    icon: const Icon(Icons.home_outlined),
                    label: const Text('Retour au Dashboard'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Summary header ─────────────────────────────────────────────────────────

class _SummaryHeader extends StatelessWidget {
  final int xp;
  final int lifeScore;
  final double progress;
  final int completed;
  final int planned;

  const _SummaryHeader({
    required this.xp,
    required this.lifeScore,
    required this.progress,
    required this.completed,
    required this.planned,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Stat(label: 'XP gagnés', value: '+$xp'),
              _Stat(label: 'Life Score', value: '$lifeScore%'),
              _Stat(label: 'Missions', value: '$completed/$planned'),
            ],
          ),
          const Gap(AppSpacing.lg),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: AppColors.surfaceHigh,
            color: AppColors.success,
          ),
          const Gap(AppSpacing.sm),
          Text(
            '${(progress * 100).round()}% de la journée accomplie',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// ── Mission summary row ───────────────────────────────────────────────────

class _MissionSummaryRow extends StatelessWidget {
  final String title;
  final int xp;
  final MissionStatus status;

  const _MissionSummaryRow({
    required this.title,
    required this.xp,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (status) {
      MissionStatus.completed => (Icons.check_circle, AppColors.success),
      MissionStatus.skipped => (Icons.skip_next, AppColors.textSecondary),
      MissionStatus.cancelled => (Icons.cancel_outlined, AppColors.danger),
      MissionStatus.inProgress => (Icons.hourglass_bottom, AppColors.warning),
      MissionStatus.scheduled => (
        Icons.radio_button_unchecked,
        AppColors.textMuted,
      ),
    };

    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const Gap(AppSpacing.sm),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: status == MissionStatus.completed
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ),
        if (status == MissionStatus.completed)
          Text(
            '+$xp XP',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}
