import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entity/hotelier_login_response_entity.dart';
import '../entity/login_request_hotelier_entity.dart';

abstract class HotelierAuthRepository {
  Future<Either<Failure, HotelierLoginResponseEntity>> login(LoginRequestHotelierEntity entity);
  Future<Either<Failure, bool>> logout();
}
