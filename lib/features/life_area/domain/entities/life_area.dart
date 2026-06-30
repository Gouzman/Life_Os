/// Represents a major area of the user's life.
class LifeArea {
  /// Unique identifier of the life area.
  final String id;

  /// User-facing name of the life area.
  final String name;

  /// Stable icon token used by the presentation layer.
  final String iconKey;

  /// Hexadecimal color value stored as text, for example `#60A5FA`.
  final String colorHex;

  /// Display and planning order for this life area.
  final int order;

  /// Whether this life area is hidden from active planning.
  final bool archived;

  const LifeArea({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.colorHex,
    this.order = 0,
    this.archived = false,
  }) : assert(order >= 0, 'order must be positive or zero');
}
