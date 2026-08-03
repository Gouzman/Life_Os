import 'package:dun/app/providers/repository_providers.dart';
import 'package:dun/features/auth/domain/entities/app_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<AppUser?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});
