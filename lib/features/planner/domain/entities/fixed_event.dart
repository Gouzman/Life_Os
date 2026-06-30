import 'time_slot.dart';

class FixedEvent {
  final String id;
  final String title;
  final TimeSlot slot;

  const FixedEvent({required this.id, required this.title, required this.slot});
}
