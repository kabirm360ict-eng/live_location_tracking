import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/local_database/auth_db.dart';
import '../../domain/entities/fcm_token_entity.dart';
import '../../domain/entities/job_seeker_login_response_entity.dart';
import '../../domain/entities/login_request_job_entity.dart';
import '../../domain/repositories/auth_repositories.dart';
import '../datasource/auth_remote_datasource_job.dart';
import '../models/fcm_token_model.dart';
import '../models/login_request_model_job.dart';

@LazySingleton(as: AuthRepositories)
class AuthRepositoryImpl implements AuthRepositories {
  final AuthRemoteDataSourceJob authRemoteDataSourceJob;
  final AuthLocalDB authLocalDB;
  AuthRepositoryImpl({required this.authRemoteDataSourceJob, required this.authLocalDB});

  // login
  @override
  Future<Either<Failure, JobSeekerLoginResponseEntity>> login(LoginRequestJobEntity entity) async {
    try {
      final response = await authRemoteDataSourceJob.login(payload: LoginRequestJobModel.fromEntity(entity));
      return Right(JobSeekerLoginResponseEntity(
        userId: response.userId,
        name: response.name,
        email: response.email,
        phoneNumber: response.phoneNumber,
        photo: response.photo,
        status: response.status,
        isDeleted: response.isDeleted,
        createdAt: response.createdAt,
        dateOfBirth: response.dateOfBirth,
        gender: response.gender,
        nationality: response.nationality,
        workPermit: response.workPermit,
        accountStatus: response.accountStatus,
        is2FaOn: response.is2FaOn,
        isCompleted: response.isCompleted,
      ));
    } catch (e, stackTrace) {
      return Left(handleException(e, stackTrace));
    }
  }

  // @override
  // Future<Either<Failure, ChangePasswordResponseEntity>> changePassword(ChangePasswordEntity entity) async {
  //   try {
  //     await authRemoteDataSourceJob.changePassword(PasswordChangeModel.fromEntity(entity));
  //     // In the old code, it returned Either<Failure, void>. The interface says ChangePasswordResponseEntity.
  //     // So we return a generic success entity.
  //     return const Right(ChangePasswordResponseEntity(success: true, message: "Password changed successfully"));
  //   } catch (e, stackTrace) {
  //     return Left(handleException(e, stackTrace));
  //   }
  // }

  @override
  Future<Either<Failure, bool>> fcmToken(FcmTokenEntity entity) async {
    try {
      final response = await authRemoteDataSourceJob.fcmToken(fcmToken: FcmTokenModel.fromEntity(entity));
      return Right(response);
    } catch (e, stackTrace) {
      return Left(handleException(e, stackTrace));
    }
  }

  @override
  // Future<Either<Failure, bool>> forgetPasswordJob(ChangePasswordRequestModel payload) async {
  //   try {
  //     final response = await authRemoteDataSourceJob.forgetPasswordJob(payload: payload);
  //     return Right(response);
  //   } catch (e, stackTrace) {
  //     return Left(handleException(e, stackTrace));
  //   }
  // }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await authRemoteDataSourceJob.logoutJobSeeker();
      return const Right(true);
    } catch (e, stackTrace) {
      return Left(handleException(e, stackTrace));
    }
  }

  // @override
  // Future<Either<Failure, bool>> matchOtp(MatchOtpRequestModel payload) async {
  //   try {
  //     final response = await authRemoteDataSourceJob.matchOtp(payload);
  //     return Right(response);
  //   } catch (e, stackTrace) {
  //     return Left(handleException(e, stackTrace));
  //   }
  // }

  // @override
  // Future<Either<Failure, bool>> registerJobSeeker(RegistrationRequestJobModel payload, List<SendFileModel> file) async {
  //   try {
  //     final response = await authRemoteDataSourceJob.register(payload: payload, file: file);
  //     return Right(response);
  //   } catch (e, stackTrace) {
  //     return Left(handleException(e, stackTrace));
  //   }
  // }

  // @override
  // Future<Either<Failure, bool>> sendOtp(SendEmailOtpModel payload) async {
  //   try {
  //     final response = await authRemoteDataSourceJob.sendOtp(payload);
  //     return Right(response);
  //   } catch (e, stackTrace) {
  //     return Left(handleException(e, stackTrace));
  //   }
  // }
}
