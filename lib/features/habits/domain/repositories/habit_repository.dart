import '../entities/habit.dart';

/// Repository contract for reading and writing habits.
abstract class HabitRepository {
  /// Returns every habit known by the current user.
  Future<List<Habit>> getAll();

  /// Returns the habit matching [id], or null when it does not exist.
  Future<Habit?> getById(String id);

  /// Persists [habit].
  Future<void> save(Habit habit);

  /// Deletes the habit matching [id].
  Future<void> delete(String id);
}
