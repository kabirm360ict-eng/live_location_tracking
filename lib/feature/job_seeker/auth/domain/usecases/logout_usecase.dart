import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failures.dart';
import '../repositories/auth_repositories.dart';

@injectable
class LogoutUsecase {
  final AuthRepositories authRepositories;
  LogoutUsecase(this.authRepositories);

  Future<Either<Failure, bool>> call() {
    return authRepositories.logout();
  }
}
