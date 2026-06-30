import '../entities/mission_instance.dart';

/// Repository contract for reading and writing generated mission instances.
abstract class MissionInstanceRepository {
  /// Returns every mission instance scheduled for [date].
  Future<List<MissionInstance>> getByDate(DateTime date);

  /// Returns the mission instance matching [id], or null when it does not exist.
  Future<MissionInstance?> getById(String id);

  /// Persists [instance].
  Future<void> save(MissionInstance instance);

  /// Deletes the mission instance matching [id].
  Future<void> delete(String id);
}
