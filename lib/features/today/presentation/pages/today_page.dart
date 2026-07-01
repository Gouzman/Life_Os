import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/data/seed_data.dart';
import '../../../dashboard/presentation/providers/dashboard_providers.dart';
import '../../../planner/presentation/providers/planner_providers.dart';
import '../widgets/mission_detail_card.dart';

/// Dedicated screen showing the current mission before the user enters Focus Mode.
class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(dailyPlanProvider);
    final currentMission = ref.watch(currentMissionProvider);
    final currentTemplate = ref.watch(currentMissionTemplateProvider);
    final nextTemplate = ref.watch(nextMissionTemplateProvider);
    final progress = ref.watch(todayProgressProvider);
    final completed = ref.watch(completedMissionsCountProvider);
    final planned = ref.watch(plannedMissionsCountProvider);
    final xp = ref.watch(xpTodayProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
          color: AppColors.textPrimary,
        ),
        title: Text(
          "Aujourd'hui",
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
          data: (_) {
            if (currentMission == null || currentTemplate == null) {
              return _DayComplete(xp: xp);
            }

            final lifeAreaName =
                SeedData.lifeAreas
                    .where((a) => a.id == currentTemplate.lifeAreaId)
                    .map((a) => a.name)
                    .firstOrNull ??
                currentTemplate.lifeAreaId;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress bar
                  _ProgressBar(
                    progress: progress,
                    completed: completed,
                    planned: planned,
                    xp: xp,
                  ),
                  const Gap(AppSpacing.xl),

                  // Mission detail
                  MissionDetailCard(
                    mission: currentMission,
                    template: currentTemplate,
                    lifeAreaName: lifeAreaName,
                  ),

                  // Next mission hint
                  if (nextTemplate != null) ...[
                    const Gap(AppSpacing.xl),
                    _NextMissionHint(template: nextTemplate),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Progress bar ──────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  final double progress;
  final int completed;
  final int planned;
  final int xp;

  const _ProgressBar({
    required this.progress,
    required this.completed,
    required this.planned,
    required this.xp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$completed / $planned missions',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '+$xp XP',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Gap(AppSpacing.sm),
        LinearProgressIndicator(
          value: progress,
          minHeight: 8,
          borderRadius: BorderRadius.circular(8),
          backgroundColor: AppColors.surfaceHigh,
          color: AppColors.success,
        ),
      ],
    );
  }
}

// ── Next mission hint ─────────────────────────────────────────────────────

class _NextMissionHint extends StatelessWidget {
  final dynamic template;

  const _NextMissionHint({required this.template});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            const Icon(
              Icons.skip_next_outlined,
              color: AppColors.textSecondary,
              size: 20,
            ),
            const Gap(AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prochaine mission',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    template.title as String,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '+${template.xpReward} XP',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Day complete ──────────────────────────────────────────────────────────

class _DayComplete extends StatelessWidget {
  final int xp;

  const _DayComplete({required this.xp});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.emoji_events_outlined,
              color: AppColors.warning,
              size: 64,
            ),
            const Gap(AppSpacing.lg),
            Text(
              'Journee accomplie !',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(AppSpacing.sm),
            Text(
              'Vous avez gagne $xp XP aujourd\'hui.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const Gap(AppSpacing.xl),
            FilledButton.icon(
              onPressed: () => context.push('/daily-summary'),
              icon: const Icon(Icons.bar_chart),
              label: const Text('Voir le bilan'),
            ),
          ],
        ),
      ),
    );
  }
}
