import 'package:dun/features/tasks/data/models/task_model.dart';

abstract class HistoryRemoteDatasource {
  Stream<List<TaskModel>> watchHistory(String userId);
  Stream<List<TaskModel>> watchCompletedTasks(String userId);
  Stream<List<TaskModel>> watchCancelledTasks(String userId);
  Stream<List<TaskModel>> watchHistoryByDay(String userId, DateTime day);
  Stream<List<TaskModel>> watchHistoryByPeriod(
    String userId,
    DateTime start,
    DateTime end,
  );
}
