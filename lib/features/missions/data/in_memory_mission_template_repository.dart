import 'package:life_os/features/missions/domain/entities/mission_template.dart';
import 'package:life_os/features/missions/domain/repositories/mission_template_repository.dart';

/// In-memory implementation of [MissionTemplateRepository].
class InMemoryMissionTemplateRepository implements MissionTemplateRepository {
  final Map<String, MissionTemplate> _store;

  InMemoryMissionTemplateRepository(List<MissionTemplate> initial)
    : _store = {for (final t in initial) t.id: t};

  @override
  Future<List<MissionTemplate>> getAll() async => _store.values.toList();

  @override
  Future<MissionTemplate?> getById(String id) async => _store[id];

  @override
  Future<void> save(MissionTemplate template) async {
    _store[template.id] = template;
  }

  @override
  Future<void> delete(String id) async {
    _store.remove(id);
  }
}
