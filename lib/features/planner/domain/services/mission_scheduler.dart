import '../algorithms/time_window_algorithms.dart';
import '../entities/schedule_result.dart';
import '../entities/scored_mission_candidate.dart';
import '../entities/time_window.dart';
import '../../../missions/domain/entities/mission_instance.dart';
import 'energy_engine.dart';
import '../entities/planning_preferences.dart';

/// Places scored mission candidates into available time windows.
class MissionScheduler {
  /// Engine used to match candidates with energy windows.
  final EnergyEngine energyEngine;

  /// Creates a scheduler.
  const MissionScheduler({this.energyEngine = const EnergyEngine()});

  /// Schedules [candidates] inside [availableWindows].
  ScheduleResult schedule({
    required DateTime date,
    required List<ScoredMissionCandidate> candidates,
    required List<TimeWindow> availableWindows,
    required PlanningPreferences preferences,
  }) {
    var remainingWindows = TimeWindowAlgorithms.sort(availableWindows);
    final scheduled = <MissionInstance>[];
    final unscheduled = <String>[];

    for (final scoredCandidate in candidates) {
      final placement = _findBestPlacement(
        scoredCandidate: scoredCandidate,
        availableWindows: remainingWindows,
        preferences: preferences,
      );

      if (placement == null) {
        unscheduled.add(scoredCandidate.candidate.templateId);
        continue;
      }

      final scheduledWindow = TimeWindow(
        start: placement.start,
        end: placement.start.add(scoredCandidate.candidate.duration),
      );

      scheduled.add(
        MissionInstance(
          id: _missionInstanceId(date, scoredCandidate.candidate.id),
          templateId: scoredCandidate.candidate.templateId,
          scheduledStart: scheduledWindow.start,
          scheduledEnd: scheduledWindow.end,
        ),
      );
      remainingWindows = TimeWindowAlgorithms.subtractOne(
        available: remainingWindows,
        occupied: scheduledWindow,
      );
    }

    scheduled.sort((a, b) => a.scheduledStart.compareTo(b.scheduledStart));

    return ScheduleResult(
      missionInstances: scheduled,
      unscheduledTemplateIds: unscheduled,
      remainingFreeTime: _remainingFreeTime(remainingWindows),
    );
  }

  _Placement? _findBestPlacement({
    required ScoredMissionCandidate scoredCandidate,
    required List<TimeWindow> availableWindows,
    required PlanningPreferences preferences,
  }) {
    _Placement? best;

    for (final window in availableWindows) {
      final start = energyEngine.bestStartInWindow(
        candidate: scoredCandidate.candidate,
        window: window,
        preferences: preferences,
      );

      if (start == null) {
        continue;
      }

      final energyFit = energyEngine.fitScore(
        candidate: scoredCandidate.candidate,
        start: start,
        preferences: preferences,
      );
      final score = scoredCandidate.score + energyFit;
      final placement = _Placement(start: start, score: score);

      if (best == null ||
          placement.score > best.score ||
          (placement.score == best.score &&
              placement.start.isBefore(best.start))) {
        best = placement;
      }
    }

    return best;
  }

  Duration _remainingFreeTime(List<TimeWindow> windows) {
    return windows.fold(
      Duration.zero,
      (total, window) => total + window.duration,
    );
  }

  String _missionInstanceId(DateTime date, String candidateId) {
    final dateKey =
        '${date.year.toString().padLeft(4, '0')}'
        '${date.month.toString().padLeft(2, '0')}'
        '${date.day.toString().padLeft(2, '0')}';

    return '$dateKey-$candidateId';
  }
}

class _Placement {
  final DateTime start;
  final double score;

  const _Placement({required this.start, required this.score});
}
