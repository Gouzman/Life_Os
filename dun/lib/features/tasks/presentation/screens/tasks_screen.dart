import 'package:dun/app/providers/auth_state_provider.dart';
import 'package:dun/app/router/router_paths.dart';
import 'package:dun/core/extensions/build_context_x.dart';
import 'package:dun/core/widgets/app_scaffold.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/entities/task_status.dart';
import 'package:dun/features/tasks/presentation/controllers/task_controller.dart';
import 'package:dun/features/tasks/presentation/providers/task_provider.dart';
import 'package:dun/features/tasks/presentation/widgets/task_card.dart';
import 'package:dun/shared/buttons/app_button.dart';
import 'package:dun/shared/dialogs/app_dialog.dart';
import 'package:dun/shared/loaders/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final taskAsync = user != null
        ? ref.watch(tasksStreamProvider(user.id))
        : const AsyncValue<List<Task>>.loading();

    ref.listen<TaskState>(taskControllerProvider, (previous, next) {
      if (next is TaskFailure) {
        showAppDialog(context: context, title: 'Erreur', message: next.message);
      }
    });

    return AppScaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'Mes tâches',
              style: context.text.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              DateFormat.yMMMMEEEEd().format(DateTime.now()),
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(RouterPaths.createTask),
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle tâche'),
      ),
      body: _buildBody(context, ref, taskAsync, user?.id),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Task>> taskAsync,
    String? userId,
  ) {
    return taskAsync.when(
      loading: () => const AppLoader(),
      error: (error, stackTrace) => _buildError(context, error.toString()),
      data: (tasks) => _buildTaskList(context, ref, tasks, userId),
    );
  }

  Widget _buildTaskList(
    BuildContext context,
    WidgetRef ref,
    List<Task> tasks,
    String? userId,
  ) {
    if (tasks.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        if (userId != null) {
          ref.invalidate(tasksStreamProvider(userId));
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: TaskCard(
              task: task,
              onTap: () => context.push('${RouterPaths.tasks}/${task.id}'),
              onComplete: () => _changeStatus(ref, task, TaskStatus.completed),
              onCancel: () => _changeStatus(ref, task, TaskStatus.cancelled),
              onDelete: () => _deleteTask(ref, task.id),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: context.colors.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 20),
            Text(
              'Aucune tâche pour aujourd\'hui',
              style: context.text.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Créez votre première tâche pour commencer la journée.',
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: context.colors.error),
            const SizedBox(height: 16),
            Text(
              'Une erreur est survenue',
              style: context.text.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(label: 'Réessayer', onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Future<void> _changeStatus(
    WidgetRef ref,
    Task task,
    TaskStatus status,
  ) async {
    await ref.read(taskControllerProvider.notifier).changeStatus(task, status);
  }

  Future<void> _deleteTask(WidgetRef ref, String taskId) async {
    await ref.read(taskControllerProvider.notifier).deleteTask(taskId);
  }
}
