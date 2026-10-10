class ProfileUpdateRequestModelHiring {
  final String? organizationName;
  final String? organizationAddressAddress;
  final String? organizationAddressPostalCode;
  final String? organizationAddressLatitude;
  final String? organizationAddressLongitude;
  final String? country;
  final String? state;
  final String? city;
  String? fcmToken;
  bool? is2FaOn;

  ProfileUpdateRequestModelHiring({
    this.organizationName,
    this.organizationAddressAddress,
    this.organizationAddressPostalCode,
    this.organizationAddressLatitude,
    this.organizationAddressLongitude,
    this.country,
    this.state,
    this.city,
    this.is2FaOn,
  });

  Map<String, String> toJson() {
    final map = <String, String>{};
    if (fcmToken != null) map["user[device_id]"] = fcmToken!;

    if ((organizationName ?? '').isNotEmpty) {
      map["organization[name]"] = organizationName!;
    }
    if ((organizationAddressAddress ?? '').isNotEmpty) {
      map["org_address[address]"] = organizationAddressAddress!;
    }
    if ((organizationAddressPostalCode ?? '').isNotEmpty) {
      map["org_address[postal_code]"] = organizationAddressPostalCode!;
    }
    if ((organizationAddressLatitude ?? '').isNotEmpty) {
      map["org_address[latitude]"] = organizationAddressLatitude!;
    }
    if ((organizationAddressLongitude ?? '').isNotEmpty) {
      map["org_address[longitude]"] = organizationAddressLongitude!;
    }
    map["organization[is_2fa_on]"] = is2FaOn.toString();
    if ((country ?? '').isNotEmpty) map["org_address[country]"] = country!;
    if ((state ?? '').isNotEmpty) map["org_address[state]"] = state!;
    if ((city ?? '').isNotEmpty) map["org_address[city]"] = city!;
    return map;
  }
}
