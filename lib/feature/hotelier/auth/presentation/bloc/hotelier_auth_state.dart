part of 'hotelier_auth_bloc.dart';

@immutable
sealed class HotelierAuthState {}

final class HotelierAuthInitial extends HotelierAuthState {}

// for login
final class HotelierLoginLoadingState extends HotelierAuthState {}

final class HotelierLoginSuccessState extends HotelierAuthState {
  final HotelierLoginResponseEntity? response;
  HotelierLoginSuccessState({this.response});
}

final class HotelierSendOtpSuccessState extends HotelierAuthState {
  final bool is2FaOn;
  HotelierSendOtpSuccessState({required this.is2FaOn});
}

final class HotelierLoginFailedState extends HotelierAuthState {
  final String message;
  HotelierLoginFailedState({required this.message});
}

// for logout
final class HotelierLogoutSuccessState extends HotelierAuthState {}

final class HotelierLogoutFailedState extends HotelierAuthState {
  final String message;
  HotelierLogoutFailedState({required this.message});
}

// for get profile
final class GetProfileHotelierLoadingState extends HotelierAuthState {}

final class GetProfileHotelierSuccessState extends HotelierAuthState {
  final ProfileResponseModelHiring profile;
  GetProfileHotelierSuccessState({required this.profile});
}

final class GetProfileHotelierFailedState extends HotelierAuthState {
  final String message;
  GetProfileHotelierFailedState({required this.message});
}

// for update profile
final class UpdateProfileHotelierLoadingState extends HotelierAuthState {}

final class UpdateProfileHotelierSuccessState extends HotelierAuthState {
  final ProfileResponseModelHiring? profile;
  UpdateProfileHotelierSuccessState({this.profile});
}

final class UpdateProfileHotelierFailedState extends HotelierAuthState {
  final String message;
  UpdateProfileHotelierFailedState({required this.message});
}
