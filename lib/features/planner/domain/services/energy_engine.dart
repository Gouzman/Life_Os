import '../../../../core/domain/value_objects/energy_level.dart';
import '../../../../core/domain/value_objects/preferred_period.dart';
import '../entities/mission_candidate.dart';
import '../entities/planning_preferences.dart';
import '../entities/time_window.dart';

/// Matches missions with the user's configurable daily energy profile.
class EnergyEngine {
  /// Creates an energy engine.
  const EnergyEngine();

  /// Returns the expected energy level at [time].
  EnergyLevel energyAt({
    required DateTime time,
    required PlanningPreferences preferences,
  }) {
    final offset = Duration(hours: time.hour, minutes: time.minute);

    for (final period in preferences.energyPeriods) {
      if (offset >= period.startOffset && offset < period.endOffset) {
        return period.energyLevel;
      }
    }

    return preferences.defaultHabitEnergyLevel;
  }

  /// Scores how well [candidate] fits when started at [start].
  double fitScore({
    required MissionCandidate candidate,
    required DateTime start,
    required PlanningPreferences preferences,
  }) {
    final energyScore = _energyScore(
      required: candidate.energyLevel,
      available: energyAt(time: start, preferences: preferences),
    );
    final periodScore = _preferredPeriodScore(candidate.preferredPeriod, start);

    return energyScore + periodScore;
  }

  /// Returns the best deterministic start inside [window] for [candidate].
  DateTime? bestStartInWindow({
    required MissionCandidate candidate,
    required TimeWindow window,
    required PlanningPreferences preferences,
  }) {
    if (!window.canFit(candidate.duration)) {
      return null;
    }

    final candidates = <DateTime>{window.start};
    final preferredStart = _preferredPeriodStart(
      date: window.start,
      period: candidate.preferredPeriod,
    );

    if (preferredStart != null &&
        !preferredStart.isBefore(window.start) &&
        !preferredStart.add(candidate.duration).isAfter(window.end)) {
      candidates.add(preferredStart);
    }

    DateTime? best;
    var bestScore = double.negativeInfinity;

    for (final start in candidates) {
      final score = fitScore(
        candidate: candidate,
        start: start,
        preferences: preferences,
      );

      if (score > bestScore ||
          (score == bestScore && (best == null || start.isBefore(best)))) {
        best = start;
        bestScore = score;
      }
    }

    return best;
  }

  double _energyScore({
    required EnergyLevel required,
    required EnergyLevel available,
  }) {
    final distance = (required.index - available.index).abs();

    return switch (distance) {
      0 => 36,
      1 => 16,
      _ => 0,
    };
  }

  double _preferredPeriodScore(PreferredPeriod period, DateTime start) {
    if (period == PreferredPeriod.anytime) {
      return 8;
    }

    final hour = start.hour + (start.minute / 60);

    return switch (period) {
      PreferredPeriod.dawn => hour >= 4 && hour < 7 ? 24 : 0,
      PreferredPeriod.morning => hour >= 6 && hour < 12 ? 24 : 0,
      PreferredPeriod.afternoon => hour >= 12 && hour < 18 ? 24 : 0,
      PreferredPeriod.evening => hour >= 18 && hour < 22 ? 24 : 0,
      PreferredPeriod.night => hour >= 21 || hour < 4 ? 24 : 0,
      PreferredPeriod.anytime => 8,
    };
  }

  DateTime? _preferredPeriodStart({
    required DateTime date,
    required PreferredPeriod period,
  }) {
    final midnight = DateTime(date.year, date.month, date.day);

    return switch (period) {
      PreferredPeriod.dawn => midnight.add(const Duration(hours: 6)),
      PreferredPeriod.morning => midnight.add(const Duration(hours: 8)),
      PreferredPeriod.afternoon => midnight.add(const Duration(hours: 14)),
      PreferredPeriod.evening => midnight.add(const Duration(hours: 19)),
      PreferredPeriod.night => midnight.add(const Duration(hours: 21)),
      PreferredPeriod.anytime => null,
    };
  }
}
