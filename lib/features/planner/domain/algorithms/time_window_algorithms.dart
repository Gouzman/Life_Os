import '../entities/time_window.dart';

/// Pure interval algorithms used by planner services.
class TimeWindowAlgorithms {
  const TimeWindowAlgorithms._();

  /// Returns [windows] ordered by start date.
  static List<TimeWindow> sort(List<TimeWindow> windows) {
    return List<TimeWindow>.of(windows)..sort((a, b) {
      final startComparison = a.start.compareTo(b.start);
      if (startComparison != 0) {
        return startComparison;
      }

      return a.end.compareTo(b.end);
    });
  }

  /// Removes [blockedWindows] from [baseWindow].
  static List<TimeWindow> subtractAll({
    required TimeWindow baseWindow,
    required List<TimeWindow> blockedWindows,
  }) {
    final sortedBlockedWindows = sort(blockedWindows);
    final freeWindows = <TimeWindow>[];
    var cursor = baseWindow.start;

    for (final blocked in sortedBlockedWindows) {
      if (!baseWindow.overlaps(blocked)) {
        continue;
      }

      final blockedStart = blocked.start.isBefore(baseWindow.start)
          ? baseWindow.start
          : blocked.start;
      final blockedEnd = blocked.end.isAfter(baseWindow.end)
          ? baseWindow.end
          : blocked.end;

      if (blockedStart.isAfter(cursor)) {
        freeWindows.add(TimeWindow(start: cursor, end: blockedStart));
      }

      if (blockedEnd.isAfter(cursor)) {
        cursor = blockedEnd;
      }
    }

    if (cursor.isBefore(baseWindow.end)) {
      freeWindows.add(TimeWindow(start: cursor, end: baseWindow.end));
    }

    return freeWindows
        .where((window) => !window.isEmpty)
        .toList(growable: false);
  }

  /// Removes [occupied] from [available].
  static List<TimeWindow> subtractOne({
    required List<TimeWindow> available,
    required TimeWindow occupied,
  }) {
    final next = <TimeWindow>[];

    for (final window in available) {
      if (!window.overlaps(occupied)) {
        next.add(window);
        continue;
      }

      if (occupied.start.isAfter(window.start)) {
        next.add(TimeWindow(start: window.start, end: occupied.start));
      }

      if (occupied.end.isBefore(window.end)) {
        next.add(TimeWindow(start: occupied.end, end: window.end));
      }
    }

    return sort(
      next.where((window) => !window.isEmpty).toList(growable: false),
    );
  }
}
