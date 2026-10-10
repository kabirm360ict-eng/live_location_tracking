part of 'hotelier_auth_bloc.dart';

@immutable
sealed class HotelierAuthEvent {}

// for login
final class HotelierLoginEvent extends HotelierAuthEvent {
  final LoginRequestHotelierModel loginRequestModel;
  HotelierLoginEvent(this.loginRequestModel);
}

// for logout
final class HotelierLogoutEvent extends HotelierAuthEvent {}

// for get profile
class GetProfileHotelierEvent extends HotelierAuthEvent {
  final bool isRefresh;
  final ProfileResponseModelHiring? profile;
  GetProfileHotelierEvent({this.isRefresh = false, this.profile});
}

// for update profile
class UpdateProfileHotelierEvent extends HotelierAuthEvent {
  final ProfileUpdateRequestModelHiring payload;
  final List<SendFileModel> files;
  UpdateProfileHotelierEvent({required this.payload, this.files = const []});
}
