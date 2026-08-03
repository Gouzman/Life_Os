import 'package:dun/app/providers/task_providers.dart';
import 'package:dun/core/utils/result.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/usecases/create_task.dart';
import 'package:dun/features/tasks/domain/usecases/delete_task.dart';
import 'package:dun/features/tasks/domain/usecases/get_task_by_id.dart';
import 'package:dun/features/tasks/domain/usecases/update_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

sealed class TaskDetailState {
  const TaskDetailState();
}

class TaskDetailInitial extends TaskDetailState {
  const TaskDetailInitial();
}

class TaskDetailLoading extends TaskDetailState {
  const TaskDetailLoading();
}

class TaskDetailLoaded extends TaskDetailState {
  const TaskDetailLoaded(this.task);

  final Task task;
}

class TaskDetailSaved extends TaskDetailState {
  const TaskDetailSaved();
}

class TaskDetailDeleted extends TaskDetailState {
  const TaskDetailDeleted();
}

class TaskDetailFailure extends TaskDetailState {
  const TaskDetailFailure(this.message);

  final String message;
}

class TaskController extends Notifier<TaskDetailState> {
  late final GetTaskById _getTaskById;
  late final CreateTask _createTask;
  late final UpdateTask _updateTask;
  late final DeleteTask _deleteTask;

  @override
  TaskDetailState build() {
    _getTaskById = ref.read(getTaskByIdProvider);
    _createTask = ref.read(createTaskProvider);
    _updateTask = ref.read(updateTaskProvider);
    _deleteTask = ref.read(deleteTaskProvider);

    return const TaskDetailInitial();
  }

  Future<void> loadTask(String taskId) async {
    state = const TaskDetailLoading();
    final result = await _getTaskById(taskId);
    result.when(
      success: (task) => state = task != null
          ? TaskDetailLoaded(task)
          : const TaskDetailFailure('Tâche introuvable.'),
      failure: (failure) => state = TaskDetailFailure(failure.message),
    );
  }

  Future<Result<void>> saveTask(Task task) async {
    state = const TaskDetailLoading();
    final result = task.id.isEmpty
        ? await _createTask(task)
        : await _updateTask(task);

    result.when(
      success: (_) => state = const TaskDetailSaved(),
      failure: (failure) => state = TaskDetailFailure(failure.message),
    );

    return result;
  }

  Future<Result<void>> deleteTask(String taskId) async {
    state = const TaskDetailLoading();
    final result = await _deleteTask(taskId);

    result.when(
      success: (_) => state = const TaskDetailDeleted(),
      failure: (failure) => state = TaskDetailFailure(failure.message),
    );

    return result;
  }
}
