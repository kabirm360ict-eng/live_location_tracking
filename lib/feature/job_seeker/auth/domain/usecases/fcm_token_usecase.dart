import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/fcm_token_entity.dart';
import '../repositories/auth_repositories.dart';

@injectable
class FcmTokenUsecase {
  final AuthRepositories authRepositories;
  FcmTokenUsecase(this.authRepositories);

  Future<Either<Failure, bool>> call(FcmTokenEntity entity) {
    return authRepositories.fcmToken(entity);
  }
}
