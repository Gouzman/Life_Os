import 'time_slot.dart';

class TimeBlock {
  final String id;
  final String label;
  final TimeSlot slot;
  final bool isAvailable;

  const TimeBlock({
    required this.id,
    required this.label,
    required this.slot,
    this.isAvailable = true,
  });
}
