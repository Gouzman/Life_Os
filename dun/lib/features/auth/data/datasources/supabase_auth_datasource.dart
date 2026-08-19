import 'package:dun/core/errors/exceptions.dart';
import 'package:dun/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:dun/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class SupabaseAuthDataSource implements AuthRemoteDataSource {
  SupabaseAuthDataSource({
    required supabase.SupabaseClient client,
  }) : _client = client;

  final supabase.SupabaseClient _client;

  @override
  Stream<UserModel?> get authStateChanges {
    return _client.auth.onAuthStateChange.asyncMap((data) async {
      final user = data.session?.user;

      if (user == null) {
        return null;
      }

      return _fetchUser(user.id);
    });
  }

  @override
  Future<UserModel> signInAnonymously() async {
    try {
      final response = await _client.auth.signInAnonymously();
      final user = response.user;

      if (user == null) {
        throw const AuthException(
          'Échec de l\'authentification anonyme.',
        );
      }

      final existing = await _fetchUser(user.id);

      if (existing != null) {
        return existing;
      }

      final now = DateTime.now();

      final newUser = UserModel(
        id: user.id,
        createdAt: now,
        updatedAt: now,
      );

      await saveUser(newUser);

      return newUser;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      return null;
    }

    return _fetchUser(user.id);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      await _client.from('profiles').upsert({
        'id': user.id,
        'display_name': user.displayName,
        'created_at': user.createdAt.toIso8601String(),
        'updated_at': user.updatedAt.toIso8601String(),
        'onboarding_completed': user.onboardingCompleted,
        'preferred_theme': user.preferredTheme,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<UserModel?> _fetchUser(String userId) async {
    try {
      final data = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (data == null) {
        return null;
      }

      return UserModel.fromSupabase(data);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

