import 'package:life_os/features/missions/domain/entities/mission_instance.dart';
import 'package:life_os/features/missions/domain/repositories/mission_instance_repository.dart';

/// In-memory implementation of [MissionInstanceRepository].
class InMemoryMissionInstanceRepository implements MissionInstanceRepository {
  final Map<String, MissionInstance> _store = {};

  @override
  Future<List<MissionInstance>> getByDate(DateTime date) async {
    return _store.values
        .where(
          (m) =>
              m.scheduledStart.year == date.year &&
              m.scheduledStart.month == date.month &&
              m.scheduledStart.day == date.day,
        )
        .toList();
  }

  @override
  Future<MissionInstance?> getById(String id) async => _store[id];

  @override
  Future<void> save(MissionInstance instance) async {
    _store[instance.id] = instance;
  }

  @override
  Future<void> delete(String id) async {
    _store.remove(id);
  }
}
