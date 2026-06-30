import 'dart:math' as math;

import '../../../../core/domain/value_objects/habit_frequency.dart';
import '../entities/mission_candidate.dart';
import '../entities/scored_mission_candidate.dart';

/// Calculates deterministic numeric priority for mission candidates.
class PriorityEngine {
  /// Creates a priority engine.
  const PriorityEngine();

  /// Scores [candidate] for the given [planningDate].
  double score({
    required MissionCandidate candidate,
    required DateTime planningDate,
  }) {
    final importanceScore = candidate.importance * 10.0;
    final urgencyScore = candidate.urgency * 8.0;
    final xpScore = math.sqrt(candidate.xpReward) * 4.0;
    final durationPenalty = candidate.duration.inMinutes / 12.0;
    final deadlineScore = _deadlineScore(candidate.targetDate, planningDate);
    final frequencyScore = _frequencyScore(candidate.frequency);
    final goalScore = (candidate.goalPriority ?? 0) * 3.0;
    final criticalBonus = candidate.critical ? 80.0 : 0.0;

    return importanceScore +
        urgencyScore +
        xpScore +
        deadlineScore +
        frequencyScore +
        goalScore +
        criticalBonus -
        durationPenalty;
  }

  /// Scores every [candidate] for [planningDate].
  List<ScoredMissionCandidate> scoreAll({
    required List<MissionCandidate> candidates,
    required DateTime planningDate,
  }) {
    return candidates
        .map(
          (candidate) => ScoredMissionCandidate(
            candidate: candidate,
            score: score(candidate: candidate, planningDate: planningDate),
          ),
        )
        .toList(growable: false);
  }

  /// Returns candidates ordered by score and deterministic tie breakers.
  List<ScoredMissionCandidate> sortByPriority(
    List<ScoredMissionCandidate> candidates,
  ) {
    return List<ScoredMissionCandidate>.of(candidates)..sort((a, b) {
      final criticalComparison = _compareBool(
        a.candidate.critical,
        b.candidate.critical,
      );
      if (criticalComparison != 0) {
        return criticalComparison;
      }

      final scoreComparison = b.score.compareTo(a.score);
      if (scoreComparison != 0) {
        return scoreComparison;
      }

      final importanceComparison = b.candidate.importance.compareTo(
        a.candidate.importance,
      );
      if (importanceComparison != 0) {
        return importanceComparison;
      }

      final urgencyComparison = b.candidate.urgency.compareTo(
        a.candidate.urgency,
      );
      if (urgencyComparison != 0) {
        return urgencyComparison;
      }

      final durationComparison = a.candidate.duration.compareTo(
        b.candidate.duration,
      );
      if (durationComparison != 0) {
        return durationComparison;
      }

      return a.candidate.id.compareTo(b.candidate.id);
    });
  }

  int _compareBool(bool a, bool b) {
    if (a == b) {
      return 0;
    }

    return a ? -1 : 1;
  }

  double _deadlineScore(DateTime? targetDate, DateTime planningDate) {
    if (targetDate == null) {
      return 0;
    }

    final normalizedPlanningDate = DateTime(
      planningDate.year,
      planningDate.month,
      planningDate.day,
    );
    final normalizedTargetDate = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );
    final days = normalizedTargetDate.difference(normalizedPlanningDate).inDays;

    if (days <= 0) {
      return 45;
    }

    if (days <= 1) {
      return 38;
    }

    if (days <= 7) {
      return 34 - (days * 3.5);
    }

    if (days <= 30) {
      return 12 - (days / 5);
    }

    return 0;
  }

  double _frequencyScore(HabitFrequency? frequency) {
    return switch (frequency) {
      HabitFrequency.daily => 14,
      HabitFrequency.weekdays => 11,
      HabitFrequency.weekly => 7,
      HabitFrequency.monthly => 4,
      HabitFrequency.custom => 5,
      null => 0,
    };
  }
}
