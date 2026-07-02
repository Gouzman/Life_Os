import 'package:flutter_test/flutter_test.dart';
import 'package:life_os/features/missions/domain/entities/mission_instance.dart';
import 'package:life_os/features/missions/domain/entities/mission_status.dart';
import 'package:life_os/features/missions/domain/usecases/abandon_mission.dart';
import 'package:life_os/features/missions/domain/usecases/complete_mission.dart';
import 'package:life_os/features/missions/domain/usecases/skip_mission.dart';
import 'package:life_os/features/missions/domain/usecases/start_mission.dart';

void main() {
  final base = MissionInstance(
    id: 'test-id',
    templateId: 'mt_deep_work',
    scheduledStart: DateTime(2026, 7, 1, 9),
    scheduledEnd: DateTime(2026, 7, 1, 10, 30),
  );

  group('StartMission', () {
    const useCase = StartMission();

    test('transitions status to inProgress', () {
      final result = useCase(base);
      expect(result.status, MissionStatus.inProgress);
    });

    test('preserves identity fields', () {
      final result = useCase(base);
      expect(result.id, base.id);
      expect(result.templateId, base.templateId);
      expect(result.scheduledStart, base.scheduledStart);
      expect(result.scheduledEnd, base.scheduledEnd);
    });
  });

  group('CompleteMission', () {
    const useCase = CompleteMission();

    test('transitions status to completed', () {
      final result = useCase(base);
      expect(result.status, MissionStatus.completed);
    });

    test('records completedAt', () {
      final before = DateTime.now();
      final result = useCase(base);
      final after = DateTime.now();

      expect(result.completedAt, isNotNull);
      expect(
        result.completedAt!.isAfter(before) ||
            result.completedAt!.isAtSameMomentAs(before),
        isTrue,
      );
      expect(
        result.completedAt!.isBefore(after) ||
            result.completedAt!.isAtSameMomentAs(after),
        isTrue,
      );
    });
  });

  group('SkipMission', () {
    const useCase = SkipMission();

    test('transitions status to skipped', () {
      final result = useCase(base);
      expect(result.status, MissionStatus.skipped);
    });
  });

  group('AbandonMission', () {
    const useCase = AbandonMission();

    test('transitions status to cancelled', () {
      final result = useCase(base);
      expect(result.status, MissionStatus.cancelled);
    });
  });

  group('Mission lifecycle', () {
    test('full lifecycle: scheduled -> inProgress -> completed', () {
      var mission = base;
      expect(mission.status, MissionStatus.scheduled);

      mission = const StartMission()(mission);
      expect(mission.status, MissionStatus.inProgress);

      mission = const CompleteMission()(mission);
      expect(mission.status, MissionStatus.completed);
      expect(mission.completedAt, isNotNull);
    });

    test('scheduled -> inProgress -> skipped', () {
      var mission = const StartMission()(base);
      mission = const SkipMission()(mission);
      expect(mission.status, MissionStatus.skipped);
    });
  });
}
