import 'package:dun/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;

  Future<UserModel> signInAnonymously();

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Future<void> saveUser(UserModel user);
}
