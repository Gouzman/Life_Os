import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../planner/presentation/providers/planner_providers.dart';
import '../providers/focus_mode_provider.dart';
import '../widgets/focus_timer_display.dart';

class FocusModePage extends ConsumerStatefulWidget {
  final String missionId;

  const FocusModePage({super.key, required this.missionId});

  @override
  ConsumerState<FocusModePage> createState() => _FocusModePageState();
}

class _FocusModePageState extends ConsumerState<FocusModePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(dailyPlanProvider.notifier).startMission(widget.missionId);
      ref.read(focusModeProvider.notifier).start(widget.missionId);
    });
  }

  Future<void> _onComplete() async {
    ref.read(focusModeProvider.notifier).reset();
    await ref.read(dailyPlanProvider.notifier).completeMission(widget.missionId);
    if (mounted) context.pop();
  }

  Future<void> _onSkip() async {
    ref.read(focusModeProvider.notifier).reset();
    await ref.read(dailyPlanProvider.notifier).skipMission(widget.missionId);
    if (mounted) context.pop();
  }

  Future<void> _onAbandon() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Abandonner la mission ?'),
        content: const Text('La mission sera annulée et ne comptera pas dans votre progression.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Abandonner'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    ref.read(focusModeProvider.notifier).reset();
    await ref.read(dailyPlanProvider.notifier).abandonMission(widget.missionId);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final focusState = ref.watch(focusModeProvider);
    final planAsync = ref.watch(dailyPlanProvider);
    final templatesAsync = ref.watch(missionTemplatesProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) ref.read(focusModeProvider.notifier).pause();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 16),
              decoration: const BoxDecoration(
                color: AppColors.surfaceHigh,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _onAbandon,
                icon: const Icon(Icons.close, color: AppColors.textSecondary, size: 20),
              ),
            ),
          ],
        ),
        body: planAsync.when(
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('Erreur : $e', style: const TextStyle(color: AppColors.danger))),
          data: (plan) {
            final instance = plan.missionInstances.where((m) => m.id == widget.missionId).firstOrNull;
            if (instance == null) return const Center(child: Text('Instance introuvable.'));

            return templatesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (e, _) => Center(child: Text('Erreur : $e', style: const TextStyle(color: AppColors.danger))),
              data: (templates) {
                final template = templates.where((t) => t.id == instance.templateId).firstOrNull;
                final title = template?.title ?? 'Mission Active';
                final xpReward = template?.xpReward ?? 10;
                final plannedDuration = template?.duration ?? instance.scheduledEnd.difference(instance.scheduledStart);

                // MAGIE FLUTTER: Cette structure gère l'overflow SANS supprimer le Spacer()
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                            child: Column(
                              children: [
                                const Gap(AppSpacing.xl),
                                // La grande carte centrale sombre
                                AppCard(
                                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: AppColors.background,
                                          borderRadius: BorderRadius.circular(30),
                                          border: Border.all(color: AppColors.border),
                                        ),
                                        child: Text(
                                          title,
                                          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      
                                      const Gap(40),
                                      
                                      // Le Timer Neon
                                      FocusTimerDisplay(
                                        elapsed: focusState.elapsed,
                                        planned: plannedDuration,
                                        isRunning: focusState.isRunning,
                                      ),
                                      
                                      const Gap(40),
                                      
                                      // Badge XP
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: AppColors.background,
                                          borderRadius: BorderRadius.circular(30),
                                          border: Border.all(color: AppColors.border),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.stars_rounded, color: AppColors.warning, size: 20),
                                            const Gap(8),
                                            Text(
                                              '+$xpReward XP',
                                              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                const Spacer(), // Préservé ! Agit comme un ressort flexible
                                
                                // Boutons d'action
                                _buildActionButtons(focusState.isRunning),
                                const Gap(AppSpacing.xl),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            );
          },
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isRunning) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: _onComplete,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Terminer la mission', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
        ),
        const Gap(AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () => isRunning ? ref.read(focusModeProvider.notifier).pause() : ref.read(focusModeProvider.notifier).resume(),
                  icon: Icon(isRunning ? Icons.pause : Icons.play_arrow, color: AppColors.textPrimary),
                  label: Text(isRunning ? 'Pause' : 'Reprendre', style: const TextStyle(color: AppColors.textPrimary)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ),
            const Gap(AppSpacing.md),
            Expanded(
              child: SizedBox(
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: _onSkip,
                  icon: const Icon(Icons.skip_next_outlined, color: AppColors.textSecondary),
                  label: const Text('Reporter', style: TextStyle(color: AppColors.textSecondary)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
