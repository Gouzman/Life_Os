import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/build_context_x.dart';
import '../providers/history_filter_provider.dart';

class HistoryFilterBar extends ConsumerWidget {
  const HistoryFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(historyFilterProvider);
    final notifier = ref.read(historyFilterProvider.notifier);

    return Wrap(
      spacing: 8,
      children: HistoryFilter.values
          .map(
            (filter) => FilterChip(
              label: Text(_label(filter)),
              selected: selected == filter,
              onSelected: (_) => notifier.select(filter),
              selectedColor: context.colors.primaryContainer,
              checkmarkColor: context.colors.onPrimaryContainer,
              labelStyle: TextStyle(
                color: selected == filter
                    ? context.colors.onPrimaryContainer
                    : context.colors.onSurfaceVariant,
                fontWeight: selected == filter
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          )
          .toList(),
    );
  }

  String _label(HistoryFilter filter) => switch (filter) {
    HistoryFilter.today => "Aujourd'hui",
    HistoryFilter.week => 'Semaine',
    HistoryFilter.month => 'Mois',
    HistoryFilter.custom => 'Personnalisé',
  };
}
