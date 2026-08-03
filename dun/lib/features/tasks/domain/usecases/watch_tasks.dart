import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/repositories/task_repository.dart';

class WatchTasks {
  const WatchTasks(this._repository);

  final TaskRepository _repository;

  Stream<List<Task>> call(String userId) => _repository.watchTasks(userId);
}
