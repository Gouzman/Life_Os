import 'package:dun/app/providers/global_providers.dart';
import 'package:dun/core/network/connectivity_service.dart';
import 'package:dun/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:dun/features/auth/data/datasources/firebase_auth_datasource.dart';
import 'package:dun/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dun/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return FirebaseAuthDataSource(
    auth: ref.read(firebaseAuthProvider),
    firestore: ref.read(firestoreProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
    connectivityService: ref.read(connectivityServiceProvider),
  );
});
