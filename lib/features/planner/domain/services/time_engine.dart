import '../entities/fixed_event.dart';
import '../entities/planning_preferences.dart';
import '../entities/time_window.dart';
import 'constraint_engine.dart';

/// Creates the usable planning windows for a generated day.
class TimeEngine {
  /// Engine used to remove blocked time from the day.
  final ConstraintEngine constraintEngine;

  /// Creates a time engine.
  const TimeEngine({this.constraintEngine = const ConstraintEngine()});

  /// Creates the full scheduling day window from [date] and [preferences].
  TimeWindow createDayWindow({
    required DateTime date,
    required PlanningPreferences preferences,
  }) {
    final midnight = DateTime(date.year, date.month, date.day);

    return TimeWindow(
      start: midnight.add(preferences.dayStartOffset),
      end: midnight.add(preferences.dayEndOffset),
    );
  }

  /// Creates free windows by applying [fixedEvents] to the generated day.
  List<TimeWindow> createAvailableWindows({
    required DateTime date,
    required PlanningPreferences preferences,
    required List<FixedEvent> fixedEvents,
  }) {
    return constraintEngine.freeWindows(
      dayWindow: createDayWindow(date: date, preferences: preferences),
      fixedEvents: fixedEvents,
    );
  }

  /// Splits [window] into deterministic chunks of [granularity].
  List<TimeWindow> splitWindow({
    required TimeWindow window,
    required Duration granularity,
  }) {
    final chunks = <TimeWindow>[];
    var cursor = window.start;

    while (cursor.isBefore(window.end)) {
      final chunkEnd = cursor.add(granularity);
      chunks.add(
        TimeWindow(
          start: cursor,
          end: chunkEnd.isAfter(window.end) ? window.end : chunkEnd,
        ),
      );
      cursor = chunkEnd;
    }

    return chunks;
  }
}
