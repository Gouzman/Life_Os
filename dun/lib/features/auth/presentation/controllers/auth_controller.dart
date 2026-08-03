import 'package:dun/app/providers/repository_providers.dart';
import 'package:dun/core/usecase/usecase.dart';
import 'package:dun/features/auth/domain/entities/app_user.dart';
import 'package:dun/features/auth/domain/usecases/auth_state_changes.dart';
import 'package:dun/features/auth/domain/usecases/get_current_user.dart';
import 'package:dun/features/auth/domain/usecases/sign_in_anonymous.dart';
import 'package:dun/features/auth/domain/usecases/sign_out.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final AppUser user;
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthFailureState extends AuthState {
  const AuthFailureState(this.message);

  final String message;
}

class AuthController extends Notifier<AuthState> {
  late final SignInAnonymous _signInAnonymous;
  late final SignOut _signOut;
  late final GetCurrentUser _getCurrentUser;
  late final AuthStateChanges _authStateChanges;

  @override
  AuthState build() {
    final repository = ref.read(authRepositoryProvider);
    _signInAnonymous = SignInAnonymous(repository);
    _signOut = SignOut(repository);
    _getCurrentUser = GetCurrentUser(repository);
    _authStateChanges = AuthStateChanges(repository);

    _subscribeToAuthChanges(_authStateChanges);

    return const AuthInitial();
  }

  void _subscribeToAuthChanges(AuthStateChanges authStateChanges) {
    authStateChanges().listen((user) {
      if (user == null) {
        state = const AuthUnauthenticated();
      } else {
        state = AuthAuthenticated(user);
      }
    });
  }

  Future<void> signInAnonymously() async {
    state = const AuthLoading();
    final result = await _signInAnonymous(const NoParams());
    result.when(
      success: (user) => state = AuthAuthenticated(user),
      failure: (failure) => state = AuthFailureState(failure.message),
    );
  }

  Future<void> signOut() async {
    state = const AuthLoading();
    final result = await _signOut(const NoParams());
    result.when(
      success: (_) => state = const AuthUnauthenticated(),
      failure: (failure) => state = AuthFailureState(failure.message),
    );
  }

  Future<void> checkCurrentUser() async {
    state = const AuthLoading();
    final result = await _getCurrentUser(const NoParams());
    result.when(
      success: (user) {
        state = user != null
            ? AuthAuthenticated(user)
            : const AuthUnauthenticated();
      },
      failure: (failure) => state = AuthFailureState(failure.message),
    );
  }
}
