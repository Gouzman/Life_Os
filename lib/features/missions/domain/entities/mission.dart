import 'mission_status.dart';
import 'preferred_period.dart';

class Mission {

  final String id;

  final String title;

  final String description;

  final String lifeAreaId;

  final Duration duration;

  final int xpReward;

  final int importance;

  final int urgency;

  final int energyRequired;

  final PreferredPeriod preferredPeriod;

  final bool isCritical;

  final MissionStatus status;

  final DateTime? scheduledStart;

  final DateTime? scheduledEnd;

  final DateTime? completedAt;

  const Mission({

    required this.id,

    required this.title,

    required this.description,

    required this.lifeAreaId,

    required this.duration,

    required this.xpReward,

    required this.importance,

    required this.urgency,

    required this.energyRequired,

    required this.preferredPeriod,

    this.isCritical = false,

    this.status = MissionStatus.pending,

    this.scheduledStart,

    this.scheduledEnd,

    this.completedAt,
  });

  double get priorityScore {

    return

      (importance * 4) +

      (urgency * 3) +

      (xpReward * 0.2) -

      (duration.inMinutes * 0.1);
  }

  Mission copyWith({

    String? id,

    String? title,

    String? description,

    String? lifeAreaId,

    Duration? duration,

    int? xpReward,

    int? importance,

    int? urgency,

    int? energyRequired,

    PreferredPeriod? preferredPeriod,

    bool? isCritical,

    MissionStatus? status,

    DateTime? scheduledStart,

    DateTime? scheduledEnd,

    DateTime? completedAt,

  }) {

    return Mission(

      id: id ?? this.id,

      title: title ?? this.title,

      description: description ?? this.description,

      lifeAreaId: lifeAreaId ?? this.lifeAreaId,

      duration: duration ?? this.duration,

      xpReward: xpReward ?? this.xpReward,

      importance: importance ?? this.importance,

      urgency: urgency ?? this.urgency,

      energyRequired: energyRequired ?? this.energyRequired,

      preferredPeriod: preferredPeriod ?? this.preferredPeriod,

      isCritical: isCritical ?? this.isCritical,

      status: status ?? this.status,

      scheduledStart: scheduledStart ?? this.scheduledStart,

      scheduledEnd: scheduledEnd ?? this.scheduledEnd,

      completedAt: completedAt ?? this.completedAt,
    );
  }
}
