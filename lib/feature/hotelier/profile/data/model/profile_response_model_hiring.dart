import 'dart:convert';

ProfileResponseModelHiring profileResponseModelHiringFromJson(String str) =>
    ProfileResponseModelHiring.fromJson(json.decode(str));

String profileResponseModelHiringToJson(ProfileResponseModelHiring data) =>
    json.encode(data.toJson());

class ProfileResponseModelHiring {
  final dynamic userId;
  final dynamic email;
  final dynamic phoneNumber;
  final dynamic name;
  final dynamic photo;
  final bool? userStatus;
  final bool? userDeleted;
  final dynamic userType;
  final dynamic organizationId;
  final dynamic organizationName;
  final dynamic organizationDetails;
  final dynamic organizationPhoto;
  final dynamic organizationStatus;
  final bool? organizationDeleted;
  final dynamic organizationCreatedAt;
  final bool? is2FaOn;
  final dynamic locationId;
  final dynamic cityId;
  final dynamic locationName;
  final dynamic address;
  final dynamic longitude;
  final dynamic latitude;
  final dynamic postalCode;
  final bool? locationStatus;
  final bool? isHomeAddress;
  final dynamic locationCreatedAt;
  final dynamic locationUpdatedAt;

  ProfileResponseModelHiring({
    this.userId,
    this.email,
    this.phoneNumber,
    this.name,
    this.photo,
    this.userStatus,
    this.userDeleted,
    this.userType,
    this.organizationId,
    this.organizationName,
    this.organizationDetails,
    this.organizationPhoto,
    this.organizationStatus,
    this.organizationDeleted,
    this.organizationCreatedAt,
    this.is2FaOn,
    this.locationId,
    this.cityId,
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

  factory ProfileResponseModelHiring.fromJson(Map<String, dynamic> json) =>
      ProfileResponseModelHiring(
        userId: json["user_id"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        name: json["name"],
        photo: json["photo"],
        userStatus: json["user_status"],
        userDeleted: json["user_deleted"],
        userType: json["user_type"],
        organizationId: json["organization_id"],
        organizationName: json["organization_name"],
        organizationDetails: json["organization_details"],
        organizationPhoto: json["organization_photo"],
        organizationStatus: json["organization_status"],
        organizationDeleted: json["organization_deleted"],
        organizationCreatedAt: json["organization_created_at"],
        is2FaOn: json["is_2fa_on"],
        locationId: json["location_id"],
        cityId: json["city_id"],
        locationName: json["location_name"],
        address: json["address"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        postalCode: json["postal_code"],
        locationStatus: json["location_status"],
        isHomeAddress: json["is_home_address"],
        locationCreatedAt: json["location_created_at"],
        locationUpdatedAt: json["location_updated_at"],
      );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "email": email,
    "phone_number": phoneNumber,
    "name": name,
    "photo": photo,
    "user_status": userStatus,
    "user_deleted": userDeleted,
    "user_type": userType,
    "organization_id": organizationId,
    "organization_name": organizationName,
    "organization_details": organizationDetails,
    "organization_photo": organizationPhoto,
    "organization_status": organizationStatus,
    "organization_deleted": organizationDeleted,
    "organization_created_at": organizationCreatedAt,
    "is_2fa_on": is2FaOn,
    "location_id": locationId,
    "city_id": cityId,
    "location_name": locationName,
    "address": address,
    "longitude": longitude,
    "latitude": latitude,
    "postal_code": postalCode,
    "location_status": locationStatus,
    "is_home_address": isHomeAddress,
    "location_created_at": locationCreatedAt,
    "location_updated_at": locationUpdatedAt,
  };
}
