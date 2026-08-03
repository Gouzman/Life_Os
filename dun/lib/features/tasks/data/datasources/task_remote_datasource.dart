import 'package:dun/features/tasks/data/models/task_model.dart';

abstract class TaskRemoteDataSource {
  Stream<List<TaskModel>> watchTasks(String userId);

  Stream<TaskModel?> watchTask(String taskId);

  Stream<List<TaskModel>> watchPendingTasks(String userId);

  Stream<List<TaskModel>> watchTasksForDay(String userId, DateTime day);

  Stream<List<TaskModel>> watchTasksByPeriod(
    String userId,
    DateTime start,
    DateTime end,
  );

  Future<TaskModel?> getTaskById(String taskId);

  Future<void> createTask(TaskModel task);

  Future<void> updateTask(TaskModel task);

  Future<void> deleteTask(String taskId);
}
