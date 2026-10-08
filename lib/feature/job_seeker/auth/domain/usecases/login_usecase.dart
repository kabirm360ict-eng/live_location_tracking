import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/job_seeker_login_response_entity.dart';
import '../entities/login_request_job_entity.dart';
import '../repositories/auth_repositories.dart';

@injectable
class LoginUsecase {
  final AuthRepositories authRepositories;
  LoginUsecase(this.authRepositories);

  Future<Either<Failure, JobSeekerLoginResponseEntity>> call(LoginRequestJobEntity entity) {
    return authRepositories.login(entity);
  }
}