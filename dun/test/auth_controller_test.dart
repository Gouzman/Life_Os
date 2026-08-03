import 'package:dun/features/auth/domain/entities/app_user.dart';
import 'package:dun/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AuthController initial state is AuthInitial', () {
    const state = AuthInitial();
    expect(state, const AuthInitial());
  });

  test('AuthAuthenticated holds a user', () {
    final user = AppUser(
      id: 'uid-1',
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

    final state = AuthAuthenticated(user);
    expect(state.user, user);
  });
}
