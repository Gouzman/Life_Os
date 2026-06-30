/// Represents an immutable time interval used by the planner.
class TimeWindow {
  /// Start date and time of the interval.
  final DateTime start;

  /// End date and time of the interval.
  final DateTime end;

  TimeWindow({required this.start, required this.end})
    : assert(!end.isBefore(start), 'end must be after or equal to start');

  /// Duration covered by this interval.
  Duration get duration => end.difference(start);

  /// Returns true when this interval has no duration.
  bool get isEmpty => start.isAtSameMomentAs(end);

  /// Returns true when [other] intersects this interval.
  bool overlaps(TimeWindow other) {
    return start.isBefore(other.end) && end.isAfter(other.start);
  }

  /// Returns true when [duration] can fit inside this interval.
  bool canFit(Duration duration) {
    return this.duration >= duration;
  }

  /// Returns a copy with [start] and [end] adjusted.
  TimeWindow copyWith({DateTime? start, DateTime? end}) {
    return TimeWindow(start: start ?? this.start, end: end ?? this.end);
  }
}
