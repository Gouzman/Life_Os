import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/repositories/task_repository.dart';

class WatchTasksForToday {
  const WatchTasksForToday(this._repository);

  final TaskRepository _repository;

  Stream<List<Task>> call(String userId) {
    return _repository.watchTasksForDay(userId, DateTime.now());
  }
}
