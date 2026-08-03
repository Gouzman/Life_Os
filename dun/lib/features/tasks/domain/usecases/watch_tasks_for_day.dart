import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/repositories/task_repository.dart';

class WatchTasksForDayParams {
  const WatchTasksForDayParams({required this.userId, required this.day});

  final String userId;
  final DateTime day;
}

class WatchTasksForDay {
  const WatchTasksForDay(this._repository);

  final TaskRepository _repository;

  Stream<List<Task>> call(WatchTasksForDayParams params) {
    return _repository.watchTasksForDay(params.userId, params.day);
  }
}
