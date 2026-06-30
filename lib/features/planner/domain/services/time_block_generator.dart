import '../entities/fixed_event.dart';
import '../entities/time_block.dart';
import '../entities/time_slot.dart';

class TimeBlockGenerator {
  const TimeBlockGenerator();

  List<TimeBlock> generate({
    required DateTime date,
    List<FixedEvent> fixedEvents = const [],
  }) {
    final dayStart = DateTime(date.year, date.month, date.day, 8);
    final dayEnd = DateTime(date.year, date.month, date.day, 20);

    return [
      TimeBlock(
        id: 'workday-${date.toIso8601String()}',
        label: 'Journee active',
        slot: TimeSlot(start: dayStart, end: dayEnd),
        isAvailable: fixedEvents.isEmpty,
      ),
    ];
  }
}
