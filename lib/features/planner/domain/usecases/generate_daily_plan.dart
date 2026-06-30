import '../../../missions/domain/entities/mission.dart';
import '../entities/daily_schedule.dart';
import '../entities/fixed_event.dart';
import '../services/planning_engine.dart';

class GenerateDailyPlan {
  final PlanningEngine engine;

  const GenerateDailyPlan(this.engine);

  DailySchedule call({
    required DateTime date,
    required List<Mission> missions,
    List<FixedEvent> fixedEvents = const [],
  }) {
    return engine.generate(
      date: date,
      missions: missions,
      fixedEvents: fixedEvents,
    );
  }
}
