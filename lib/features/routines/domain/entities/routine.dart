/// Represents an ordered sequence of habit references.
class Routine {
  /// Unique identifier of the routine.
  final String id;

  /// Short user-facing title of the routine.
  final String title;

  /// Ordered list of habit identifiers.
  final List<String> habitIds;

  Routine({
    required this.id,
    required this.title,
    required List<String> habitIds,
  }) : habitIds = List.unmodifiable(habitIds);
}
