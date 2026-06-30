import 'time_window.dart';

/// Category of a fixed event that blocks planning time.
enum FixedEventType {
  /// Sleep block.
  sleep,

  /// Work block.
  work,

  /// School block.
  school,

  /// Church or spiritual gathering.
  church,

  /// Appointment block.
  appointment,

  /// Any other fixed event.
  custom,
}

/// Represents a non-movable event that blocks the user's day.
class FixedEvent {
  /// Unique identifier of the fixed event.
  final String id;

  /// User-facing title of the fixed event.
  final String title;

  /// Category used for diagnostics and future policy tuning.
  final FixedEventType type;

  /// Time interval blocked by this event.
  final TimeWindow window;

  FixedEvent({
    required this.id,
    required this.title,
    required this.type,
    required this.window,
  });
}
