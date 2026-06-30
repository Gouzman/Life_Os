import '../entities/life_area.dart';

/// Repository contract for reading and writing life areas.
abstract class LifeAreaRepository {
  /// Returns every life area known by the current user.
  Future<List<LifeArea>> getAll();

  /// Returns the life area matching [id], or null when it does not exist.
  Future<LifeArea?> getById(String id);

  /// Persists [lifeArea].
  Future<void> save(LifeArea lifeArea);

  /// Deletes the life area matching [id].
  Future<void> delete(String id);
}
