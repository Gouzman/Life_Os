import 'package:dun/core/domain/base_entity.dart';

class AppUser extends BaseEntity {
  const AppUser({
    required this.id,
    this.displayName,
    required this.createdAt,
    required this.updatedAt,
    this.onboardingCompleted = false,
    this.preferredTheme = 'system',
  });

  final String id;
  final String? displayName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool onboardingCompleted;
  final String preferredTheme;

  AppUser copyWith({
    String? id,
    String? displayName,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? onboardingCompleted,
    String? preferredTheme,
  }) {
    return AppUser(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      preferredTheme: preferredTheme ?? this.preferredTheme,
    );
  }

  @override
  List<Object?> get props => [
    id,
    displayName,
    createdAt,
    updatedAt,
    onboardingCompleted,
    preferredTheme,
  ];
}
