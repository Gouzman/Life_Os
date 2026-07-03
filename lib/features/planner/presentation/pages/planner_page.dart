import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../providers/planner_providers.dart';

class PlannerPage extends ConsumerWidget {
  const PlannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(dailyPlanProvider);
    final templatesAsync = ref.watch(missionTemplatesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Plan d'Aujourd'hui",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
      ),
      body: SafeArea(
        child: planAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (error, _) => Center(child: Text('Erreur: $error', style: const TextStyle(color: AppColors.danger))),
          data: (plan) => templatesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
            error: (error, _) => Center(child: Text('Erreur: $error', style: const TextStyle(color: AppColors.danger))),
            data: (templates) => SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (plan.missionInstances.isEmpty)
                    AppCard(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Text(
                          'Aucune mission générée. Temps libre !',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: plan.missionInstances.length,
                      separatorBuilder: (context, index) => const Gap(AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final mission = plan.missionInstances[index];
                        final template = templates.where((t) => t.id == mission.templateId).firstOrNull;
                        
                        final title = template?.title ?? 'Mission de Routine';
                        final xp = template?.xpReward ?? 0;
                        
                        return AppCard(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            title: Text(
                              title,
                              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                            ),
                            subtitle: Text(
                              '+$xp XP',
                              style: const TextStyle(color: AppColors.warning, fontWeight: FontWeight.bold),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.play_circle_fill, size: 36),
                              color: AppColors.primary,
                              onPressed: () {
                                context.push('/focus-mode', extra: {'missionId': mission.id});
                              },
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


