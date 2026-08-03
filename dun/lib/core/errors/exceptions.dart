class ServerException implements Exception {
  const ServerException([this.message]);

  final String? message;

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  const CacheException([this.message]);

  final String? message;

  @override
  String toString() => 'CacheException: $message';
}

class AuthException implements Exception {
  const AuthException([this.message]);

  final String? message;

  @override
  String toString() => 'AuthException: $message';
}

class NetworkException implements Exception {
  const NetworkException([this.message]);

  final String? message;

  @override
  String toString() => 'NetworkException: $message';
}

class ValidationException implements Exception {
  const ValidationException([this.message]);

  final String? message;

  @override
  String toString() => 'ValidationException: $message';
}
