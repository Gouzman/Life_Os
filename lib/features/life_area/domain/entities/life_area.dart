class LifeArea {
  final String id;
  final String name;
  final String iconKey;
  final String colorToken;
  final int order;
  final bool isArchived;

  const LifeArea({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.colorToken,
    this.order = 0,
    this.isArchived = false,
  });

  LifeArea copyWith({
    String? id,
    String? name,
    String? iconKey,
    String? colorToken,
    int? order,
    bool? isArchived,
  }) {
    return LifeArea(
      id: id ?? this.id,
      name: name ?? this.name,
      iconKey: iconKey ?? this.iconKey,
      colorToken: colorToken ?? this.colorToken,
      order: order ?? this.order,
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
