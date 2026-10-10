import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entity/hotelier_login_response_entity.dart';
import '../../domain/entity/login_request_hotelier_entity.dart';
import '../../domain/repository/hotelier_auth_repository.dart';
import '../model/login_request_hotelier_model.dart';
import '../remote_data_source/hotelier_auth_remote_datasource.dart';

@LazySingleton(as: HotelierAuthRepository)
class HotelierAuthRepositoryImpl implements HotelierAuthRepository {
  final HotelierAuthRemoteDataSource remoteDataSource;

  HotelierAuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, HotelierLoginResponseEntity>> login(
    LoginRequestHotelierEntity entity,
  ) async {
    try {
      final response = await remoteDataSource.login(
        payload: LoginRequestHotelierModel.fromEntity(entity),
      );
      return Right(response.toEntity());
    } catch (e, stackTrace) {
      return Left(handleException(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(true);
    } catch (e, stackTrace) {
      return Left(handleException(e, stackTrace));
    }
  }
}
