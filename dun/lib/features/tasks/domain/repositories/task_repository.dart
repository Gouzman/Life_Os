import 'package:dun/core/utils/result.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';

abstract class TaskRepository {
  Stream<List<Task>> watchTasks(String userId);

  Stream<List<Task>> watchTasksForDay(String userId, DateTime day);

  Stream<List<Task>> watchTasksByPeriod(
    String userId,
    DateTime start,
    DateTime end,
  );

  Future<Result<Task?>> getTaskById(String taskId);

  Future<Result<void>> createTask(Task task);

  Future<Result<void>> updateTask(Task task);

  Future<Result<void>> deleteTask(String taskId);
}
