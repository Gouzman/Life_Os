import 'package:dun/core/errors/error_handler.dart';
import 'package:dun/core/errors/failures.dart';
import 'package:dun/core/network/connectivity_service.dart';
import 'package:dun/core/utils/result.dart';
import 'package:dun/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:dun/features/auth/domain/entities/app_user.dart';
import 'package:dun/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required ConnectivityService connectivityService,
  }) : _remoteDataSource = remoteDataSource,
       _connectivityService = connectivityService;

  final AuthRemoteDataSource _remoteDataSource;
  final ConnectivityService _connectivityService;

  @override
  Stream<AppUser?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map((model) => model?.toEntity());
  }

  @override
  Future<Result<AppUser>> signInAnonymously() async {
    return _execute(() async {
      final model = await _remoteDataSource.signInAnonymously();
      return model.toEntity();
    });
  }

  @override
  Future<Result<void>> signOut() async {
    return _execute(() async {
      await _remoteDataSource.signOut();
    });
  }

  @override
  Future<Result<AppUser?>> getCurrentUser() async {
    return _execute(() async {
      final model = await _remoteDataSource.getCurrentUser();
      return model?.toEntity();
    });
  }

  Future<Result<T>> _execute<T>(Future<T> Function() action) async {
    try {
      if (!await _connectivityService.isConnected) {
        return const FailureResult(NetworkFailure());
      }
      final result = await action();
      return Success(result);
    } on Exception catch (e) {
      return FailureResult(mapExceptionToFailure(e));
    }
  }
}
