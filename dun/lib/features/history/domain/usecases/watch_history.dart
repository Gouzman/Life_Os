import 'package:dun/features/tasks/domain/entities/task.dart';

import '../repositories/history_repository.dart';

class WatchHistoryParams {
  const WatchHistoryParams({required this.userId});

  final String userId;
}

class WatchHistory {
  const WatchHistory(this._repository);

  final HistoryRepository _repository;

  Stream<List<Task>> call(WatchHistoryParams params) =>
      _repository.watchHistory(params.userId);
}
