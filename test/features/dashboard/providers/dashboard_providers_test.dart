import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:life_os/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:life_os/features/missions/domain/entities/mission_status.dart';
import 'package:life_os/features/planner/presentation/providers/planner_providers.dart';

void main() {
  ProviderContainer _makeContainer() {
    return ProviderContainer();
  }

  group('DailyPlanNotifier', () {
    test('generates a plan on first access', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      final plan = await container.read(dailyPlanProvider.future);

      expect(plan.missionInstances, isNotEmpty);
      expect(plan.date.year, DateTime.now().year);
      expect(plan.date.month, DateTime.now().month);
      expect(plan.date.day, DateTime.now().day);
    });

    test('startMission transitions status to inProgress', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      final plan = await container.read(dailyPlanProvider.future);
      final firstMission = plan.missionInstances.first;

      await container
          .read(dailyPlanProvider.notifier)
          .startMission(firstMission.id);

      final updated = await container.read(dailyPlanProvider.future);
      final updatedMission = updated.missionInstances.firstWhere(
        (m) => m.id == firstMission.id,
      );

      expect(updatedMission.status, MissionStatus.inProgress);
    });

    test('completeMission transitions status to completed', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      final plan = await container.read(dailyPlanProvider.future);
      final firstId = plan.missionInstances.first.id;

      await container.read(dailyPlanProvider.notifier).startMission(firstId);
      await container.read(dailyPlanProvider.notifier).completeMission(firstId);

      final updated = await container.read(dailyPlanProvider.future);
      final mission = updated.missionInstances.firstWhere(
        (m) => m.id == firstId,
      );

      expect(mission.status, MissionStatus.completed);
      expect(mission.completedAt, isNotNull);
    });

    test('skipMission advances the current mission', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      final plan = await container.read(dailyPlanProvider.future);
      final firstId = plan.missionInstances.first.id;

      await container.read(dailyPlanProvider.notifier).skipMission(firstId);

      final updated = await container.read(dailyPlanProvider.future);
      final skipped = updated.missionInstances.firstWhere(
        (m) => m.id == firstId,
      );
      expect(skipped.status, MissionStatus.skipped);
    });
  });

  group('currentMissionProvider', () {
    test('returns the first non-completed mission', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      // Ensure plan is loaded
      await container.read(dailyPlanProvider.future);

      final current = container.read(currentMissionProvider);
      expect(current, isNotNull);
      expect(
        current!.status == MissionStatus.scheduled ||
            current.status == MissionStatus.inProgress,
        isTrue,
      );
    });

    test('advances to next mission after completing the first', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      final plan = await container.read(dailyPlanProvider.future);
      final firstId = plan.missionInstances.first.id;

      await container.read(dailyPlanProvider.notifier).completeMission(firstId);

      final current = container.read(currentMissionProvider);
      // Current should be different from the completed mission
      expect(current?.id, isNot(equals(firstId)));
    });
  });

  group('todayProgressProvider', () {
    test('starts at 0.0 when no missions are completed', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      await container.read(dailyPlanProvider.future);

      final progress = container.read(todayProgressProvider);
      expect(progress, 0.0);
    });

    test('increases after completing a mission', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      final plan = await container.read(dailyPlanProvider.future);
      final firstId = plan.missionInstances.first.id;

      await container.read(dailyPlanProvider.notifier).completeMission(firstId);

      final progress = container.read(todayProgressProvider);
      expect(progress, greaterThan(0.0));
    });
  });

  group('xpTodayProvider', () {
    test('starts at 0 when no missions are completed', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      await container.read(dailyPlanProvider.future);

      final xp = container.read(xpTodayProvider);
      expect(xp, 0);
    });

    test('increases after completing a mission', () async {
      final container = _makeContainer();
      addTearDown(container.dispose);

      // Wait for templates to load too
      await container.read(missionTemplatesProvider.future);
      final plan = await container.read(dailyPlanProvider.future);
      final firstId = plan.missionInstances.first.id;

      await container.read(dailyPlanProvider.notifier).completeMission(firstId);

      final xp = container.read(xpTodayProvider);
      expect(xp, greaterThan(0));
    });
  });
}
