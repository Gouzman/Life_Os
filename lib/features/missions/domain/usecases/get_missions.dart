import '../entities/mission.dart';
import '../repositories/mission_repository.dart';

class GetMissions {
  final MissionRepository repository;

  const GetMissions(this.repository);

  Future<List<Mission>> call() {
    return repository.getAll();
  }
}
