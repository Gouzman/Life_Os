import 'package:dun/core/errors/failures.dart';
import 'package:equatable/equatable.dart';

sealed class Result<T> extends Equatable {
  const Result();

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is FailureResult<T>;

  T? get valueOrNull => switch (this) {
    Success<T>(value: final value) => value,
    _ => null,
  };

  Failure? get failureOrNull => switch (this) {
    FailureResult<T>(failure: final f) => f,
    _ => null,
  };

  R when<R>({
    required R Function(T value) success,
    required R Function(Failure failure) failure,
  }) {
    return switch (this) {
      Success<T>(value: final value) => success(value),
      FailureResult<T>(failure: final f) => failure(f),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;

  @override
  List<Object?> get props => [value];
}

final class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
