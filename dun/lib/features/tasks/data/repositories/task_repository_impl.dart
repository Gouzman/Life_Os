import 'package:dun/core/errors/error_handler.dart';
import 'package:dun/core/errors/failures.dart';
import 'package:dun/core/network/connectivity_service.dart';
import 'package:dun/core/utils/result.dart';
import 'package:dun/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:dun/features/tasks/data/models/task_model.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({
    required TaskRemoteDataSource remoteDataSource,
    required ConnectivityService connectivityService,
  }) : _remoteDataSource = remoteDataSource,
       _connectivityService = connectivityService;

  final TaskRemoteDataSource _remoteDataSource;
  final ConnectivityService _connectivityService;

  @override
  Stream<List<Task>> watchTasks(String userId) {
    return _remoteDataSource
        .watchTasks(userId)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Stream<List<Task>> watchTasksForDay(String userId, DateTime day) {
    return _remoteDataSource
        .watchTasksForDay(userId, day)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Stream<List<Task>> watchTasksByPeriod(
    String userId,
    DateTime start,
    DateTime end,
  ) {
    return _remoteDataSource
        .watchTasksByPeriod(userId, start, end)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Result<Task?>> getTaskById(String taskId) async {
    return _execute(() async {
      final model = await _remoteDataSource.getTaskById(taskId);
      return model?.toEntity();
    });
  }

  @override
  Future<Result<void>> createTask(Task task) async {
    return _execute(() async {
      final model = TaskModel.fromEntity(task);
      await _remoteDataSource.createTask(model);
    });
  }

  @override
  Future<Result<void>> updateTask(Task task) async {
    return _execute(() async {
      final model = TaskModel.fromEntity(task);
      await _remoteDataSource.updateTask(model);
    });
  }

  @override
  Future<Result<void>> deleteTask(String taskId) async {
    return _execute(() async {
      await _remoteDataSource.deleteTask(taskId);
    });
  }

  Future<Result<T>> _execute<T>(Future<T> Function() action) async {
    try {
      if (!await _connectivityService.isConnected) {
        return const FailureResult(NetworkFailure());
      }
      final result = await action();
      return Success(result);
    } on Exception catch (e) {
      return FailureResult(mapExceptionToFailure(e));
    }
  }
}
