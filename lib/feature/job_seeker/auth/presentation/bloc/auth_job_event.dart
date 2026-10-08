part of 'auth_job_bloc.dart';

@immutable
sealed class AuthJobEvent {}

//for login
final class LoginEventJob extends AuthJobEvent {
  final LoginRequestJobModel loginRequestModelJob;
  LoginEventJob(this.loginRequestModelJob);
}

// //for send otp
// final class SendOtpEventJob extends AuthJobEvent {
//   final SendEmailOtpModel sendEmailOtpModelJob;
//   SendOtpEventJob(this.sendEmailOtpModelJob);
// }

// //for resend otp
// final class ResendOtpEventJob extends AuthJobEvent {
//   final SendEmailOtpModel sendEmailOtpModelJob;
//   ResendOtpEventJob(this.sendEmailOtpModelJob);
// }

// //for register
// final class RegisterEventJob extends AuthJobEvent {
//   final RegistrationRequestJobModel registrationRequestModelJob;
//   final List<SendFileModel> regFiles;

//   RegisterEventJob({required this.registrationRequestModelJob, required this.regFiles});
// }

// //for match otp
// final class MatchOtpEventJob extends AuthJobEvent {
//   final MatchOtpRequestModel matchOtpModelJob;
//   MatchOtpEventJob(this.matchOtpModelJob);
// }

// //for change password
// final class ChangePasswordEventJob extends AuthJobEvent {
//   final ChangePasswordRequestModel changePasswordRequestModelJob;
//   ChangePasswordEventJob(this.changePasswordRequestModelJob);
// }

//!for logout
final class LogOutEvent extends AuthJobEvent {}

//! for password change

// final class PasswordChangeEvent extends AuthJobEvent {
//   final PasswordChangeModel passwordChangeModel;
//   //
//   PasswordChangeEvent(this.passwordChangeModel);
// }

// //for get profile
class GetProfileJobSeekerEvent extends AuthJobEvent {
  final bool isRefresh;
  final ProfileGetJobSeekerModel? profile;
  GetProfileJobSeekerEvent({this.isRefresh = false, this.profile});
}

// class UpdateProfileJobSeekerEvent extends AuthJobEvent {
//   final ProfileUpdateJobSeekerModel profileUpdateJobSeekerModel;
//   final List<SendFileModel> files;

//   UpdateProfileJobSeekerEvent({required this.profileUpdateJobSeekerModel, required this.files});
// }

// class UpdateVerifyDocumentsJobSeekerEvent extends AuthJobEvent {
//   final List<SendFileModel> files;

//   UpdateVerifyDocumentsJobSeekerEvent({required this.files});
// }

