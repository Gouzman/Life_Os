/// Represents an objective the user wants to reach.
class Goal {
  /// Unique identifier of the goal.
  final String id;

  /// Short user-facing title of the goal.
  final String title;

  /// Detailed explanation of the expected outcome.
  final String description;

  /// Date by which the user wants to reach this goal.
  final DateTime targetDate;

  /// Planning priority from 1 to 10.
  final int priority;

  /// Identifier of the life area this goal contributes to.
  final String lifeAreaId;

  const Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDate,
    required this.priority,
    required this.lifeAreaId,
  }) : assert(
         priority >= 1 && priority <= 10,
         'priority must be between 1 and 10',
       );
}
