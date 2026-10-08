import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_tracking/core/dio/injection_container.dart';
import 'package:location_tracking/core/model/full_address.dart';
import '../local_database/auth_db.dart';

Future<Position?> checkLocationPermission(
  BuildContext context,
  bool? isDialog,
) async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return null;
  }
  log("Checking location permission");
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    log("Location permission denied");
    final savedConsent = await getIt<AuthLocalDB>().getLocation();

    if (savedConsent == null && isDialog == true) {
      if (context.mounted) {
        log("First time asking for location permission");
        final consent = await showLocationConsentDialog(context);
        if (consent == true) {
          log("Location consent granted");
          await getIt<AuthLocalDB>().setLocation("true");
        } else {
          log("Location consent denied");
          await getIt<AuthLocalDB>().setLocation("false");
          return null;
        }
      }
    } else if (savedConsent == "false") {
      log("Location consent denied");
      return null;
    }
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }
  log("Location permission granted");

  // Step 5: Handle permanently denied
  if (permission == LocationPermission.deniedForever) {
    // You can show a dialog to open app settings
    return null;
  }
  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  return null;
}

Future<bool> requestLocationAccess(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  // 1. Check if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    await Geolocator.openLocationSettings();
    return false;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true). According to Android guidelines
      // your App should show an explanatory UI now.
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    await Geolocator.openAppSettings();
    return false;
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return true;
}

Future<bool?> showLocationConsentDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Location Permission"),
      content: const Text(
        "We need your location, including background location access, to match you with nearby job opportunities and support job attendance tracking. Starting two hours before your job begins, the hiring manager will be able to see your location even when the app is closed or running in the background. This helps confirm arrival, ensure smooth coordination, and improve the overall job experience.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Continue"),
        ),
      ],
    ),
  );
}

//for new for all
class LocationUtils {
   Future<FullAddress?> getFullAddressFromLatLng(LatLng latLng) async {
    final placemarks = await Geocoding().placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );

    if (placemarks.isEmpty) {
      return null;
    }

    final place = placemarks.first;

    final street = _clean([place.street, place.thoroughfare]);

    final area = _clean([place.subLocality, place.locality]);

    final city = _clean([place.locality, place.subAdministrativeArea]);

    final district = place.subAdministrativeArea;
    final division = place.administrativeArea;
    final postalCode = place.postalCode;
    final country = place.country;


    return FullAddress(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      accuracy: 10,
      street: street,
      area: area,
      city: city,
      district: district,
      division: division,
      postalCode: postalCode,
      country: country,
    );
  }

  Future<FullAddress?> determineFullAddress() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception('Location service is disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Location permission denied');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied');
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final placemarks = await Geocoding().placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isEmpty) {
      throw Exception('Address not found');
    }

    final place = placemarks.first;

    final street = _clean([place.street, place.thoroughfare]);

    final area = _clean([place.subLocality, place.locality]);

    final city = _clean([place.locality, place.subAdministrativeArea]);

    final district = place.subAdministrativeArea;
    final division = place.administrativeArea;
    final postalCode = place.postalCode;
    final country = place.country;


    return FullAddress(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      street: street,
      area: area,
      city: city,
      district: district,
      division: division,
      postalCode: postalCode,
      country: country,
    );
  }

  String _clean(List<String?> values) {
    return values
        .where((e) => e != null && e.trim().isNotEmpty)
        .map((e) => e!.trim())
        .toSet()
        .join(', ');
  }

  String removeDuplicateAddressParts(String address) {
    final parts = address
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final seen = <String>{};
    final cleanedParts = <String>[];

    for (final part in parts) {
      final key = part.toLowerCase();

      if (!seen.contains(key)) {
        seen.add(key);
        cleanedParts.add(part);
      }
    }

    return cleanedParts.join(', ');
  }
}
