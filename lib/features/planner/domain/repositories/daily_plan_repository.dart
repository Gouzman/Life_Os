import '../entities/daily_plan.dart';

/// Repository contract for reading and writing generated daily plans.
abstract class DailyPlanRepository {
  /// Returns the plan matching [date], or null when it does not exist.
  Future<DailyPlan?> getByDate(DateTime date);

  /// Persists [plan].
  Future<void> save(DailyPlan plan);

  /// Deletes the plan matching [date].
  Future<void> deleteByDate(DateTime date);
}
