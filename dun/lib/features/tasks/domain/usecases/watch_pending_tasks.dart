import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/repositories/task_repository.dart';

class WatchPendingTasksParams {
  const WatchPendingTasksParams({required this.userId});

  final String userId;
}

class WatchPendingTasks {
  const WatchPendingTasks(this._repository);

  final TaskRepository _repository;

  Stream<List<Task>> call(WatchPendingTasksParams params) {
    return _repository.watchPendingTasks(params.userId);
  }
}
