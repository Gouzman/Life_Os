import 'package:dun/app/providers/task_providers.dart';
import 'package:dun/app/router/router_paths.dart';
import 'package:dun/core/widgets/app_scaffold.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/entities/task_status.dart';
import 'package:dun/features/tasks/domain/usecases/change_task_status.dart';
import 'package:dun/features/tasks/presentation/controllers/task_list_controller.dart';
import 'package:dun/features/tasks/presentation/providers/task_list_provider.dart';
import 'package:dun/features/tasks/presentation/widgets/task_list_tile.dart';
import 'package:dun/shared/loaders/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskListControllerProvider);

    return AppScaffold(
      appBar: AppBar(title: const Text('Mes tâches'), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouterPaths.createTask),
        icon: const Icon(Icons.add),
        label: const Text('Tâche'),
      ),
      body: _buildBody(context, ref, state),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, TaskListState state) {
    return switch (state) {
      TaskListInitial() || TaskListLoading() => const AppLoader(),
      TaskListFailure(:final message) => Center(child: Text(message)),
      TaskListLoaded(:final tasks) => _buildTaskList(context, ref, tasks),
    };
  }

  Widget _buildTaskList(BuildContext context, WidgetRef ref, List<Task> tasks) {
    if (tasks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Aucune tâche pour aujourd\'hui',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final dateFormat = DateFormat.yMMMMEEEEd();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            dateFormat.format(DateTime.now()),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskListTile(
                task: task,
                onTap: () => context.push('${RouterPaths.tasks}/${task.id}'),
                onToggleStatus: (status) => _changeStatus(ref, task, status),
                onDelete: () => _deleteTask(ref, task.id),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _changeStatus(
    WidgetRef ref,
    Task task,
    TaskStatus status,
  ) async {
    final useCase = ref.read(changeTaskStatusProvider);
    await useCase(ChangeTaskStatusParams(task: task, newStatus: status));
  }

  Future<void> _deleteTask(WidgetRef ref, String taskId) async {
    final useCase = ref.read(deleteTaskProvider);
    await useCase(taskId);
  }
}
