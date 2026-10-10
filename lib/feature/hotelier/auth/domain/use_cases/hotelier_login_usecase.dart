import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/failures.dart';
import '../entity/hotelier_login_response_entity.dart';
import '../entity/login_request_hotelier_entity.dart';
import '../repository/hotelier_auth_repository.dart';

@injectable
class HotelierLoginUseCase {
  final HotelierAuthRepository repository;
  HotelierLoginUseCase(this.repository);

  Future<Either<Failure, HotelierLoginResponseEntity>> call(LoginRequestHotelierEntity entity) {
    return repository.login(entity);
  }
}
