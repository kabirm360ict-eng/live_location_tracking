import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../entities/fcm_token_entity.dart';
import '../entities/job_seeker_login_response_entity.dart';
import '../entities/login_request_job_entity.dart';

abstract class AuthRepositories {
  Future<Either<Failure, JobSeekerLoginResponseEntity>> login(LoginRequestJobEntity entity);
  Future<Either<Failure, bool>> fcmToken(FcmTokenEntity entity);
  // Future<Either<Failure, bool>> sendOtp(SendEmailOtpModel payload);
  // Future<Either<Failure, bool>> registerJobSeeker(RegistrationRequestJobModel payload, List<SendFileModel> file);
  // Future<Either<Failure, bool>> matchOtp(MatchOtpRequestModel payload);
  // Future<Either<Failure, bool>> forgetPasswordJob(ChangePasswordRequestModel payload);
  // Future<Either<Failure, ChangePasswordResponseEntity>> changePassword(ChangePasswordEntity entity);
  Future<Either<Failure, bool>> logout();
}