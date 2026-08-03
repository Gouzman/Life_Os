import 'package:dun/core/utils/result.dart';
import 'package:dun/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> get authStateChanges;

  Future<Result<AppUser>> signInAnonymously();

  Future<Result<void>> signOut();

  Future<Result<AppUser?>> getCurrentUser();
}
