import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/scheduler_controller.dart';

export '../controllers/scheduler_controller.dart' show SchedulerState;

final schedulerControllerProvider =
    NotifierProvider<SchedulerController, SchedulerState>(
      SchedulerController.new,
    );
