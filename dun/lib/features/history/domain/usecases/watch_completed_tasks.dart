import 'package:dun/features/tasks/domain/entities/task.dart';

import '../repositories/history_repository.dart';

class WatchCompletedTasksParams {
  const WatchCompletedTasksParams({required this.userId});

  final String userId;
}

class WatchCompletedTasks {
  const WatchCompletedTasks(this._repository);

  final HistoryRepository _repository;

  Stream<List<Task>> call(WatchCompletedTasksParams params) =>
      _repository.watchCompletedTasks(params.userId);
}
