class TimeSlot {
  final DateTime start;
  final DateTime end;

  const TimeSlot({required this.start, required this.end});

  Duration get duration => end.difference(start);

  bool overlaps(TimeSlot other) {
    return start.isBefore(other.end) && end.isAfter(other.start);
  }

  bool contains(DateTime value) {
    return !value.isBefore(start) && value.isBefore(end);
  }
}
