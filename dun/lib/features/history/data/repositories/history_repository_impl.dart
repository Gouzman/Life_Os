import 'package:dun/features/history/data/datasources/history_remote_datasource.dart';
import 'package:dun/features/history/domain/repositories/history_repository.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  const HistoryRepositoryImpl(this._remoteDataSource);

  final HistoryRemoteDatasource _remoteDataSource;

  @override
  Stream<List<Task>> watchHistory(String userId) => _remoteDataSource
      .watchHistory(userId)
      .map((models) => models.map((m) => m.toEntity()).toList());

  @override
  Stream<List<Task>> watchCompletedTasks(String userId) => _remoteDataSource
      .watchCompletedTasks(userId)
      .map((models) => models.map((m) => m.toEntity()).toList());

  @override
  Stream<List<Task>> watchCancelledTasks(String userId) => _remoteDataSource
      .watchCancelledTasks(userId)
      .map((models) => models.map((m) => m.toEntity()).toList());

  @override
  Stream<List<Task>> watchHistoryByDay(String userId, DateTime day) =>
      _remoteDataSource
          .watchHistoryByDay(userId, day)
          .map((models) => models.map((m) => m.toEntity()).toList());

  @override
  Stream<List<Task>> watchHistoryByPeriod(
    String userId,
    DateTime start,
    DateTime end,
  ) => _remoteDataSource
      .watchHistoryByPeriod(userId, start, end)
      .map((models) => models.map((m) => m.toEntity()).toList());
}
