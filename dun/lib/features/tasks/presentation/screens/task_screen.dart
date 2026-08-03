import 'package:dun/app/router/router_paths.dart';
import 'package:dun/core/widgets/app_scaffold.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/presentation/controllers/task_controller.dart';
import 'package:dun/features/tasks/presentation/providers/task_provider.dart';
import 'package:dun/features/tasks/presentation/widgets/task_status_badge.dart';
import 'package:dun/shared/loaders/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskControllerProvider.notifier).loadTask(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskControllerProvider);

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Détail de la tâche'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () =>
                context.push('${RouterPaths.tasks}/${widget.id}/edit'),
          ),
        ],
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(TaskDetailState state) {
    return switch (state) {
      TaskDetailInitial() || TaskDetailLoading() => const AppLoader(),
      TaskDetailFailure(:final message) => Center(child: Text(message)),
      TaskDetailLoaded(:final task) => _buildDetail(task),
      TaskDetailSaved() || TaskDetailDeleted() => const AppLoader(),
    };
  }

  Widget _buildDetail(Task task) {
    final dateFormat = DateFormat.yMMMMEEEEd();
    final timeFormat = DateFormat.Hm();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [TaskStatusBadge(status: task.status)]),
          const SizedBox(height: 16),
          Text(
            task.title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (task.description != null && task.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              task.description!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
          const SizedBox(height: 24),
          _InfoRow(
            icon: Icons.calendar_today,
            label: 'Planifiée le',
            value: dateFormat.format(task.scheduledAt),
          ),
          _InfoRow(
            icon: Icons.schedule,
            label: 'Heure',
            value: timeFormat.format(task.scheduledAt),
          ),
          _InfoRow(
            icon: Icons.timelapse,
            label: 'Durée prévue',
            value: '${task.expectedDuration.inMinutes} minutes',
          ),
          if (task.notes != null && task.notes!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Notes',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(task.notes!),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
