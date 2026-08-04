import 'package:dun/core/domain/base_entity.dart';
import 'package:dun/features/tasks/domain/entities/task_status.dart';

import '../services/execution_action.dart';

class Task extends BaseEntity {
  const Task({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.scheduledAt,
    required this.createdAt,
    required this.updatedAt,
    this.startedAt,
    this.completedAt,
    this.lastPostponedAt,
    this.pausedAt,
    this.pausedDuration = Duration.zero,
    this.pauseCount = 0,
    required this.expectedDuration,
    this.actualDuration,
    this.postponeCount = 0,
    this.status = TaskStatus.pending,
    this.notes,
    this.priority = 0,
    this.archived = false,
  });

  final String id;
  final String userId;
  final String title;
  final String? description;
  final DateTime scheduledAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? lastPostponedAt;
  final DateTime? pausedAt;
  final Duration pausedDuration;
  final int pauseCount;
  final Duration expectedDuration;
  final Duration? actualDuration;
  final int postponeCount;
  final TaskStatus status;
  final String? notes;
  final int priority;
  final bool archived;

  bool get isOverdue =>
      status != TaskStatus.completed &&
      status != TaskStatus.cancelled &&
      scheduledAt.isBefore(DateTime.now());

  bool get canBePostponed => postponeCount < 3;

  /// Indique si l'action [action] est autorisée depuis le statut courant.
  bool canExecute(ExecutionAction action) {
    return switch (action) {
      ExecutionAction.start =>
        status == TaskStatus.pending ||
            status == TaskStatus.inProgress ||
            status == TaskStatus.paused,
      ExecutionAction.pause => status == TaskStatus.inProgress,
      ExecutionAction.resume => status == TaskStatus.paused,
      ExecutionAction.complete =>
        status == TaskStatus.inProgress || status == TaskStatus.paused,
      ExecutionAction.cancel =>
        status != TaskStatus.completed && status != TaskStatus.cancelled,
      ExecutionAction.postpone =>
        canBePostponed &&
            status != TaskStatus.completed &&
            status != TaskStatus.cancelled &&
            status != TaskStatus.archived,
    };
  }

  /// Retourne la durée totale écoulée depuis le démarrage, en déduisant le
  /// temps passé en pause. Retourne `Duration.zero` si la tâche n'a pas
  /// démarré.
  Duration get elapsedTime {
    if (startedAt == null) return Duration.zero;
    final reference = completedAt ?? DateTime.now();
    var elapsed = reference.difference(startedAt!);
    elapsed -= pausedDuration;
    if (status == TaskStatus.paused && pausedAt != null) {
      elapsed -= DateTime.now().difference(pausedAt!);
    }
    return elapsed < Duration.zero ? Duration.zero : elapsed;
  }

  Task copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? scheduledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? lastPostponedAt,
    DateTime? pausedAt,
    Duration? pausedDuration,
    int? pauseCount,
    Duration? expectedDuration,
    Duration? actualDuration,
    int? postponeCount,
    TaskStatus? status,
    String? notes,
    int? priority,
    bool? archived,
  }) {
    return Task(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      lastPostponedAt: lastPostponedAt ?? this.lastPostponedAt,
      pausedAt: pausedAt ?? this.pausedAt,
      pausedDuration: pausedDuration ?? this.pausedDuration,
      pauseCount: pauseCount ?? this.pauseCount,
      expectedDuration: expectedDuration ?? this.expectedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      postponeCount: postponeCount ?? this.postponeCount,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      priority: priority ?? this.priority,
      archived: archived ?? this.archived,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    description,
    scheduledAt,
    createdAt,
    updatedAt,
    startedAt,
    completedAt,
    lastPostponedAt,
    pausedAt,
    pausedDuration,
    pauseCount,
    expectedDuration,
    actualDuration,
    postponeCount,
    status,
    notes,
    priority,
    archived,
  ];
}
