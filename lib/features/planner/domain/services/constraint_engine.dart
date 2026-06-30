import '../algorithms/time_window_algorithms.dart';
import '../entities/fixed_event.dart';
import '../entities/time_window.dart';

/// Blocks fixed events and returns free windows for a day.
class ConstraintEngine {
  /// Creates a constraint engine.
  const ConstraintEngine();

  /// Returns free windows inside [dayWindow] after applying [fixedEvents].
  List<TimeWindow> freeWindows({
    required TimeWindow dayWindow,
    required List<FixedEvent> fixedEvents,
  }) {
    return TimeWindowAlgorithms.subtractAll(
      baseWindow: dayWindow,
      blockedWindows: fixedEvents.map((event) => event.window).toList(),
    );
  }
}
