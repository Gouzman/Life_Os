import '../entities/mission.dart';
import '../repositories/mission_repository.dart';

class CreateMission {
  final MissionRepository repository;

  const CreateMission(this.repository);

  Future<void> call(Mission mission) {
    return repository.create(mission);
  }
}
