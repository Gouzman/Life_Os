import 'package:flutter/material.dart';

import '../../../../../core/extensions/build_context_x.dart';
import '../../../../../shared/animations/fade_in.dart';
import '../../../../../shared/cards/app_card.dart';
import '../../../tasks/domain/entities/task.dart';
import '../controllers/focus_mode_controller.dart';

/// En-tête affichant les informations de la tâche active en Focus Mode.
///
/// Ce widget ne contient aucune logique métier. Il reçoit un
/// [FocusModeState] et extrait la tâche pour afficher son titre, sa priorité
/// et sa durée prévue.
class FocusTaskHeader extends StatelessWidget {
  const FocusTaskHeader({super.key, required this.state});

  final FocusModeState state;

  @override
  Widget build(BuildContext context) {
    final task = _task;

    if (task == null) {
      return AppCard(
        child: Text(
          'Aucune tâche sélectionnée',
          style: context.text.bodyLarge?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return FadeIn(
      duration: const Duration(milliseconds: 400),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: context.text.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colors.onSurface,
                    ),
                  ),
                ),
                _PriorityBadge(priority: task.priority),
              ],
            ),
            if (task.description?.isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              Text(
                task.description!,
                style: context.text.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 18,
                  color: context.colors.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  _formatDuration(task.expectedDuration),
                  style: context.text.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Task? get _task => switch (state) {
    FocusModeRunning(task: final task) => task,
    FocusModePaused(task: final task) => task,
    FocusModeCompleted(task: final task) => task,
    FocusModeCancelled(task: final task) => task,
    FocusModeError(lastTask: final task) => task,
    FocusModeIdle() => null,
  };

  String _formatDuration(Duration duration) {
    final totalMinutes = duration.inMinutes;
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '$hours h $minutes min';
    }
    if (hours > 0) {
      return '$hours h';
    }
    return '$minutes min';
  }
}

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({required this.priority});

  final int priority;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'P${priority.clamp(0, 9)}',
        style: context.text.labelMedium?.copyWith(
          color: _color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color get _color {
    return switch (priority) {
      >= 7 => Colors.red,
      >= 4 => Colors.orange,
      _ => Colors.green,
    };
  }
}
