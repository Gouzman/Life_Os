import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:life_os/app/theme/app_spacing.dart';
import 'package:life_os/core/data/seed_data.dart';
import 'package:life_os/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:life_os/features/dashboard/presentation/widgets/hero_mission_card.dart';
import 'package:life_os/features/dashboard/presentation/widgets/life_score_card.dart';
import 'package:life_os/features/planner/presentation/providers/planner_providers.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyPlanAsync = ref.watch(dailyPlanProvider);
    final lifeScore = ref.watch(lifeScoreProvider);
    final currentMission = ref.watch(currentMissionProvider);
    final currentTemplate = ref.watch(currentMissionTemplateProvider);
    final isWideScreen = MediaQuery.of(context).size.width > 760;

    return Scaffold(
      body: SafeArea(
        child: dailyPlanAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Erreur: $error')),
          data: (dailyPlan) {
            // Check if day is complete (no current mission)
            if (currentMission == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('🎉', style: Theme.of(context).textTheme.displayLarge),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Jour terminé!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () => context.go('/daily-summary'),
                      child: const Text('Voir le résumé'),
                    ),
                  ],
                ),
              );
            }

            // Wide screen layout: hero card (2/3) + score card (1/3)
            if (isWideScreen) {
              final lifeAreaName = currentTemplate != null
                  ? SeedData.lifeAreas
                        .firstWhere((a) => a.id == currentTemplate.lifeAreaId)
                        .name
                  : '';
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: currentTemplate != null
                          ? HeroMissionCard(
                              mission: currentMission,
                              template: currentTemplate,
                              lifeAreaName: lifeAreaName,
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(flex: 1, child: LifeScoreCard(score: lifeScore)),
                  ],
                ),
              );
            }

            // Narrow screen layout: stacked
            final lifeAreaName = currentTemplate != null
                ? SeedData.lifeAreas
                      .firstWhere((a) => a.id == currentTemplate.lifeAreaId)
                      .name
                : '';
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  currentTemplate != null
                      ? HeroMissionCard(
                          mission: currentMission,
                          template: currentTemplate,
                          lifeAreaName: lifeAreaName,
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: AppSpacing.lg),
                  LifeScoreCard(score: lifeScore),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
