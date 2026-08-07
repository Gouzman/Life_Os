import 'package:flutter/material.dart';

import '../../../../features/tasks/domain/entities/task.dart';
import 'history_day_section.dart';
import 'history_task_card.dart';

class HistoryTimeline extends StatelessWidget {
  const HistoryTimeline({super.key, required this.tasks});

  final List<Task> tasks;

  Map<DateTime, List<Task>> _groupByDay(List<Task> tasks) {
    final map = <DateTime, List<Task>>{};
    for (final task in tasks) {
      final day = DateTime(
        task.scheduledAt.year,
        task.scheduledAt.month,
        task.scheduledAt.day,
      );
      (map[day] ??= []).add(task);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByDay(tasks);
    final sortedDays = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedDays.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final day = sortedDays[index];
        final dayTasks = grouped[day]!;
        return HistoryDaySection(
          day: day,
          children: dayTasks
              .map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: HistoryTaskCard(task: t),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
