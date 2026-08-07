import 'package:dun/features/tasks/domain/entities/task.dart';

import '../repositories/history_repository.dart';

class WatchCancelledTasksParams {
  const WatchCancelledTasksParams({required this.userId});

  final String userId;
}

class WatchCancelledTasks {
  const WatchCancelledTasks(this._repository);

  final HistoryRepository _repository;

  Stream<List<Task>> call(WatchCancelledTasksParams params) =>
      _repository.watchCancelledTasks(params.userId);
}
