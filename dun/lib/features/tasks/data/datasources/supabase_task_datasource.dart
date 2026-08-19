import 'package:dun/core/errors/exceptions.dart';
import 'package:dun/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:dun/features/tasks/data/models/task_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseTaskDataSource implements TaskRemoteDataSource {
  SupabaseTaskDataSource({
    required SupabaseClient client,
  }) : _client = client;

  final SupabaseClient _client;

  static const String _table = 'tasks';

  List<TaskModel> _mapRows(List<Map<String, dynamic>> rows) {
    return rows.map(TaskModel.fromSupabase).toList();
  }

  @override
  Stream<List<TaskModel>> watchTasks(String userId) {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('scheduled_at')
        .map(_mapRows)
        .handleError(
          (Object e) => throw ServerException(e.toString()),
        );
  }

  @override
  Stream<TaskModel?> watchTask(String taskId) {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('id', taskId)
        .map(
          (rows) => rows.isEmpty
              ? null
              : TaskModel.fromSupabase(rows.first),
        )
        .handleError(
          (Object e) => throw ServerException(e.toString()),
        );
  }

  @override
  Stream<List<TaskModel>> watchPendingTasks(String userId) {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .eq('status', 'pending')
        .eq('archived', false)
        .order('scheduled_at')
        .map(_mapRows)
        .handleError(
          (Object e) => throw ServerException(e.toString()),
        );
  }

  @override
  Stream<List<TaskModel>> watchTasksForDay(
    String userId,
    DateTime day,
  ) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));

    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .gte('scheduled_at', start.toIso8601String())
        .lt('scheduled_at', end.toIso8601String())
        .order('scheduled_at')
        .map(_mapRows)
        .handleError(
          (Object e) => throw ServerException(e.toString()),
        );
  }

  @override
  Stream<List<TaskModel>> watchTasksByPeriod(
    String userId,
    DateTime start,
    DateTime end,
  ) {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .gte('scheduled_at', start.toIso8601String())
        .lt('scheduled_at', end.toIso8601String())
        .order('scheduled_at')
        .map(_mapRows)
        .handleError(
          (Object e) => throw ServerException(e.toString()),
        );
  }

  @override
  Future<TaskModel?> getTaskById(String taskId) async {
    try {
      final data = await _client
          .from(_table)
          .select()
          .eq('id', taskId)
          .maybeSingle();

      if (data == null) {
        return null;
      }

      return TaskModel.fromSupabase(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> createTask(TaskModel task) async {
    try {
      await _client
          .from(_table)
          .insert(task.toSupabase());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    try {
      await _client
          .from(_table)
          .update(task.toSupabase())
          .eq('id', task.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await _client
          .from(_table)
          .delete()
          .eq('id', taskId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
