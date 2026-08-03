import 'package:dun/app/providers/task_providers.dart';
import 'package:dun/core/utils/result.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/entities/task_status.dart';
import 'package:dun/features/tasks/domain/usecases/change_task_status.dart';
import 'package:dun/features/tasks/domain/usecases/create_task.dart';
import 'package:dun/features/tasks/domain/usecases/delete_task.dart';
import 'package:dun/features/tasks/domain/usecases/get_task_by_id.dart';
import 'package:dun/features/tasks/domain/usecases/update_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

sealed class TaskState {
  const TaskState();
}

class TaskInitial extends TaskState {
  const TaskInitial();
}

class TaskLoading extends TaskState {
  const TaskLoading();
}

class TaskLoaded extends TaskState {
  const TaskLoaded(this.task);

  final Task task;
}

class TaskSaved extends TaskState {
  const TaskSaved();
}

class TaskDeleted extends TaskState {
  const TaskDeleted();
}

class TaskFailure extends TaskState {
  const TaskFailure(this.message);

  final String message;
}

class TaskController extends Notifier<TaskState> {
  late final GetTaskById _getTaskById;
  late final CreateTask _createTask;
  late final UpdateTask _updateTask;
  late final DeleteTask _deleteTask;
  late final ChangeTaskStatus _changeTaskStatus;

  @override
  TaskState build() {
    _getTaskById = ref.read(getTaskByIdProvider);
    _createTask = ref.read(createTaskProvider);
    _updateTask = ref.read(updateTaskProvider);
    _deleteTask = ref.read(deleteTaskProvider);
    _changeTaskStatus = ref.read(changeTaskStatusProvider);

    return const TaskInitial();
  }

  Future<void> loadTask(String taskId) async {
    state = const TaskLoading();
    final result = await _getTaskById(GetTaskByIdParams(taskId: taskId));
    result.when(
      success: (task) => state = task != null
          ? TaskLoaded(task)
          : const TaskFailure('Tâche introuvable.'),
      failure: (failure) => state = TaskFailure(failure.message),
    );
  }

  Future<Result<void>> createTask(Task task) async {
    state = const TaskLoading();
    final result = await _createTask(CreateTaskParams(task: task));
    result.when(
      success: (_) => state = const TaskSaved(),
      failure: (failure) => state = TaskFailure(failure.message),
    );
    return result;
  }

  Future<Result<void>> updateTask(Task task) async {
    state = const TaskLoading();
    final result = await _updateTask(UpdateTaskParams(task: task));
    result.when(
      success: (_) => state = const TaskSaved(),
      failure: (failure) => state = TaskFailure(failure.message),
    );
    return result;
  }

  Future<Result<void>> deleteTask(String taskId) async {
    state = const TaskLoading();
    final result = await _deleteTask(DeleteTaskParams(taskId: taskId));
    result.when(
      success: (_) => state = const TaskDeleted(),
      failure: (failure) => state = TaskFailure(failure.message),
    );
    return result;
  }

  Future<Result<void>> changeStatus(Task task, TaskStatus newStatus) async {
    state = const TaskLoading();
    final result = await _changeTaskStatus(
      ChangeTaskStatusParams(task: task, newStatus: newStatus),
    );
    result.when(
      success: (_) => state = const TaskSaved(),
      failure: (failure) => state = TaskFailure(failure.message),
    );
    return result;
  }
}
