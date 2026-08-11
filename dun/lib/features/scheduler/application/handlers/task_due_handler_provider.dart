import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'task_due_handler.dart';

final taskDueHandlerProvider = Provider<TaskDueHandler>(
  (ref) => TaskDueHandler(ref: ref),
);
