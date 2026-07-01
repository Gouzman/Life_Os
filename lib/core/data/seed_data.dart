import 'package:life_os/core/domain/value_objects/energy_level.dart';
import 'package:life_os/core/domain/value_objects/habit_frequency.dart';
import 'package:life_os/core/domain/value_objects/preferred_period.dart';
import 'package:life_os/features/goals/domain/entities/goal.dart';
import 'package:life_os/features/habits/domain/entities/habit.dart';
import 'package:life_os/features/life_area/domain/entities/life_area.dart';
import 'package:life_os/features/missions/domain/entities/mission_template.dart';
import 'package:life_os/features/planner/domain/entities/fixed_event.dart';
import 'package:life_os/features/planner/domain/entities/planning_preferences.dart';
import 'package:life_os/features/routines/domain/entities/routine.dart';

/// Static seed data used to initialise the in-memory repositories.
class SeedData {
  const SeedData._();

  // ── Life Areas ────────────────────────────────────────────────────────────

  static final List<LifeArea> lifeAreas = [
    const LifeArea(
      id: 'la_business',
      name: 'Business',
      iconKey: 'trending_up',
      colorHex: '#60A5FA',
      order: 0,
    ),
    const LifeArea(
      id: 'la_health',
      name: 'Sante',
      iconKey: 'favorite',
      colorHex: '#4ADE80',
      order: 1,
    ),
    const LifeArea(
      id: 'la_learning',
      name: 'Apprentissage',
      iconKey: 'school',
      colorHex: '#FBBF24',
      order: 2,
    ),
    const LifeArea(
      id: 'la_relations',
      name: 'Relations',
      iconKey: 'groups',
      colorHex: '#FAFAFA',
      order: 3,
    ),
  ];

  // ── Mission Templates ─────────────────────────────────────────────────────

  static final List<MissionTemplate> missionTemplates = [
    MissionTemplate(
      id: 'mt_lifeos_arch',
      title: 'Developper Life OS',
      description: 'Architecture du moteur de planification en Dart pur.',
      duration: const Duration(hours: 2),
      xpReward: 80,
      energyLevel: EnergyLevel.high,
      importance: 10,
      urgency: 9,
      preferredPeriod: PreferredPeriod.morning,
      lifeAreaId: 'la_business',
      critical: true,
    ),
    MissionTemplate(
      id: 'mt_deep_work',
      title: 'Session Deep Work',
      description: 'Bloc de travail intense sans interruption.',
      duration: const Duration(hours: 1, minutes: 30),
      xpReward: 60,
      energyLevel: EnergyLevel.high,
      importance: 8,
      urgency: 7,
      preferredPeriod: PreferredPeriod.morning,
      lifeAreaId: 'la_business',
    ),
    MissionTemplate(
      id: 'mt_sport',
      title: 'Entrainement Sport',
      description: 'Session cardio ou musculation.',
      duration: const Duration(minutes: 45),
      xpReward: 50,
      energyLevel: EnergyLevel.high,
      importance: 8,
      urgency: 6,
      preferredPeriod: PreferredPeriod.morning,
      lifeAreaId: 'la_health',
    ),
    MissionTemplate(
      id: 'mt_reading',
      title: 'Lecture 30 min',
      description: 'Lecture non-fiction pour progresser.',
      duration: const Duration(minutes: 30),
      xpReward: 30,
      energyLevel: EnergyLevel.low,
      importance: 7,
      urgency: 4,
      preferredPeriod: PreferredPeriod.evening,
      lifeAreaId: 'la_learning',
    ),
    MissionTemplate(
      id: 'mt_review',
      title: 'Revue hebdomadaire',
      description: 'Bilan des objectifs et ajustement du plan.',
      duration: const Duration(minutes: 45),
      xpReward: 40,
      energyLevel: EnergyLevel.medium,
      importance: 9,
      urgency: 5,
      preferredPeriod: PreferredPeriod.afternoon,
      lifeAreaId: 'la_business',
    ),
    MissionTemplate(
      id: 'mt_meditation',
      title: 'Meditation matinale',
      description: 'Pratique de pleine conscience pour debuter la journee.',
      duration: const Duration(minutes: 15),
      xpReward: 20,
      energyLevel: EnergyLevel.low,
      importance: 6,
      urgency: 3,
      preferredPeriod: PreferredPeriod.dawn,
      lifeAreaId: 'la_health',
    ),
  ];

  // ── Habits ────────────────────────────────────────────────────────────────

  static final List<Habit> habits = [
    Habit(
      id: 'h_water',
      title: 'Boire 2 L d\'eau',
      frequency: HabitFrequency.daily,
      duration: const Duration(minutes: 5),
      xpReward: 10,
      preferredPeriod: PreferredPeriod.morning,
      lifeAreaId: 'la_health',
    ),
  ];

  // ── Goals ─────────────────────────────────────────────────────────────────

  static final List<Goal> goals = [
    Goal(
      id: 'g_launch',
      title: 'Lancer Life OS',
      description: 'Publier la version 1.0 de l\'application Life OS.',
      targetDate: _q3Target,
      priority: 10,
      lifeAreaId: 'la_business',
    ),
    Goal(
      id: 'g_fitness',
      title: 'Forme physique optimale',
      description: 'Atteindre 15% de masse grasse et courir 10 km.',
      targetDate: _q3Target,
      priority: 8,
      lifeAreaId: 'la_health',
    ),
  ];

  // ── Routines ──────────────────────────────────────────────────────────────

  static final List<Routine> routines = [
    Routine(id: 'r_morning', title: 'Routine Matinale', habitIds: ['h_water']),
  ];

  // ── Fixed Events ──────────────────────────────────────────────────────────

  static List<FixedEvent> fixedEventsForDate(DateTime date) => const [];

  // ── Planning Preferences ──────────────────────────────────────────────────

  static final PlanningPreferences preferences = PlanningPreferences.standard();

  // ── Internal helpers ──────────────────────────────────────────────────────

  static final DateTime _q3Target = DateTime(2026, 9, 30);
}
