import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_section_title.dart';
import '../providers/planner_providers.dart';

class PlannerPage extends ConsumerWidget {
  const PlannerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(dailyPlanProvider);
    final templatesAsync = ref.watch(missionTemplatesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: planAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              'Erreur de planification: $error',
              style: const TextStyle(color: AppColors.danger),
            ),
          ),
          data: (plan) => templatesAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            error: (error, stackTrace) => Center(
              child: Text(
                'Erreur de chargement des templates: $error',
                style: const TextStyle(color: AppColors.danger),
              ),
            ),
            data: (templates) => SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 840),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const AppSectionTitle(title: 'Plan du jour'),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Score: ${plan.dayScore}/100',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(AppSpacing.md),
                      
                      if (plan.missionInstances.isEmpty)
                        AppCard(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Text(
                              'Aucune mission générée pour aujourd\'hui. Profite de ton temps libre !',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
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
                            final energyName = template?.energyLevel.name ?? 'Standard';
                            
                            final startTime = mission.scheduledStart;
                            final endTime = mission.scheduledEnd;
                            final duration = endTime.difference(startTime).inMinutes;
                            
                            final timeString = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} - ${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';

                            return AppCard(
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                                title: Text(
                                  title,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    '$timeString • $duration min • Énergie: $energyName',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.play_circle_fill, size: 32),
                                  color: AppColors.primary,
                                  onPressed: () {
                                    // Navigation vers le Focus Mode
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
        ),
      ),
    );
  }
}
