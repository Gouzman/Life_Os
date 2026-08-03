import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure();

  String get message => 'Une erreur est survenue.';
}

class ServerFailure extends Failure {
  const ServerFailure([this.errorMessage]);

  final String? errorMessage;

  @override
  String get message => errorMessage ?? 'Erreur serveur.';

  @override
  List<Object?> get props => [errorMessage];
}

class CacheFailure extends Failure {
  const CacheFailure([this.errorMessage]);

  final String? errorMessage;

  @override
  String get message => errorMessage ?? 'Erreur de cache locale.';

  @override
  List<Object?> get props => [errorMessage];
}

class AuthFailure extends Failure {
  const AuthFailure([this.errorMessage]);

  final String? errorMessage;

  @override
  String get message => errorMessage ?? 'Erreur d\'authentification.';

  @override
  List<Object?> get props => [errorMessage];
}

class NetworkFailure extends Failure {
  const NetworkFailure();

  @override
  String get message => 'Connexion internet indisponible.';

  @override
  List<Object?> get props => [];
}

class ValidationFailure extends Failure {
  const ValidationFailure(this.errorMessage);

  final String errorMessage;

  @override
  String get message => errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

class UnknownFailure extends Failure {
  const UnknownFailure([this.errorMessage]);

  final String? errorMessage;

  @override
  String get message => errorMessage ?? 'Erreur inattendue.';

  @override
  List<Object?> get props => [errorMessage];
}
