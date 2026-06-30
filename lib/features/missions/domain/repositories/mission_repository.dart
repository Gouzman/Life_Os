import '../entities/mission.dart';

abstract class MissionRepository {
  Future<List<Mission>> getAll();

  Future<void> create(Mission mission);

  Future<void> update(Mission mission);

  Future<void> delete(String id);
}
