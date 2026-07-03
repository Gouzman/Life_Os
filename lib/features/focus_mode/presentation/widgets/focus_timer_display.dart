import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../app/theme/app_colors.dart';

class FocusTimerDisplay extends StatelessWidget {
  final Duration elapsed;
  final Duration planned;
  final bool isRunning;

  const FocusTimerDisplay({
    super.key,
    required this.elapsed,
    required this.planned,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    // Calcul de la progression entre 0.0 et 1.0
    final progress = planned.inSeconds == 0 
        ? 0.0 
        : (elapsed.inSeconds / planned.inSeconds).clamp(0.0, 1.0);

    final m = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = elapsed.inHours > 0 ? '${elapsed.inHours}h ' : '';

    return SizedBox(
      width: 280,
      height: 280,
      child: CustomPaint(
        painter: _GlowingDashedArcPainter(
          progress: progress,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.border.withValues(alpha: 0.3),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Temps écoulé',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const Gap(4),
              Text(
                '$h$m:$s',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(
                          color: AppColors.primary.withValues(alpha: 0.6),
                          blurRadius: 24,
                        ),
                      ],
                    ),
              ),
              const Gap(12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isRunning 
                      ? AppColors.primary.withValues(alpha: 0.15) 
                      : AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isRunning 
                        ? AppColors.primary.withValues(alpha: 0.5) 
                        : AppColors.warning.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  isRunning ? 'En cours' : 'En pause',
                  style: TextStyle(
                    color: isRunning ? AppColors.primaryLight : AppColors.warning,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlowingDashedArcPainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color inactiveColor;

  _GlowingDashedArcPainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const dashCount = 40; // Nombre de traits
    
    // Arc de cercle façon "compteur" (ouvert en bas)
    const startAngle = pi * 0.75; 
    const sweepAngle = pi * 1.5;

    for (int i = 0; i <= dashCount; i++) {
      final t = i / dashCount;
      final angle = startAngle + (sweepAngle * t);
      final isActive = t <= progress;

      final paint = Paint()
        ..color = isActive ? activeColor : inactiveColor
        ..strokeWidth = 4.5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      // Effet Neon (Glow) sur les traits actifs
      if (isActive) {
        paint.maskFilter = const MaskFilter.blur(BlurStyle.solid, 6);
      }

      // Taille des traits
      final innerRadius = radius - 24;
      final outerRadius = radius;
      
      final p1 = Offset(center.dx + innerRadius * cos(angle), center.dy + innerRadius * sin(angle));
      final p2 = Offset(center.dx + outerRadius * cos(angle), center.dy + outerRadius * sin(angle));

      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GlowingDashedArcPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.activeColor != activeColor ||
           oldDelegate.inactiveColor != inactiveColor;
  }
}
