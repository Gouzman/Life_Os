import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_os/core/data/seed_data.dart';
import 'package:life_os/features/missions/data/in_memory_mission_instance_repository.dart';
import 'package:life_os/features/missions/data/in_memory_mission_template_repository.dart';
import 'package:life_os/features/missions/domain/entities/mission_instance.dart';
import 'package:life_os/features/missions/domain/entities/mission_template.dart';
import 'package:life_os/features/missions/domain/repositories/mission_instance_repository.dart';
import 'package:life_os/features/missions/domain/repositories/mission_template_repository.dart';
import 'package:life_os/features/missions/domain/usecases/abandon_mission.dart';
import 'package:life_os/features/missions/domain/usecases/complete_mission.dart';
import 'package:life_os/features/missions/domain/usecases/skip_mission.dart';
import 'package:life_os/features/missions/domain/usecases/start_mission.dart';
import 'package:life_os/features/planner/data/in_memory_daily_plan_repository.dart';
import 'package:life_os/features/planner/domain/entities/daily_plan.dart';
import 'package:life_os/features/planner/domain/entities/planner_input.dart';
import 'package:life_os/features/planner/domain/repositories/daily_plan_repository.dart';
import 'package:life_os/features/planner/domain/usecases/generate_daily_plan.dart';

// ── Repository providers ──────────────────────────────────────────────────

/// Provides the singleton in-memory [DailyPlanRepository].
final dailyPlanRepositoryProvider = Provider<DailyPlanRepository>(
  (ref) => InMemoryDailyPlanRepository(),
);

/// Provides the singleton in-memory [MissionInstanceRepository].
final missionInstanceRepositoryProvider = Provider<MissionInstanceRepository>(
  (ref) => InMemoryMissionInstanceRepository(),
);

/// Provides the singleton in-memory [MissionTemplateRepository] seeded with
/// sample templates.
final missionTemplateRepositoryProvider = Provider<MissionTemplateRepository>(
  (ref) => InMemoryMissionTemplateRepository(SeedData.missionTemplates),
);

// ── Template lookup ───────────────────────────────────────────────────────

/// Provides the full list of mission templates.
final missionTemplatesProvider = FutureProvider<List<MissionTemplate>>((
  ref,
) async {
  return ref.watch(missionTemplateRepositoryProvider).getAll();
});

// ── DailyPlan state ───────────────────────────────────────────────────────

/// Manages the [DailyPlan] for today.  Exposes methods to transition mission
/// statuses without containing any business logic.
class DailyPlanNotifier extends AsyncNotifier<DailyPlan> {
  @override
  Future<DailyPlan> build() => _loadOrGenerate(DateTime.now());

  // ── Public methods ──────────────────────────────────────────────────────

  /// Transitions [missionId] to [MissionStatus.inProgress].
  Future<void> startMission(String missionId) async {
    await _applyTransition(missionId, const StartMission());
  }

  /// Transitions [missionId] to [MissionStatus.completed].
  Future<void> completeMission(String missionId) async {
    await _applyTransition(missionId, const CompleteMission());
  }

  /// Transitions [missionId] to [MissionStatus.skipped].
  Future<void> skipMission(String missionId) async {
    await _applyTransition(missionId, const SkipMission());
  }

  /// Transitions [missionId] to [MissionStatus.cancelled].
  Future<void> abandonMission(String missionId) async {
    await _applyTransition(missionId, const AbandonMission());
  }

  // ── Private helpers ─────────────────────────────────────────────────────

  Future<DailyPlan> _loadOrGenerate(DateTime date) async {
    final repo = ref.read(dailyPlanRepositoryProvider);
    final existing = await repo.getByDate(date);
    if (existing != null) return existing;
    return _generate(date);
  }

  Future<DailyPlan> _generate(DateTime date) async {
    final templates = await ref
        .read(missionTemplateRepositoryProvider)
        .getAll();
    final input = PlannerInput(
      date: date,
      missionTemplates: templates,
      habits: SeedData.habits,
      goals: SeedData.goals,
      routines: SeedData.routines,
      fixedEvents: SeedData.fixedEventsForDate(date),
      preferences: SeedData.preferences,
    );
    final plan = const GenerateDailyPlan()(input);
    await ref.read(dailyPlanRepositoryProvider).save(plan);
    return plan;
  }

  Future<void> _applyTransition(
    String missionId,
    MissionInstance Function(MissionInstance) transition,
  ) async {
    // Ensure plan is loaded before applying transition
    if (state is! AsyncData) {
      final today = DateTime.now();
      final plan = await _loadOrGenerate(today);
      state = AsyncData(plan);
    }
    
    final currentPlan = state.requireValue;
    final instance = currentPlan.missionInstances.firstWhere(
      (m) => m.id == missionId,
    );
    final updated = transition(instance);
    final newPlan = _replaceMission(currentPlan, updated);

    state = AsyncData(newPlan);
    await ref.read(dailyPlanRepositoryProvider).save(newPlan);
    await ref.read(missionInstanceRepositoryProvider).save(updated);
  }

  DailyPlan _replaceMission(DailyPlan plan, MissionInstance updated) {
    final instances = plan.missionInstances
        .map((m) => m.id == updated.id ? updated : m)
        .toList();
    return DailyPlan(
      date: plan.date,
      missionInstances: instances,
      remainingFreeTime: plan.remainingFreeTime,
      dayScore: plan.dayScore,
      unscheduledTemplateIds: List<String>.from(plan.unscheduledTemplateIds),
    );
  }
}

/// Provider for the [DailyPlanNotifier].
final dailyPlanProvider = AsyncNotifierProvider<DailyPlanNotifier, DailyPlan>(
  DailyPlanNotifier.new,
);
