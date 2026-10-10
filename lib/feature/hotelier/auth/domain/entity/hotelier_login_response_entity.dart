import 'package:equatable/equatable.dart';

class HotelierLoginResponseEntity extends Equatable {
  final dynamic userId;
  final dynamic email;
  final dynamic phoneNumber;
  final dynamic name;
  final dynamic photo;
  final bool? userStatus;
  final dynamic userType;
  final dynamic organizationName;
  final dynamic organizationDetails;
  final dynamic organizationPhoto;
  final dynamic organizationStatus;
  final DateTime? organizationCreatedAt;
  final bool? is2FaOn;
  final dynamic locationId;
  final dynamic cityId;
  final dynamic city;
  final dynamic state;
  final dynamic country;
  final dynamic locationName;
  final dynamic address;
  final dynamic longitude;
  final dynamic latitude;
  final dynamic postalCode;
  final bool? locationStatus;
  final bool? isHomeAddress;
  final DateTime? locationCreatedAt;
  final DateTime? locationUpdatedAt;

  const HotelierLoginResponseEntity({
    this.userId,
    this.email,
    this.phoneNumber,
    this.name,
    this.photo,
    this.userStatus,
    this.userType,
    this.organizationName,
    this.organizationDetails,
    this.organizationPhoto,
    this.organizationStatus,
    this.organizationCreatedAt,
    this.is2FaOn,
    this.locationId,
    this.cityId,
    this.city,
    this.state,
    this.country,
    this.locationName,
    this.address,
    this.longitude,
    this.latitude,
    this.postalCode,
    this.locationStatus,
    this.isHomeAddress,
    this.locationCreatedAt,
    this.locationUpdatedAt,
  });

  @override
  List<Object?> get props => [
    userId,
    email,
    phoneNumber,
    name,
    photo,
    userStatus,
    userType,
    organizationName,
    organizationDetails,
    organizationPhoto,
    organizationStatus,
    organizationCreatedAt,
    is2FaOn,
    locationId,
    cityId,
    city,
    state,
    country,
    locationName,
    address,
    longitude,
    latitude,
    postalCode,
    locationStatus,
    isHomeAddress,
    locationCreatedAt,
    locationUpdatedAt,
  ];
}
