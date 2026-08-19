import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../scheduler_event_bus_provider.dart';
import 'task_due_handler_provider.dart';

final schedulerTaskDueListenerProvider = Provider<void>((ref) {
  final bus = ref.read(schedulerEventBusProvider);
  final handler = ref.read(taskDueHandlerProvider);

  final subscription = bus.events.listen((event) {
    unawaited(handler.handle(event));
  });

  ref.onDispose(subscription.cancel);
});
