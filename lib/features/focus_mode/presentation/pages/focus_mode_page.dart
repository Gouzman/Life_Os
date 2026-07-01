import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:life_os/core/domain/value_objects/energy_level.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/data/seed_data.dart';
import '../../../dashboard/presentation/providers/dashboard_providers.dart';
import '../../../planner/presentation/providers/planner_providers.dart';
import '../providers/focus_mode_provider.dart';
import '../widgets/focus_timer_display.dart';

/// Full-screen Focus Mode.
///
/// Receives [missionId] via GoRouter extras.  Starts the timer automatically,
/// and delegates every state transition to the [DailyPlanNotifier] use-case
/// layer and to the [FocusModeNotifier].
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
    // Start the mission and the timer on entry.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(dailyPlanProvider.notifier).startMission(widget.missionId);
      ref.read(focusModeProvider.notifier).start(widget.missionId);
    });
  }

  Future<void> _onComplete() async {
    ref.read(focusModeProvider.notifier).reset();
    await ref
        .read(dailyPlanProvider.notifier)
        .completeMission(widget.missionId);
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
        content: const Text(
          'La mission sera annulee et ne comptera pas dans votre progression.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
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
    final template = ref.watch(currentMissionTemplateProvider);
    final planAsync = ref.watch(dailyPlanProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) {
          ref.read(focusModeProvider.notifier).pause();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Focus Mode',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              onPressed: _onAbandon,
              icon: const Icon(Icons.close, color: AppColors.danger),
              tooltip: 'Abandonner',
            ),
          ],
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
              if (template == null) {
                return const Center(child: Text('Mission introuvable.'));
              }

              final lifeAreaName =
                  SeedData.lifeAreas
                      .where((a) => a.id == template.lifeAreaId)
                      .map((a) => a.name)
                      .firstOrNull ??
                  template.lifeAreaId;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Mission info
                    _MissionBadge(
                      title: template.title,
                      lifeArea: lifeAreaName,
                      xp: template.xpReward,
                      energyLevel: template.energyLevel,
                    ),
                    const Spacer(),

                    // Timer
                    FocusTimerDisplay(
                      elapsed: focusState.elapsed,
                      isRunning: focusState.isRunning,
                    ),

                    const Gap(AppSpacing.lg),

                    // Progress within planned duration
                    _DurationProgress(
                      elapsed: focusState.elapsed,
                      planned: template.duration,
                    ),

                    const Spacer(),

                    // Action buttons
                    _ActionButtons(
                      isRunning: focusState.isRunning,
                      onPause: () =>
                          ref.read(focusModeProvider.notifier).pause(),
                      onResume: () =>
                          ref.read(focusModeProvider.notifier).resume(),
                      onComplete: _onComplete,
                      onSkip: _onSkip,
                    ),
                    const Gap(AppSpacing.xl),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ── Mission badge ─────────────────────────────────────────────────────────

class _MissionBadge extends StatelessWidget {
  final String title;
  final String lifeArea;
  final int xp;
  final EnergyLevel energyLevel;

  const _MissionBadge({
    required this.title,
    required this.lifeArea,
    required this.xp,
    required this.energyLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          lifeArea.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const Gap(AppSpacing.sm),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Gap(AppSpacing.sm),
        Text(
          '+$xp XP',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.warning,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ── Duration progress ─────────────────────────────────────────────────────

class _DurationProgress extends StatelessWidget {
  final Duration elapsed;
  final Duration planned;

  const _DurationProgress({required this.elapsed, required this.planned});

  @override
  Widget build(BuildContext context) {
    final progress = planned.inSeconds == 0
        ? 0.0
        : (elapsed.inSeconds / planned.inSeconds).clamp(0.0, 1.0);

    return Column(
      children: [
        LinearProgressIndicator(
          value: progress,
          minHeight: 6,
          borderRadius: BorderRadius.circular(8),
          backgroundColor: AppColors.surfaceHigh,
          color: AppColors.success,
        ),
        const Gap(AppSpacing.sm),
        Text(
          '${(progress * 100).round()}% de la duree prevue',
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

// ── Action buttons ────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onComplete;
  final VoidCallback onSkip;

  const _ActionButtons({
    required this.isRunning,
    required this.onPause,
    required this.onResume,
    required this.onComplete,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton.icon(
          onPressed: onComplete,
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Terminer la mission'),
        ),
        const Gap(AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isRunning ? onPause : onResume,
                icon: Icon(isRunning ? Icons.pause : Icons.play_arrow),
                label: Text(isRunning ? 'Pause' : 'Reprendre'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const Gap(AppSpacing.md),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onSkip,
                icon: const Icon(Icons.skip_next_outlined),
                label: const Text('Reporter'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
