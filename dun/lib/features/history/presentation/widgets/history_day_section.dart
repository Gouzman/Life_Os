import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/build_context_x.dart';

class HistoryDaySection extends StatelessWidget {
  const HistoryDaySection({
    super.key,
    required this.day,
    required this.children,
  });

  final DateTime day;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: context.colors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDay(day),
                style: context.text.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.onSurface,
                ),
              ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }

  static String _formatDay(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(day.year, day.month, day.day);
    final diff = today.difference(d).inDays;

    if (diff == 0) return "Aujourd'hui";
    if (diff == 1) return 'Hier';
    if (diff < 7) return _weekdayName(d.weekday);
    return DateFormat('d MMM').format(d);
  }

  static String _weekdayName(int weekday) => switch (weekday) {
    1 => 'Lundi',
    2 => 'Mardi',
    3 => 'Mercredi',
    4 => 'Jeudi',
    5 => 'Vendredi',
    6 => 'Samedi',
    7 => 'Dimanche',
    _ => '',
  };
}
