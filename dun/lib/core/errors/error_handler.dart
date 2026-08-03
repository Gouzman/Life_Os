import 'package:dun/core/errors/exceptions.dart';
import 'package:dun/core/errors/failures.dart';

Failure mapExceptionToFailure(Exception exception) {
  return switch (exception) {
    ServerException(:final message) => ServerFailure(message),
    CacheException(:final message) => CacheFailure(message),
    AuthException(:final message) => AuthFailure(message),
    NetworkException() => const NetworkFailure(),
    ValidationException(:final message) => ValidationFailure(
      message ?? 'Données invalides.',
    ),
    _ => const UnknownFailure(),
  };
}
