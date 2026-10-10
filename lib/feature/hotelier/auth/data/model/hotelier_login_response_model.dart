import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/hotelier_login_response_entity.dart';

part 'hotelier_login_response_model.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class HotelierLoginResponseModel {
  @JsonKey(name: "user_id")
  final dynamic userId;
  @JsonKey(name: "email")
  final dynamic email;
  @JsonKey(name: "phone_number")
  final dynamic phoneNumber;
  @JsonKey(name: "name")
  final dynamic name;
  @JsonKey(name: "photo")
  final dynamic photo;
  @JsonKey(name: "user_status")
  final bool? userStatus;
  @JsonKey(name: "user_type")
  final dynamic userType;
  @JsonKey(name: "organization_name")
  final dynamic organizationName;
  @JsonKey(name: "organization_details")
  final dynamic organizationDetails;
  @JsonKey(name: "organization_photo")
  final dynamic organizationPhoto;
  @JsonKey(name: "organization_status")
  final dynamic organizationStatus;
  @JsonKey(name: "organization_created_at")
  final DateTime? organizationCreatedAt;
  @JsonKey(name: "is_2fa_on")
  final bool? is2FaOn;
  @JsonKey(name: "location_id")
  final dynamic locationId;
  @JsonKey(name: "city_id")
  final dynamic cityId;
  @JsonKey(name: "city")
  final dynamic city;
  @JsonKey(name: "state")
  final dynamic state;
  @JsonKey(name: "country")
  final dynamic country;
  @JsonKey(name: "location_name")
  final dynamic locationName;
  @JsonKey(name: "address")
  final dynamic address;
  @JsonKey(name: "longitude")
  final dynamic longitude;
  @JsonKey(name: "latitude")
  final dynamic latitude;
  @JsonKey(name: "postal_code")
  final dynamic postalCode;
  @JsonKey(name: "location_status")
  final bool? locationStatus;
  @JsonKey(name: "is_home_address")
  final bool? isHomeAddress;
  @JsonKey(name: "location_created_at")
  final DateTime? locationCreatedAt;
  @JsonKey(name: "location_updated_at")
  final DateTime? locationUpdatedAt;

  const HotelierLoginResponseModel({
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

  factory HotelierLoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$HotelierLoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$HotelierLoginResponseModelToJson(this);

  factory HotelierLoginResponseModel.fromEntity(HotelierLoginResponseEntity entity) {
    return HotelierLoginResponseModel(
      userId: entity.userId,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      name: entity.name,
      photo: entity.photo,
      userStatus: entity.userStatus,
      userType: entity.userType,
      organizationName: entity.organizationName,
      organizationDetails: entity.organizationDetails,
      organizationPhoto: entity.organizationPhoto,
      organizationStatus: entity.organizationStatus,
      organizationCreatedAt: entity.organizationCreatedAt,
      is2FaOn: entity.is2FaOn,
      locationId: entity.locationId,
      cityId: entity.cityId,
      city: entity.city,
      state: entity.state,
      country: entity.country,
      locationName: entity.locationName,
      address: entity.address,
      longitude: entity.longitude,
      latitude: entity.latitude,
      postalCode: entity.postalCode,
      locationStatus: entity.locationStatus,
      isHomeAddress: entity.isHomeAddress,
      locationCreatedAt: entity.locationCreatedAt,
      locationUpdatedAt: entity.locationUpdatedAt,
    );
  }

  HotelierLoginResponseEntity toEntity() {
    return HotelierLoginResponseEntity(
      userId: userId,
      email: email,
      phoneNumber: phoneNumber,
      name: name,
      photo: photo,
      userStatus: userStatus,
      userType: userType,
      organizationName: organizationName,
      organizationDetails: organizationDetails,
      organizationPhoto: organizationPhoto,
      organizationStatus: organizationStatus,
      organizationCreatedAt: organizationCreatedAt,
      is2FaOn: is2FaOn,
      locationId: locationId,
      cityId: cityId,
      city: city,
      state: state,
      country: country,
      locationName: locationName,
      address: address,
      longitude: longitude,
      latitude: latitude,
      postalCode: postalCode,
      locationStatus: locationStatus,
      isHomeAddress: isHomeAddress,
      locationCreatedAt: locationCreatedAt,
      locationUpdatedAt: locationUpdatedAt,
    );
  }
}
