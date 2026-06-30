import '../entities/goal.dart';

/// Repository contract for reading and writing goals.
abstract class GoalRepository {
  /// Returns every goal known by the current user.
  Future<List<Goal>> getAll();

  /// Returns the goal matching [id], or null when it does not exist.
  Future<Goal?> getById(String id);

  /// Persists [goal].
  Future<void> save(Goal goal);

  /// Deletes the goal matching [id].
  Future<void> delete(String id);
}
