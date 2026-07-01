import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

/// Displays elapsed time as MM:SS in a large hero style.
class FocusTimerDisplay extends StatelessWidget {
  final Duration elapsed;
  final bool isRunning;

  const FocusTimerDisplay({
    super.key,
    required this.elapsed,
    required this.isRunning,
  });

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _format(elapsed),
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: isRunning ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: FontWeight.w800,
            letterSpacing: 4,
          ),
        ),
        const Gap(AppSpacing.xs),
        Text(
          isRunning ? 'En cours' : 'En pause',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: isRunning ? AppColors.success : AppColors.textMuted,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
