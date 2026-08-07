import 'package:dun/features/tasks/domain/entities/task.dart';

import '../repositories/history_repository.dart';

class WatchHistoryByPeriodParams {
  const WatchHistoryByPeriodParams({
    required this.userId,
    required this.start,
    required this.end,
  });

  final String userId;
  final DateTime start;
  final DateTime end;
}

class WatchHistoryByPeriod {
  const WatchHistoryByPeriod(this._repository);

  final HistoryRepository _repository;

  Stream<List<Task>> call(WatchHistoryByPeriodParams params) =>
      _repository.watchHistoryByPeriod(params.userId, params.start, params.end);
}
