// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hotelier_login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HotelierLoginResponseModel _$HotelierLoginResponseModelFromJson(
  Map<String, dynamic> json,
) => HotelierLoginResponseModel(
  userId: json['user_id'],
  email: json['email'],
  phoneNumber: json['phone_number'],
  name: json['name'],
  photo: json['photo'],
  userStatus: json['user_status'] as bool?,
  userType: json['user_type'],
  organizationName: json['organization_name'],
  organizationDetails: json['organization_details'],
  organizationPhoto: json['organization_photo'],
  organizationStatus: json['organization_status'],
  organizationCreatedAt: json['organization_created_at'] == null
      ? null
      : DateTime.parse(json['organization_created_at'] as String),
  is2FaOn: json['is_2fa_on'] as bool?,
  locationId: json['location_id'],
  cityId: json['city_id'],
  city: json['city'],
  state: json['state'],
  country: json['country'],
  locationName: json['location_name'],
  address: json['address'],
  longitude: json['longitude'],
  latitude: json['latitude'],
  postalCode: json['postal_code'],
  locationStatus: json['location_status'] as bool?,
  isHomeAddress: json['is_home_address'] as bool?,
  locationCreatedAt: json['location_created_at'] == null
      ? null
      : DateTime.parse(json['location_created_at'] as String),
  locationUpdatedAt: json['location_updated_at'] == null
      ? null
      : DateTime.parse(json['location_updated_at'] as String),
);

Map<String, dynamic> _$HotelierLoginResponseModelToJson(
  HotelierLoginResponseModel instance,
) => <String, dynamic>{
  'user_id': ?instance.userId,
  'email': ?instance.email,
  'phone_number': ?instance.phoneNumber,
  'name': ?instance.name,
  'photo': ?instance.photo,
  'user_status': ?instance.userStatus,
  'user_type': ?instance.userType,
  'organization_name': ?instance.organizationName,
  'organization_details': ?instance.organizationDetails,
  'organization_photo': ?instance.organizationPhoto,
  'organization_status': ?instance.organizationStatus,
  'organization_created_at': ?instance.organizationCreatedAt?.toIso8601String(),
  'is_2fa_on': ?instance.is2FaOn,
  'location_id': ?instance.locationId,
  'city_id': ?instance.cityId,
  'city': ?instance.city,
  'state': ?instance.state,
  'country': ?instance.country,
  'location_name': ?instance.locationName,
  'address': ?instance.address,
  'longitude': ?instance.longitude,
  'latitude': ?instance.latitude,
  'postal_code': ?instance.postalCode,
  'location_status': ?instance.locationStatus,
  'is_home_address': ?instance.isHomeAddress,
  'location_created_at': ?instance.locationCreatedAt?.toIso8601String(),
  'location_updated_at': ?instance.locationUpdatedAt?.toIso8601String(),
};
