import 'package:dun/app/providers/auth_state_provider.dart';
import 'package:dun/app/providers/global_providers.dart';
import 'package:dun/app/router/router_paths.dart';
import 'package:dun/core/widgets/app_scaffold.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/entities/task_status.dart';
import 'package:dun/features/tasks/presentation/controllers/task_controller.dart';
import 'package:dun/features/tasks/presentation/providers/task_provider.dart';
import 'package:dun/shared/buttons/app_button.dart';
import 'package:dun/shared/inputs/app_text_field.dart';
import 'package:dun/shared/loaders/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  const TaskFormScreen({super.key, this.taskId});

  final String? taskId;

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _scheduledAt = DateTime.now();
  int _durationMinutes = 30;
  int _priority = 0;
  bool _isPopulated = false;

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(taskControllerProvider.notifier).loadTask(widget.taskId!);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskControllerProvider);

    return AppScaffold(
      appBar: AppBar(
        title: Text(
          widget.taskId == null ? 'Nouvelle tâche' : 'Modifier la tâche',
        ),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(TaskState state) {
    if (state is TaskLoaded && !_isPopulated) {
      _populateFields(state.task);
    }

    return switch (state) {
      TaskInitial() || TaskLoading() => const AppLoader(),
      TaskFailure(:final message) => Center(child: Text(message)),
      TaskLoaded() || TaskSaved() || TaskDeleted() => _buildForm(),
    };
  }

  void _populateFields(Task task) {
    _titleController.text = task.title;
    _descriptionController.text = task.description ?? '';
    _notesController.text = task.notes ?? '';
    _scheduledAt = task.scheduledAt;
    _durationMinutes = task.expectedDuration.inMinutes;
    _priority = task.priority;
    _isPopulated = true;
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: _titleController,
              labelText: 'Titre',
              hintText: 'Nom de la tâche',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le titre est requis';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _descriptionController,
              labelText: 'Description',
              hintText: 'Description optionnelle',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Date et heure'),
              subtitle: Text(_formatDateTime(_scheduledAt)),
              onTap: _pickDateTime,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.timelapse),
              title: const Text('Durée prévue'),
              subtitle: Text('$_durationMinutes minutes'),
              onTap: _pickDuration,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _notesController,
              labelText: 'Notes',
              hintText: 'Notes complémentaires',
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            AppButton(
              label: widget.taskId == null ? 'Créer' : 'Enregistrer',
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledAt,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt),
    );
    if (time == null || !mounted) return;

    setState(() {
      _scheduledAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _pickDuration() async {
    final values = [15, 30, 45, 60, 90, 120, 180, 240];
    final selected = await showModalBottomSheet<int>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: values
              .map(
                (value) => ListTile(
                  title: Text('$value minutes'),
                  trailing: value == _durationMinutes
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () => Navigator.of(context).pop(value),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (selected != null) {
      setState(() => _durationMinutes = selected);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final state = ref.read(taskControllerProvider);
    final now = ref.read(nowProvider)();
    final uuid = ref.read(uuidProvider);

    final existingTask = state is TaskLoaded ? state.task : null;

    final task = Task(
      id: existingTask?.id ?? uuid.v4(),
      userId: user.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      scheduledAt: _scheduledAt,
      createdAt: existingTask?.createdAt ?? now,
      updatedAt: now,
      expectedDuration: Duration(minutes: _durationMinutes),
      postponeCount: existingTask?.postponeCount ?? 0,
      status: existingTask?.status ?? TaskStatus.pending,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      priority: _priority,
      archived: existingTask?.archived ?? false,
    );

    final result = task.id.isEmpty
        ? await ref.read(taskControllerProvider.notifier).createTask(task)
        : await ref.read(taskControllerProvider.notifier).updateTask(task);

    if (mounted && result.isSuccess) {
      context.go(RouterPaths.tasks);
    }
  }
}
