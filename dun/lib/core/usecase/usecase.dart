import 'package:dun/core/utils/result.dart';

abstract class UseCase<T, Params> {
  const UseCase();

  Future<Result<T>> call(Params params);
}

class NoParams {
  const NoParams();
}
