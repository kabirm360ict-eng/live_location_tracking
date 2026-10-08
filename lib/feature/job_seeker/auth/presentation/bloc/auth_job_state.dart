part of 'auth_job_bloc.dart';

@immutable
sealed class AuthJobState {}

final class AuthJobInitial extends AuthJobState {}

//for login
final class LoginLoadingStateJob extends AuthJobState {}

final class LoginSuccessStateJob extends AuthJobState {}

final class WorkPermitPendingStateJob extends AuthJobState {}

final class LoginFailedStateJob extends AuthJobState {
  final String message;

  LoginFailedStateJob({required this.message});
}

//!for fcm token
final class FcmTokenSuccessStateJob extends AuthJobState {}

final class FcmTokenFailedStateJob extends AuthJobState {
  final String message;

  FcmTokenFailedStateJob({required this.message});
}

//for send otp
final class SendOtpLoadingStateJob extends AuthJobState {}

final class SendOtpSuccessStateJob extends AuthJobState {
  final bool is2FaOn;

  SendOtpSuccessStateJob({required this.is2FaOn});
}

final class SendOtpFailedStateJob extends AuthJobState {
  final String message;

  SendOtpFailedStateJob({required this.message});
}

//for match otp
final class MatchOtpLoadingStateJob extends AuthJobState {}

final class MatchOtpSuccessStateJob extends AuthJobState {}

final class MatchOtpFailedStateJob extends AuthJobState {
  final String message;

  MatchOtpFailedStateJob({required this.message});
}

//for register
final class RegisterLoadingStateJob extends AuthJobState {}

final class RegisterSuccessStateJob extends AuthJobState {}

final class RegisterFailedStateJob extends AuthJobState {
  final String message;

  RegisterFailedStateJob({required this.message});
}

//for change password
final class ChangePasswordLoadingStateJob extends AuthJobState {}

final class ChangePasswordSuccessStateJob extends AuthJobState {}

final class ChangePasswordFailedStateJob extends AuthJobState {
  final String message;

  ChangePasswordFailedStateJob({required this.message});
}

//!for logout
final class LogOutSuccessState extends AuthJobState {}

final class LogOutFailedStateJob extends AuthJobState {
  final String message;

  LogOutFailedStateJob({required this.message});
}

//! for password change
final class PasswordChangeLoadingState extends AuthJobState {}

final class PasswordChangeSuccessState extends AuthJobState {}

final class PasswordChangeErrorState extends AuthJobState {
  final String message;

  PasswordChangeErrorState({required this.message});
}

//for get profile

final class GetProfileJobSeekerLoadingState extends AuthJobState {}

final class GetProfileJobSeekerSuccessState extends AuthJobState {
  final ProfileGetJobSeekerModel profileGetJobSeekerModel;
  GetProfileJobSeekerSuccessState({required this.profileGetJobSeekerModel});
}

final class GetProfileJobSeekerFailedState extends AuthJobState {
  final String message;

  GetProfileJobSeekerFailedState({required this.message});
}

//!for update

final class UpdateProfileJobSeekerLoadingState extends AuthJobState {}

final class UpdateProfileJobSeekerSuccessState extends AuthJobState {}

final class UpdateProfileJobSeekerFailedState extends AuthJobState {
  final String message;

  UpdateProfileJobSeekerFailedState({required this.message});
}

//!for verify documents update
final class UpdateVerifyDocumentsJobSeekerLoadingState extends AuthJobState {}

final class UpdateVerifyDocumentsJobSeekerSuccessState extends AuthJobState {
  final dynamic data;
  UpdateVerifyDocumentsJobSeekerSuccessState({this.data});
}

final class UpdateVerifyDocumentsJobSeekerFailedState extends AuthJobState {
  final String message;
  UpdateVerifyDocumentsJobSeekerFailedState({required this.message});
}

