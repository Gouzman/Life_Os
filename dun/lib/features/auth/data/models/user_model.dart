import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dun/features/auth/domain/entities/app_user.dart';

class UserModel {
  const UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      displayName: json['displayName'] as String?,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      onboardingCompleted:
          json['onboardingCompleted'] as bool? ?? false,
      preferredTheme:
          json['preferredTheme'] as String? ?? 'system',
    );
  }

  factory UserModel.fromSupabase(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      displayName: json['display_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      onboardingCompleted:
          json['onboarding_completed'] as bool? ?? false,
      preferredTheme:
          json['preferred_theme'] as String? ?? 'system',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'onboardingCompleted': onboardingCompleted,
      'preferredTheme': preferredTheme,
    };
  }

  AppUser toEntity() {
    return AppUser(
      id: id,
      displayName: displayName,
      createdAt: createdAt,
      updatedAt: updatedAt,
      onboardingCompleted: onboardingCompleted,
      preferredTheme: preferredTheme,
    );
  }

  factory UserModel.fromEntity(AppUser user) {
    return UserModel(
      id: user.id,
      displayName: user.displayName,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      onboardingCompleted: user.onboardingCompleted,
      preferredTheme: user.preferredTheme,
    );
  }
}
