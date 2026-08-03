import 'package:dun/core/domain/base_entity.dart';
import 'package:dun/features/tasks/domain/entities/task_status.dart';

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
    required this.expectedDuration,
    this.actualDuration,
    this.postponeCount = 0,
    this.status = TaskStatus.pending,
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
  final Duration expectedDuration;
  final Duration? actualDuration;
  final int postponeCount;
  final TaskStatus status;

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
    Duration? expectedDuration,
    Duration? actualDuration,
    int? postponeCount,
    TaskStatus? status,
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
      expectedDuration: expectedDuration ?? this.expectedDuration,
      actualDuration: actualDuration ?? this.actualDuration,
      postponeCount: postponeCount ?? this.postponeCount,
      status: status ?? this.status,
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
    expectedDuration,
    actualDuration,
    postponeCount,
    status,
  ];
}
