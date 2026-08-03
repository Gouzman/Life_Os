import 'package:dun/features/auth/domain/entities/app_user.dart';
import 'package:dun/features/auth/domain/repositories/auth_repository.dart';

class AuthStateChanges {
  const AuthStateChanges(this._repository);

  final AuthRepository _repository;

  Stream<AppUser?> call() {
    return _repository.authStateChanges;
  }
}
