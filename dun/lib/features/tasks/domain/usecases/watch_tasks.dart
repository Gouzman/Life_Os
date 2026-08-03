import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/repositories/task_repository.dart';

class WatchTasksParams {
  const WatchTasksParams({required this.userId});

  final String userId;
}

class WatchTasks {
  const WatchTasks(this._repository);

  final TaskRepository _repository;

  Stream<List<Task>> call(WatchTasksParams params) {
    return _repository.watchTasks(params.userId);
  }
}
