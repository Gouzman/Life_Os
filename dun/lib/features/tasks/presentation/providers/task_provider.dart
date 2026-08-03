import 'package:dun/app/providers/task_providers.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/usecases/watch_task.dart';
import 'package:dun/features/tasks/domain/usecases/watch_tasks.dart';
import 'package:dun/features/tasks/presentation/controllers/task_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskControllerProvider = NotifierProvider<TaskController, TaskState>(
  TaskController.new,
);

final tasksStreamProvider = StreamProvider.autoDispose
    .family<List<Task>, String>((ref, userId) {
      final useCase = ref.read(watchTasksProvider);
      return useCase(WatchTasksParams(userId: userId));
    });

final taskProvider = StreamProvider.autoDispose.family<Task?, String>((
  ref,
  taskId,
) {
  final useCase = ref.read(watchTaskProvider);
  return useCase(WatchTaskParams(taskId: taskId));
});
