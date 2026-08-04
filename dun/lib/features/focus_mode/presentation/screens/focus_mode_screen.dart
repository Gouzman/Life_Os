import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/build_context_x.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../shared/animations/fade_in.dart';
import '../../../../shared/loaders/app_loader.dart';
import '../../../tasks/presentation/providers/task_provider.dart';
import '../controllers/focus_mode_controller.dart';
import '../providers/focus_mode_provider.dart';
import '../widgets/focus_completion_overlay.dart';
import '../widgets/focus_controls.dart';
import '../widgets/focus_task_header.dart';
import '../widgets/focus_timer_ring.dart';

/// Écran immersif du Focus Mode.
///
/// Ce screen observe à la fois [taskProvider] pour connaître l'état de
/// chargement de la tâche et [focusModeControllerProvider] pour l'état enrichi
/// du Focus Mode (timer, progression).
///
/// Il ne contient aucune logique métier : toutes les actions sont déléguées au
/// [FocusModeController].
class FocusModeScreen extends ConsumerWidget {
  const FocusModeScreen({super.key, required this.taskId});

  /// Identifiant de la tâche à afficher en mode focus.
  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskProvider(taskId));
    final focusState = ref.watch(focusModeControllerProvider(taskId));
    final focusController = ref.read(
      focusModeControllerProvider(taskId).notifier,
    );

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Focus'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: taskAsync.when(
        loading: () => const Center(child: AppLoader()),
        error: (error, _) => _ErrorState(message: error.toString()),
        data: (task) {
          if (task == null) {
            return const _EmptyState(message: 'Tâche introuvable.');
          }

          return _FocusModeContent(
            focusState: focusState,
            onStart: focusController.start,
            onPause: focusController.pause,
            onResume: focusController.resume,
            onComplete: focusController.complete,
            onCancel: focusController.cancel,
          );
        },
      ),
    );
  }
}

class _FocusModeContent extends StatelessWidget {
  const _FocusModeContent({
    required this.focusState,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onComplete,
    required this.onCancel,
  });

  final FocusModeState focusState;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onComplete;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final isCompleted = focusState is FocusModeCompleted;

    return Stack(
      fit: StackFit.expand,
      children: [
        FadeIn(
          duration: const Duration(milliseconds: 400),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;

                return SingleChildScrollView(
                  padding: context.pagePadding,
                  child: isWide
                      ? _WideLayout(
                          focusState: focusState,
                          onStart: onStart,
                          onPause: onPause,
                          onResume: onResume,
                          onComplete: onComplete,
                          onCancel: onCancel,
                        )
                      : _NarrowLayout(
                          focusState: focusState,
                          onStart: onStart,
                          onPause: onPause,
                          onResume: onResume,
                          onComplete: onComplete,
                          onCancel: onCancel,
                        ),
                );
              },
            ),
          ),
        ),
        if (isCompleted)
          FocusCompletionOverlay(
            task: (focusState as FocusModeCompleted).task,
            onClose: onComplete,
          ),
      ],
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout({
    required this.focusState,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onComplete,
    required this.onCancel,
  });

  final FocusModeState focusState;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onComplete;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FocusTaskHeader(state: focusState),
        const SizedBox(height: 32),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: FocusTimerRing(
            key: ValueKey<FocusModeState>(focusState),
            state: focusState,
          ),
        ),
        const SizedBox(height: 40),
        FocusControls(
          state: focusState,
          onStart: onStart,
          onPause: onPause,
          onResume: onResume,
          onComplete: onComplete,
          onCancel: onCancel,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _WideLayout extends StatelessWidget {
  const _WideLayout({
    required this.focusState,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onComplete,
    required this.onCancel,
  });

  final FocusModeState focusState;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onComplete;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              FocusTaskHeader(state: focusState),
              const SizedBox(height: 24),
              FocusControls(
                state: focusState,
                onStart: onStart,
                onPause: onPause,
                onResume: onResume,
                onComplete: onComplete,
                onCancel: onCancel,
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 3,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: FocusTimerRing(
              key: ValueKey<FocusModeState>(focusState),
              state: focusState,
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeIn(
        child: Padding(
          padding: context.pagePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: context.colors.error),
              const SizedBox(height: 16),
              Text(
                'Une erreur est survenue',
                style: context.text.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: context.text.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeIn(
        child: Padding(
          padding: context.pagePadding,
          child: Text(
            message,
            style: context.text.bodyLarge?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
