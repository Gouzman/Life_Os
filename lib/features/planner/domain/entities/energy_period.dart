import '../../../../core/domain/value_objects/energy_level.dart';

/// Represents an energy level available during a part of the day.
class EnergyPeriod {
  /// Offset from midnight where this energy period starts.
  final Duration startOffset;

  /// Offset from midnight where this energy period ends.
  final Duration endOffset;

  /// Energy level expected during this period.
  final EnergyLevel energyLevel;

  const EnergyPeriod({
    required this.startOffset,
    required this.endOffset,
    required this.energyLevel,
  }) : assert(
         endOffset >= startOffset,
         'endOffset must be after or equal to startOffset',
       );
}
