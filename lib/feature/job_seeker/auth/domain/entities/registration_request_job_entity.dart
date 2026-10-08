import 'package:equatable/equatable.dart';

class RegistrationRequestJobEntity extends Equatable {
  final dynamic userName;
  final dynamic userEmail;
  final dynamic userPassword;
  final dynamic userPhoneNumber;
  final dynamic ownAddress;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic country;
  final dynamic state;
  final dynamic city;
  final dynamic postalCode;
  final dynamic preferredJob;

  const RegistrationRequestJobEntity({
    this.userName,
    this.userEmail,
    this.userPassword,
    this.userPhoneNumber,
    this.ownAddress,
    this.latitude,
    this.longitude,
    this.country,
    this.state,
    this.city,
    this.postalCode,
    this.preferredJob,
  });

  @override
  List<Object?> get props => [
    userName,
    userEmail,
    userPassword,
    userPhoneNumber,
    ownAddress,
    latitude,
    longitude,
    country,
    state,
    city,
    postalCode,
    preferredJob,
  ];
}
