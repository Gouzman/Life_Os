import 'package:dun/features/tasks/domain/entities/task.dart';

import '../repositories/history_repository.dart';

class WatchHistoryByDayParams {
  const WatchHistoryByDayParams({required this.userId, required this.day});

  final String userId;
  final DateTime day;
}

class WatchHistoryByDay {
  const WatchHistoryByDay(this._repository);

  final HistoryRepository _repository;

  Stream<List<Task>> call(WatchHistoryByDayParams params) =>
      _repository.watchHistoryByDay(params.userId, params.day);
}
