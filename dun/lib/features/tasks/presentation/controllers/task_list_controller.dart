import 'package:dun/app/providers/auth_state_provider.dart';
import 'package:dun/app/providers/task_providers.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

sealed class TaskListState {
  const TaskListState();
}

class TaskListInitial extends TaskListState {
  const TaskListInitial();
}

class TaskListLoading extends TaskListState {
  const TaskListLoading();
}

class TaskListLoaded extends TaskListState {
  const TaskListLoaded(this.tasks);

  final List<Task> tasks;
}

class TaskListFailure extends TaskListState {
  const TaskListFailure(this.message);

  final String message;
}

class TaskListController extends Notifier<TaskListState> {
  @override
  TaskListState build() {
    final authAsync = ref.watch(authStateProvider);
    final user = authAsync.value;
    if (user == null) {
      return const TaskListFailure('Utilisateur non authentifié.');
    }

    final watchTasksForToday = ref.read(watchTasksForTodayProvider);

    watchTasksForToday(user.id).listen(
      (tasks) => state = TaskListLoaded(tasks),
      onError: (Object e) => state = TaskListFailure(e.toString()),
    );

    return const TaskListLoading();
  }
}
