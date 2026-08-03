import 'package:dun/app/providers/global_providers.dart';
import 'package:dun/core/network/connectivity_service.dart';
import 'package:dun/features/tasks/data/datasources/firestore_task_datasource.dart';
import 'package:dun/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:dun/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:dun/features/tasks/domain/repositories/task_repository.dart';
import 'package:dun/features/tasks/domain/usecases/change_task_status.dart';
import 'package:dun/features/tasks/domain/usecases/create_task.dart';
import 'package:dun/features/tasks/domain/usecases/delete_task.dart';
import 'package:dun/features/tasks/domain/usecases/get_task_by_id.dart';
import 'package:dun/features/tasks/domain/usecases/update_task.dart';
import 'package:dun/features/tasks/domain/usecases/watch_task.dart';
import 'package:dun/features/tasks/domain/usecases/watch_tasks.dart';
import 'package:dun/features/tasks/domain/usecases/watch_tasks_by_period.dart';
import 'package:dun/features/tasks/domain/usecases/watch_tasks_for_day.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref) {
  return FirestoreTaskDataSource(firestore: ref.read(firestoreProvider));
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(
    remoteDataSource: ref.read(taskRemoteDataSourceProvider),
    connectivityService: ref.read(connectivityServiceProvider),
  );
});

final watchTasksProvider = Provider<WatchTasks>((ref) {
  return WatchTasks(ref.read(taskRepositoryProvider));
});

final watchTaskProvider = Provider<WatchTask>((ref) {
  return WatchTask(ref.read(taskRepositoryProvider));
});

final watchTasksForDayProvider = Provider<WatchTasksForDay>((ref) {
  return WatchTasksForDay(ref.read(taskRepositoryProvider));
});

final watchTasksByPeriodProvider = Provider<WatchTasksByPeriod>((ref) {
  return WatchTasksByPeriod(ref.read(taskRepositoryProvider));
});

final getTaskByIdProvider = Provider<GetTaskById>((ref) {
  return GetTaskById(ref.read(taskRepositoryProvider));
});

final createTaskProvider = Provider<CreateTask>((ref) {
  return CreateTask(ref.read(taskRepositoryProvider));
});

final updateTaskProvider = Provider<UpdateTask>((ref) {
  return UpdateTask(ref.read(taskRepositoryProvider));
});

final deleteTaskProvider = Provider<DeleteTask>((ref) {
  return DeleteTask(ref.read(taskRepositoryProvider));
});

final changeTaskStatusProvider = Provider<ChangeTaskStatus>((ref) {
  return ChangeTaskStatus(ref.read(taskRepositoryProvider));
});
