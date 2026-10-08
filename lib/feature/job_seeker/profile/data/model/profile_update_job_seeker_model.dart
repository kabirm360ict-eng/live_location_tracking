import 'dart:convert';

ProfileUpdateJobSeekerModel profileUpdateJobSeekerModelFromJson(String str) =>
    ProfileUpdateJobSeekerModel.fromJson(json.decode(str));

class ProfileUpdateJobSeekerModel {
  final String? userPhoneNumber;
  final String? userName;
  final String? address;
  final bool? is2FaOn;
  final String? preferredJob;
  final String? latitude;
  final String? longitude;
  final String? country;
  final String? state;
  final String? city;
  final String? postalCode;

  ProfileUpdateJobSeekerModel({
    this.userPhoneNumber,
    this.userName,
    this.address,
    this.is2FaOn,
    this.preferredJob,
    this.latitude,
    this.longitude,
    this.country,
    this.state,
    this.city,
    this.postalCode,
  });

  factory ProfileUpdateJobSeekerModel.fromJson(Map<String, dynamic> json) =>
      ProfileUpdateJobSeekerModel(
        userPhoneNumber: json["user[phone_number]"] as String?,
        userName: json["user[name]"] as String?,
        address: json["own_address[address]"] as String?,
        is2FaOn: json["job_seeker[is_2fa_on]"] as bool?,
        preferredJob: json["job_seeker[preferred_job]"] as String?,
        latitude: json["own_address[latitude]"] as String?,
        longitude: json["own_address[longitude]"] as String?,
        country: json["own_address[country]"] as String?,
        state: json["own_address[state]"] as String?,
        city: json["own_address[city]"] as String?,
        postalCode: json["own_address[postal_code]"] as String?,
      );

  /// Only include fields that are non-null
  Map<String, String> toJson() {
    final map = <String, String>{};
    if (userName != null) map["user[name]"] = userName!;
    if (userPhoneNumber != null) map["user[phone_number]"] = userPhoneNumber!;
    if (address != null) map["own_address[address]"] = address!;
    if (latitude != null) map["own_address[latitude]"] = latitude!;
    if (longitude != null) map["own_address[longitude]"] = longitude!;
    if (country != null) map["own_address[country]"] = country!;
    if (state != null) map["own_address[state]"] = state!;
    if (city != null) map["own_address[city]"] = city!;
    if (postalCode != null) map["own_address[postal_code]"] = postalCode!;
    if (is2FaOn != null) map["job_seeker[is_2fa_on]"] = is2FaOn.toString();
    if (preferredJob != null && preferredJob!.isNotEmpty) {
      map["job_seeker[preferred_job]"] = preferredJob!;
    }
    return map;
  }
}
