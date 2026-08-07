import 'package:dun/features/tasks/domain/entities/task.dart';

abstract class HistoryRepository {
  Stream<List<Task>> watchHistory(String userId);
  Stream<List<Task>> watchCompletedTasks(String userId);
  Stream<List<Task>> watchCancelledTasks(String userId);
  Stream<List<Task>> watchHistoryByDay(String userId, DateTime day);
  Stream<List<Task>> watchHistoryByPeriod(
    String userId,
    DateTime start,
    DateTime end,
  );
}
