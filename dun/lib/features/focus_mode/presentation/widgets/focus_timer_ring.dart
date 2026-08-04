import 'package:flutter/material.dart';

import '../../../../../core/extensions/build_context_x.dart';
import '../../../../../shared/animations/fade_in.dart';
import '../controllers/focus_mode_controller.dart';

/// Anneau de progression animé affichant le temps écoulé, restant et la
/// progression du Focus Mode.
///
/// Ce widget ne contient aucune logique métier. Il reçoit uniquement un
/// [FocusModeState] et s'adapte visuellement selon l'état.
class FocusTimerRing extends StatelessWidget {
  const FocusTimerRing({super.key, required this.state});

  final FocusModeState state;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final progress = _progress;
    final elapsed = _elapsed;
    final remaining = _remaining;

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            builder: (context, value, _) {
              return CircularProgressIndicator(
                value: value,
                strokeWidth: 12,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _progressColor(context, value),
                ),
              );
            },
          ),
          Center(
            child: FadeIn(
              duration: const Duration(milliseconds: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatDuration(elapsed),
                    style: context.text.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'reste ${_formatDuration(remaining)}',
                    style: context.text.bodyMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double get _progress => switch (state) {
    FocusModeRunning(progress: final progress) => progress,
    FocusModePaused(progress: final progress) => progress,
    _ => 0,
  };

  Duration get _elapsed => switch (state) {
    FocusModeRunning(elapsed: final elapsed) => elapsed,
    FocusModePaused(elapsed: final elapsed) => elapsed,
    _ => Duration.zero,
  };

  Duration get _remaining => switch (state) {
    FocusModeRunning(remaining: final remaining) => remaining,
    FocusModePaused(remaining: final remaining) => remaining,
    _ => Duration.zero,
  };

  Color _progressColor(BuildContext context, double value) {
    if (value >= 1) return context.colors.error;
    if (value >= 0.75) return context.colors.tertiary;
    return context.colors.primary;
  }

  String _formatDuration(Duration duration) {
    final totalSeconds = duration.inSeconds.abs();
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    final buffer = StringBuffer();
    if (hours > 0) {
      buffer.write('${hours.toString().padLeft(2, '0')}:');
    }
    buffer
      ..write('${minutes.toString().padLeft(2, '0')}:')
      ..write(seconds.toString().padLeft(2, '0'));

    return buffer.toString();
  }
}
