import 'package:dun/features/tasks/presentation/controllers/task_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskControllerProvider =
    NotifierProvider<TaskController, TaskDetailState>(TaskController.new);
