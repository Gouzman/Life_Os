import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/repositories/task_repository.dart';

class WatchTaskParams {
  const WatchTaskParams({required this.taskId});

  final String taskId;
}

class WatchTask {
  const WatchTask(this._repository);

  final TaskRepository _repository;

  Stream<Task?> call(WatchTaskParams params) {
    return _repository.watchTask(params.taskId);
  }
}
