import '../entities/routine.dart';

/// Repository contract for reading and writing routines.
abstract class RoutineRepository {
  /// Returns every routine known by the current user.
  Future<List<Routine>> getAll();

  /// Returns the routine matching [id], or null when it does not exist.
  Future<Routine?> getById(String id);

  /// Persists [routine].
  Future<void> save(Routine routine);

  /// Deletes the routine matching [id].
  Future<void> delete(String id);
}
