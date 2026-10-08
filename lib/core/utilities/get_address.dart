import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_tracking/core/model/full_address.dart';

// import '../models/full_address.dart';

Future<FullAddress?> getAddressFromLatLng(LatLng position) async {
  try {
    debugPrint("position: ${position.latitude}, ${position.longitude}");
    List<Placemark> placemarks = await Geocoding().placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final data = placemarks.first;
      return FullAddress(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: null,
        street: data.street ?? data.name ?? data.subThoroughfare ?? data.thoroughfare,
        area: data.subLocality,
        city: data.locality ?? data.subLocality,
        state: data.administrativeArea ?? data.subAdministrativeArea,
        district: data.subAdministrativeArea,
        postalCode: data.postalCode,
        country: data.country ?? data.isoCountryCode,
      );
    }
    return null;
  } catch (e, k) {
    if (kDebugMode) {
      log(
        "----------error getAddressFromLatLng----------",
        error: e,
        stackTrace: k,
      );
    }
    return null;
  }
}
