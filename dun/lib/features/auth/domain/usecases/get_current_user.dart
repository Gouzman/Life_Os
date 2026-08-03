import 'package:dun/core/usecase/usecase.dart';
import 'package:dun/core/utils/result.dart';
import 'package:dun/features/auth/domain/entities/app_user.dart';
import 'package:dun/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser implements UseCase<AppUser?, NoParams> {
  const GetCurrentUser(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<AppUser?>> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}
