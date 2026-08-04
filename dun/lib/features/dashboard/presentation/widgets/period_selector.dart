import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/build_context_x.dart';
import '../models/dashboard_period.dart';
import '../providers/dashboard_controller_provider.dart';

/// Sélecteur de période permettant de basculer entre jour, semaine et mois.
///
/// Utilise [DashboardController] pour mettre à jour la période active.
class PeriodSelector extends ConsumerWidget {
  const PeriodSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(dashboardControllerProvider);
    final controller = ref.read(dashboardControllerProvider.notifier);

    return SegmentedButton<DashboardPeriod>(
      segments: const [
        ButtonSegment(
          value: DashboardPeriod.day,
          label: Text('Jour'),
          icon: Icon(Icons.today_outlined),
        ),
        ButtonSegment(
          value: DashboardPeriod.week,
          label: Text('Semaine'),
          icon: Icon(Icons.calendar_view_week_outlined),
        ),
        ButtonSegment(
          value: DashboardPeriod.month,
          label: Text('Mois'),
          icon: Icon(Icons.calendar_month_outlined),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (selection) {
        final period = selection.first;
        controller.setPeriod(period);
      },
      style: SegmentedButton.styleFrom(
        foregroundColor: context.colors.onSurfaceVariant,
        selectedForegroundColor: context.colors.onPrimary,
        selectedBackgroundColor: context.colors.primary,
      ),
    );
  }
}
