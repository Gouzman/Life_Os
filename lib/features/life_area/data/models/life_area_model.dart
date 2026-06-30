import '../../domain/entities/life_area.dart';

class LifeAreaModel extends LifeArea {
  const LifeAreaModel({
    required super.id,
    required super.name,
    required super.iconKey,
    required super.colorToken,
    super.order,
    super.isArchived,
  });

  factory LifeAreaModel.fromJson(Map<String, Object?> json) {
    return LifeAreaModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconKey: json['iconKey'] as String,
      colorToken: json['colorToken'] as String,
      order: json['order'] as int? ?? 0,
      isArchived: json['isArchived'] as bool? ?? false,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'iconKey': iconKey,
      'colorToken': colorToken,
      'order': order,
      'isArchived': isArchived,
    };
  }
}
