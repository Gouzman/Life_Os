import 'package:dun/features/tasks/presentation/controllers/task_list_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskListControllerProvider =
    NotifierProvider<TaskListController, TaskListState>(TaskListController.new);
