import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dun/features/tasks/domain/entities/task.dart';
import 'package:dun/features/tasks/domain/entities/task_status.dart';

class TaskModel {
  const TaskModel({
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
    this.pausedDurationMinutes = 0,
    this.pauseCount = 0,
    required this.expectedDurationMinutes,
    this.actualDurationMinutes,
    this.postponeCount = 0,
    this.status = 'pending',
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
  final int pausedDurationMinutes;
  final int pauseCount;
  final int expectedDurationMinutes;
  final int? actualDurationMinutes;
  final int postponeCount;
  final String status;
  final String? notes;
  final int priority;
  final bool archived;

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      scheduledAt: (json['scheduledAt'] as Timestamp).toDate(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      startedAt: (json['startedAt'] as Timestamp?)?.toDate(),
      completedAt: (json['completedAt'] as Timestamp?)?.toDate(),
      lastPostponedAt:
          (json['lastPostponedAt'] as Timestamp?)?.toDate(),
      pausedAt: (json['pausedAt'] as Timestamp?)?.toDate(),
      pausedDurationMinutes:
          json['pausedDurationMinutes'] as int? ?? 0,
      pauseCount: json['pauseCount'] as int? ?? 0,
      expectedDurationMinutes:
          json['expectedDurationMinutes'] as int,
      actualDurationMinutes:
          json['actualDurationMinutes'] as int?,
      postponeCount:
          json['postponeCount'] as int? ?? 0,
      status:
          json['status'] as String? ?? 'pending',
      notes: json['notes'] as String?,
      priority:
          json['priority'] as int? ?? 0,
      archived:
          json['archived'] as bool? ?? false,
    );
  }

  factory TaskModel.fromSupabase(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      startedAt: json['started_at'] != null
          ? DateTime.parse(json['started_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      lastPostponedAt: json['last_postponed_at'] != null
          ? DateTime.parse(json['last_postponed_at'] as String)
          : null,
      pausedAt: json['paused_at'] != null
          ? DateTime.parse(json['paused_at'] as String)
          : null,
      pausedDurationMinutes:
          json['paused_duration_minutes'] as int? ?? 0,
      pauseCount:
          json['pause_count'] as int? ?? 0,
      expectedDurationMinutes:
          json['expected_duration_minutes'] as int,
      actualDurationMinutes:
          json['actual_duration_minutes'] as int?,
      postponeCount:
          json['postpone_count'] as int? ?? 0,
      status:
          json['status'] as String? ?? 'pending',
      notes: json['notes'] as String?,
      priority:
          json['priority'] as int? ?? 0,
      archived:
          json['archived'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'scheduledAt': Timestamp.fromDate(scheduledAt),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'startedAt':
          startedAt != null ? Timestamp.fromDate(startedAt!) : null,
      'completedAt':
          completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'lastPostponedAt': lastPostponedAt != null
          ? Timestamp.fromDate(lastPostponedAt!)
          : null,
      'pausedAt':
          pausedAt != null ? Timestamp.fromDate(pausedAt!) : null,
      'pausedDurationMinutes': pausedDurationMinutes,
      'pauseCount': pauseCount,
      'expectedDurationMinutes': expectedDurationMinutes,
      'actualDurationMinutes': actualDurationMinutes,
      'postponeCount': postponeCount,
      'status': status,
      'notes': notes,
      'priority': priority,
      'archived': archived,
    };
  }

  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'scheduled_at': scheduledAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'last_postponed_at':
          lastPostponedAt?.toIso8601String(),
      'paused_at': pausedAt?.toIso8601String(),
      'paused_duration_minutes': pausedDurationMinutes,
      'pause_count': pauseCount,
      'expected_duration_minutes':
          expectedDurationMinutes,
      'actual_duration_minutes':
          actualDurationMinutes,
      'postpone_count': postponeCount,
      'status': status,
      'notes': notes,
      'priority': priority,
      'archived': archived,
    };
  }

  Task toEntity() {
    return Task(
      id: id,
      userId: userId,
      title: title,
      description: description,
      scheduledAt: scheduledAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      startedAt: startedAt,
      completedAt: completedAt,
      lastPostponedAt: lastPostponedAt,
      pausedAt: pausedAt,
      pausedDuration: Duration(minutes: pausedDurationMinutes),
      pauseCount: pauseCount,
      expectedDuration:
          Duration(minutes: expectedDurationMinutes),
      actualDuration: actualDurationMinutes != null
          ? Duration(minutes: actualDurationMinutes!)
          : null,
      postponeCount: postponeCount,
      status: TaskStatus.fromValue(status),
      notes: notes,
      priority: priority,
      archived: archived,
    );
  }

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      userId: task.userId,
      title: task.title,
      description: task.description,
      scheduledAt: task.scheduledAt,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      startedAt: task.startedAt,
      completedAt: task.completedAt,
      lastPostponedAt: task.lastPostponedAt,
      pausedAt: task.pausedAt,
      pausedDurationMinutes:
          task.pausedDuration.inMinutes,
      pauseCount: task.pauseCount,
      expectedDurationMinutes:
          task.expectedDuration.inMinutes,
      actualDurationMinutes:
          task.actualDuration?.inMinutes,
      postponeCount: task.postponeCount,
      status: task.status.value,
      notes: task.notes,
      priority: task.priority,
      archived: task.archived,
    );
  }

  TaskModel copyWith({
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
    int? pausedDurationMinutes,
    int? pauseCount,
    int? expectedDurationMinutes,
    int? actualDurationMinutes,
    int? postponeCount,
    String? status,
    String? notes,
    int? priority,
    bool? archived,
  }) {
    return TaskModel(
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
      pausedDurationMinutes:
          pausedDurationMinutes ?? this.pausedDurationMinutes,
      pauseCount: pauseCount ?? this.pauseCount,
      expectedDurationMinutes:
          expectedDurationMinutes ?? this.expectedDurationMinutes,
      actualDurationMinutes:
          actualDurationMinutes ?? this.actualDurationMinutes,
      postponeCount: postponeCount ?? this.postponeCount,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      priority: priority ?? this.priority,
      archived: archived ?? this.archived,
    );
  }
}
