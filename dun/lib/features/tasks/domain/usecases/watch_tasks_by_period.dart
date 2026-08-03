import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/repositories/task_repository.dart';

class WatchTasksByPeriodParams {
  const WatchTasksByPeriodParams({
    required this.userId,
    required this.start,
    required this.end,
  });

  final String userId;
  final DateTime start;
  final DateTime end;
}

class WatchTasksByPeriod {
  const WatchTasksByPeriod(this._repository);

  final TaskRepository _repository;

  Stream<List<Task>> call(WatchTasksByPeriodParams params) {
    return _repository.watchTasksByPeriod(
      params.userId,
      params.start,
      params.end,
    );
  }
}
