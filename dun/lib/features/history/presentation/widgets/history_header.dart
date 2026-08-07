import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/build_context_x.dart';
import '../../../../shared/animations/fade_in.dart';

class HistoryHeader extends StatelessWidget {
  const HistoryHeader({super.key, required this.taskCount});

  final int taskCount;

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Historique',
            style: context.text.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat.yMMMMEEEEd().format(DateTime.now()),
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$taskCount tâche${taskCount != 1 ? 's' : ''}',
            style: context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
