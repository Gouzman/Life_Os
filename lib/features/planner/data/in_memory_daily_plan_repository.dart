import 'package:life_os/features/planner/domain/entities/daily_plan.dart';
import 'package:life_os/features/planner/domain/repositories/daily_plan_repository.dart';

/// In-memory implementation of [DailyPlanRepository].
class InMemoryDailyPlanRepository implements DailyPlanRepository {
  final Map<String, DailyPlan> _store = {};

  static String _key(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Future<DailyPlan?> getByDate(DateTime date) async => _store[_key(date)];

  @override
  Future<void> save(DailyPlan plan) async {
    _store[_key(plan.date)] = plan;
  }

  @override
  Future<void> deleteByDate(DateTime date) async {
    _store.remove(_key(date));
  }
}
