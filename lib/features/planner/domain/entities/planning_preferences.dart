import '../../../../core/domain/value_objects/energy_level.dart';
import 'energy_period.dart';

/// User preferences and planner defaults used for a generated day.
class PlanningPreferences {
  /// Offset from midnight where the planner can start scheduling.
  final Duration dayStartOffset;

  /// Offset from midnight where the planner must stop scheduling.
  final Duration dayEndOffset;

  /// Minimal scheduling granularity used by the planner.
  final Duration schedulingGranularity;

  /// Default energy assigned to habit-generated mission candidates.
  final EnergyLevel defaultHabitEnergyLevel;

  /// Configurable energy profile for the day.
  final List<EnergyPeriod> energyPeriods;

  PlanningPreferences({
    required this.dayStartOffset,
    required this.dayEndOffset,
    required this.schedulingGranularity,
    required this.defaultHabitEnergyLevel,
    required List<EnergyPeriod> energyPeriods,
  }) : energyPeriods = List.unmodifiable(energyPeriods),
       assert(
         dayEndOffset > dayStartOffset,
         'dayEndOffset must be after dayStartOffset',
       ),
       assert(
         schedulingGranularity > Duration.zero,
         'schedulingGranularity must be positive',
       );

  /// Standard profile: 06:00-22:00 with high energy in the morning.
  factory PlanningPreferences.standard() {
    return PlanningPreferences(
      dayStartOffset: const Duration(hours: 6),
      dayEndOffset: const Duration(hours: 22),
      schedulingGranularity: const Duration(minutes: 15),
      defaultHabitEnergyLevel: EnergyLevel.medium,
      energyPeriods: [
        EnergyPeriod(
          startOffset: Duration(hours: 6),
          endOffset: Duration(hours: 10),
          energyLevel: EnergyLevel.high,
        ),
        EnergyPeriod(
          startOffset: Duration(hours: 10),
          endOffset: Duration(hours: 18),
          energyLevel: EnergyLevel.medium,
        ),
        EnergyPeriod(
          startOffset: Duration(hours: 18),
          endOffset: Duration(hours: 22),
          energyLevel: EnergyLevel.low,
        ),
      ],
    );
  }
}
