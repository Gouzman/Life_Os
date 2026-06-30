import 'package:flutter_test/flutter_test.dart';
import 'package:life_os/core/domain/value_objects/energy_level.dart';
import 'package:life_os/core/domain/value_objects/habit_frequency.dart';
import 'package:life_os/core/domain/value_objects/preferred_period.dart';
import 'package:life_os/features/goals/domain/entities/goal.dart';
import 'package:life_os/features/habits/domain/entities/habit.dart';
import 'package:life_os/features/missions/domain/entities/mission_template.dart';
import 'package:life_os/features/planner/domain/entities/fixed_event.dart';
import 'package:life_os/features/planner/domain/entities/mission_candidate.dart';
import 'package:life_os/features/planner/domain/entities/planner_input.dart';
import 'package:life_os/features/planner/domain/entities/planning_preferences.dart';
import 'package:life_os/features/planner/domain/entities/scored_mission_candidate.dart';
import 'package:life_os/features/planner/domain/entities/time_window.dart';
import 'package:life_os/features/planner/domain/services/constraint_engine.dart';
import 'package:life_os/features/planner/domain/services/energy_engine.dart';
import 'package:life_os/features/planner/domain/services/mission_scheduler.dart';
import 'package:life_os/features/planner/domain/services/planner_engine.dart';
import 'package:life_os/features/planner/domain/services/priority_engine.dart';

void main() {
  final date = DateTime(2026, 7, 1);
  final preferences = PlanningPreferences.standard();

  group('ConstraintEngine', () {
    const engine = ConstraintEngine();

    test('returns the full day when the day is empty', () {
      final day = _window(date, 6, 22);

      final result = engine.freeWindows(dayWindow: day, fixedEvents: const []);

      expect(result, hasLength(1));
      expect(result.single.start, day.start);
      expect(result.single.end, day.end);
    });

    test('returns no free window when the day is complete', () {
      final day = _window(date, 6, 22);

      final result = engine.freeWindows(
        dayWindow: day,
        fixedEvents: [_fixed(date, 6, 22)],
      );

      expect(result, isEmpty);
    });

    test('merges overlapping fixed events when calculating free time', () {
      final day = _window(date, 6, 22);

      final result = engine.freeWindows(
        dayWindow: day,
        fixedEvents: [_fixed(date, 8, 10), _fixed(date, 9, 11)],
      );

      expect(result, hasLength(2));
      expect(result.first, _matchesWindow(date, 6, 8));
      expect(result.last, _matchesWindow(date, 11, 22));
    });
  });

  group('PriorityEngine', () {
    const engine = PriorityEngine();

    test('scores a more important mission above a less important one', () {
      final high = _candidate(id: 'high', importance: 10, urgency: 8);
      final low = _candidate(id: 'low', importance: 3, urgency: 3);

      expect(
        engine.score(candidate: high, planningDate: date),
        greaterThan(engine.score(candidate: low, planningDate: date)),
      );
    });

    test('uses deterministic tie breakers for equal scores', () {
      final result = engine.sortByPriority([
        ScoredMissionCandidate(candidate: _candidate(id: 'b'), score: 100),
        ScoredMissionCandidate(candidate: _candidate(id: 'a'), score: 100),
      ]);

      expect(result.first.candidate.id, 'a');
      expect(result.last.candidate.id, 'b');
    });

    test('boosts missions related to a close deadline', () {
      final close = _candidate(
        id: 'close',
        targetDate: date.add(const Duration(days: 1)),
      );
      final far = _candidate(
        id: 'far',
        targetDate: date.add(const Duration(days: 60)),
      );

      expect(
        engine.score(candidate: close, planningDate: date),
        greaterThan(engine.score(candidate: far, planningDate: date)),
      );
    });

    test('penalizes long duration when other factors are equal', () {
      final short = _candidate(id: 'short', duration: const Duration(hours: 1));
      final long = _candidate(id: 'long', duration: const Duration(hours: 4));

      expect(
        engine.score(candidate: short, planningDate: date),
        greaterThan(engine.score(candidate: long, planningDate: date)),
      );
    });
  });

  group('EnergyEngine', () {
    const engine = EnergyEngine();

    test('matches high-energy missions with the morning energy profile', () {
      final morning = DateTime(2026, 7, 1, 8);

      expect(
        engine.energyAt(time: morning, preferences: preferences),
        EnergyLevel.high,
      );
      expect(
        engine.fitScore(
          candidate: _candidate(energyLevel: EnergyLevel.high),
          start: morning,
          preferences: preferences,
        ),
        greaterThan(
          engine.fitScore(
            candidate: _candidate(energyLevel: EnergyLevel.low),
            start: morning,
            preferences: preferences,
          ),
        ),
      );
    });

    test('matches low-energy missions with the evening energy profile', () {
      final evening = DateTime(2026, 7, 1, 21);

      expect(
        engine.energyAt(time: evening, preferences: preferences),
        EnergyLevel.low,
      );
      expect(
        engine.fitScore(
          candidate: _candidate(energyLevel: EnergyLevel.low),
          start: evening,
          preferences: preferences,
        ),
        greaterThan(
          engine.fitScore(
            candidate: _candidate(energyLevel: EnergyLevel.high),
            start: evening,
            preferences: preferences,
          ),
        ),
      );
    });
  });

  group('MissionScheduler', () {
    const priorityEngine = PriorityEngine();
    const scheduler = MissionScheduler();

    test('leaves every mission unscheduled when the day is complete', () {
      final result = scheduler.schedule(
        date: date,
        candidates: [_scored(_candidate(id: 'a'))],
        availableWindows: const [],
        preferences: preferences,
      );

      expect(result.missionInstances, isEmpty);
      expect(result.unscheduledTemplateIds, ['a']);
    });

    test('leaves a mission unscheduled when the day is insufficient', () {
      final result = scheduler.schedule(
        date: date,
        candidates: [
          _scored(
            _candidate(id: 'too-long', duration: const Duration(hours: 2)),
          ),
        ],
        availableWindows: [_window(date, 8, 9)],
        preferences: preferences,
      );

      expect(result.missionInstances, isEmpty);
      expect(result.unscheduledTemplateIds, ['too-long']);
    });

    test('does not create conflicting mission windows', () {
      final ordered = priorityEngine.sortByPriority([
        _scored(_candidate(id: 'a')),
        _scored(_candidate(id: 'b')),
      ]);

      final result = scheduler.schedule(
        date: date,
        candidates: ordered,
        availableWindows: [_window(date, 8, 9)],
        preferences: preferences,
      );

      expect(result.missionInstances, hasLength(1));
      expect(result.unscheduledTemplateIds, hasLength(1));
    });

    test('schedules a critical mission before a flexible normal mission', () {
      final ordered = priorityEngine.sortByPriority([
        ScoredMissionCandidate(candidate: _candidate(id: 'normal'), score: 200),
        ScoredMissionCandidate(
          candidate: _candidate(id: 'critical', critical: true),
          score: 100,
        ),
      ]);

      final result = scheduler.schedule(
        date: date,
        candidates: ordered,
        availableWindows: [_window(date, 8, 9)],
        preferences: preferences,
      );

      expect(result.missionInstances.single.templateId, 'critical');
      expect(result.unscheduledTemplateIds, ['normal']);
    });

    test('schedules a flexible mission in the first valid slot', () {
      final result = scheduler.schedule(
        date: date,
        candidates: [
          _scored(_candidate(id: 'flexible', period: PreferredPeriod.anytime)),
        ],
        availableWindows: [_window(date, 13, 15)],
        preferences: preferences,
      );

      expect(result.missionInstances.single.scheduledStart.hour, 13);
    });
  });

  group('PlannerEngine', () {
    const engine = PlannerEngine();

    test('generates a complete daily plan', () {
      final plan = engine.generate(
        PlannerInput(
          date: date,
          missionTemplates: [
            _template(
              id: 'flutter',
              duration: const Duration(hours: 2),
              energyLevel: EnergyLevel.high,
            ),
          ],
          habits: [_habit(id: 'prayer', duration: const Duration(minutes: 30))],
          goals: [_goal(targetDate: date.add(const Duration(days: 7)))],
          routines: const [],
          fixedEvents: [_fixed(date, 10, 17)],
          preferences: preferences,
        ),
      );

      expect(plan.missionInstances, hasLength(2));
      expect(plan.unscheduledTemplateIds, isEmpty);
      expect(plan.dayScore, 100);
      expect(
        _isOrdered(
          plan.missionInstances.map((mission) => mission.scheduledStart),
        ),
        isTrue,
      );
    });

    test('supports a user without habits', () {
      final plan = engine.generate(
        PlannerInput(
          date: date,
          missionTemplates: [_template(id: 'deep-work')],
          habits: const [],
          goals: [_goal()],
          routines: const [],
          fixedEvents: const [],
          preferences: preferences,
        ),
      );

      expect(plan.missionInstances, hasLength(1));
    });

    test('supports a user without goals', () {
      final plan = engine.generate(
        PlannerInput(
          date: date,
          missionTemplates: [_template(id: 'admin')],
          habits: [_habit(id: 'reading')],
          goals: const [],
          routines: const [],
          fixedEvents: const [],
          preferences: preferences,
        ),
      );

      expect(plan.missionInstances, hasLength(2));
    });

    test('returns unscheduled missions for an overloaded day', () {
      final plan = engine.generate(
        PlannerInput(
          date: date,
          missionTemplates: [
            _template(id: 'a', duration: const Duration(hours: 8)),
            _template(id: 'b', duration: const Duration(hours: 8)),
            _template(id: 'c', duration: const Duration(hours: 8)),
          ],
          habits: const [],
          goals: const [],
          routines: const [],
          fixedEvents: const [],
          preferences: preferences,
        ),
      );

      expect(plan.missionInstances, hasLength(2));
      expect(plan.unscheduledTemplateIds, hasLength(1));
      expect(plan.dayScore, lessThan(100));
    });

    test(
      'returns an empty high-quality plan for a free day without candidates',
      () {
        final plan = engine.generate(
          PlannerInput(
            date: date,
            missionTemplates: const [],
            habits: const [],
            goals: const [],
            routines: const [],
            fixedEvents: const [],
            preferences: preferences,
          ),
        );

        expect(plan.missionInstances, isEmpty);
        expect(plan.remainingFreeTime, const Duration(hours: 16));
        expect(plan.dayScore, 100);
      },
    );

    test(
      'keeps one critical mission unscheduled when two critical missions conflict',
      () {
        final plan = engine.generate(
          PlannerInput(
            date: date,
            missionTemplates: [
              _template(
                id: 'critical-a',
                duration: const Duration(hours: 10),
                critical: true,
              ),
              _template(
                id: 'critical-b',
                duration: const Duration(hours: 10),
                critical: true,
              ),
            ],
            habits: const [],
            goals: const [],
            routines: const [],
            fixedEvents: [_fixed(date, 16, 22)],
            preferences: preferences,
          ),
        );

        expect(plan.missionInstances, hasLength(1));
        expect(plan.unscheduledTemplateIds, hasLength(1));
      },
    );
  });
}

TimeWindow _window(DateTime date, int startHour, int endHour) {
  return TimeWindow(
    start: DateTime(date.year, date.month, date.day, startHour),
    end: DateTime(date.year, date.month, date.day, endHour),
  );
}

FixedEvent _fixed(DateTime date, int startHour, int endHour) {
  return FixedEvent(
    id: '$startHour-$endHour',
    title: 'Fixed event',
    type: FixedEventType.custom,
    window: _window(date, startHour, endHour),
  );
}

MissionCandidate _candidate({
  String id = 'candidate',
  Duration duration = const Duration(hours: 1),
  int xpReward = 80,
  EnergyLevel energyLevel = EnergyLevel.medium,
  int importance = 5,
  int urgency = 5,
  PreferredPeriod period = PreferredPeriod.anytime,
  DateTime? targetDate,
  bool critical = false,
}) {
  return MissionCandidate(
    id: id,
    templateId: id,
    title: id,
    duration: duration,
    xpReward: xpReward,
    energyLevel: energyLevel,
    importance: importance,
    urgency: urgency,
    preferredPeriod: period,
    lifeAreaId: 'business',
    source: MissionCandidateSource.template,
    frequency: HabitFrequency.weekly,
    targetDate: targetDate,
    critical: critical,
  );
}

ScoredMissionCandidate _scored(MissionCandidate candidate) {
  return ScoredMissionCandidate(candidate: candidate, score: 100);
}

MissionTemplate _template({
  required String id,
  Duration duration = const Duration(hours: 1),
  EnergyLevel energyLevel = EnergyLevel.medium,
  bool critical = false,
}) {
  return MissionTemplate(
    id: id,
    title: id,
    description: id,
    duration: duration,
    xpReward: 80,
    energyLevel: energyLevel,
    importance: 7,
    urgency: 7,
    preferredPeriod: PreferredPeriod.anytime,
    lifeAreaId: 'business',
    critical: critical,
  );
}

Habit _habit({
  required String id,
  Duration duration = const Duration(minutes: 30),
}) {
  return Habit(
    id: id,
    title: id,
    frequency: HabitFrequency.daily,
    duration: duration,
    xpReward: 20,
    preferredPeriod: PreferredPeriod.morning,
    lifeAreaId: 'spirituality',
  );
}

Goal _goal({DateTime? targetDate}) {
  return Goal(
    id: 'goal',
    title: 'Goal',
    description: 'Goal',
    targetDate: targetDate ?? DateTime(2026, 7, 31),
    priority: 8,
    lifeAreaId: 'business',
  );
}

Matcher _matchesWindow(DateTime date, int startHour, int endHour) {
  final expected = _window(date, startHour, endHour);

  return predicate<TimeWindow>(
    (window) => window.start == expected.start && window.end == expected.end,
    'matches $startHour:00-$endHour:00',
  );
}

bool _isOrdered(Iterable<DateTime> values) {
  DateTime? previous;

  for (final value in values) {
    if (previous != null && value.isBefore(previous)) {
      return false;
    }

    previous = value;
  }

  return true;
}
