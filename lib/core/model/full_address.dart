class FullAddress {
  final double? latitude;
  final double? longitude;
  final double? accuracy;

  final String? street;
  final String? area;
  final String? city;
  final String? state;
  final String? district;
  final String? division;
  final String? postalCode;
  final String? country;

  final bool isUserConfirmed;

  FullAddress({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    this.street,
    this.area,
    this.city,
    this.state,
    this.district,
    this.division,
    this.postalCode,
    this.country,
    this.isUserConfirmed = false,
  });

  /// Auto-generated from component fields.
  /// Joins non-null, non-empty parts in order:
  /// street → area → city → state → district → division → postalCode → country
  String? get fullAddress {
    final parts = <String>[
      if ((street ?? '').trim().isNotEmpty) street!.trim(),
      if ((area ?? '').trim().isNotEmpty) area!.trim(),
      if ((city ?? '').trim().isNotEmpty) city!.trim(),
      if ((state ?? '').trim().isNotEmpty) state!.trim(),
      if ((district ?? '').trim().isNotEmpty) district!.trim(),
      if ((division ?? '').trim().isNotEmpty) division!.trim(),
      if ((postalCode ?? '').trim().isNotEmpty) postalCode!.trim(),
      if ((country ?? '').trim().isNotEmpty) country!.trim(),
    ];

    // Remove consecutive duplicates (e.g. city == state in some locales)
    final deduped = <String>[];
    for (final part in parts) {
      if (deduped.isEmpty || deduped.last != part) {
        deduped.add(part);
      }
    }

    return deduped.isEmpty ? null : deduped.join(', ');
  }

  FullAddress copyWith({
    double? latitude,
    double? longitude,
    double? accuracy,
    String? street,
    String? area,
    String? city,
    String? state,
    String? district,
    String? division,
    String? postalCode,
    String? country,
    bool? isUserConfirmed,
  }) {
    return FullAddress(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      street: street ?? this.street,
      area: area ?? this.area,
      city: city ?? this.city,
      state: state ?? this.state,
      district: district ?? this.district,
      division: division ?? this.division,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      isUserConfirmed: isUserConfirmed ?? this.isUserConfirmed,
    );
  }
}