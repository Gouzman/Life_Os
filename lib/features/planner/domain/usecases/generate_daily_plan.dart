import '../entities/daily_plan.dart';
import '../entities/planner_input.dart';
import '../services/planner_engine.dart';

/// Use case for generating a daily plan from a planning input snapshot.
class GenerateDailyPlan {
  /// Planner engine used by this use case.
  final PlannerEngine plannerEngine;

  /// Creates a daily plan generation use case.
  const GenerateDailyPlan({this.plannerEngine = const PlannerEngine()});

  /// Generates a daily plan from [input].
  DailyPlan call(PlannerInput input) {
    return plannerEngine.generate(input);
  }
}
