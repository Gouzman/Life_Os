import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'scheduler_event_bus.dart';

final schedulerEventBusProvider = Provider<SchedulerEventBus>((ref) {
  final bus = SchedulerEventBus();

  ref.onDispose(() {
    bus.dispose();
  });

  return bus;
});
