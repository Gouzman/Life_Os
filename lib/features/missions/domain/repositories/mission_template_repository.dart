import '../entities/mission_template.dart';

/// Repository contract for reading and writing mission templates.
abstract class MissionTemplateRepository {
  /// Returns every mission template known by the current user.
  Future<List<MissionTemplate>> getAll();

  /// Returns the mission template matching [id], or null when it does not exist.
  Future<MissionTemplate?> getById(String id);

  /// Persists [template].
  Future<void> save(MissionTemplate template);

  /// Deletes the mission template matching [id].
  Future<void> delete(String id);
}
