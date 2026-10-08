import 'dart:convert';
import 'dart:developer';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location_tracking/core/model/full_address.dart';
import 'package:uuid/uuid.dart';

class PlacesService {
  final String apiKey;
  final String sessionToken;

  PlacesService(this.apiKey, {String? session})
    : sessionToken = session ?? const Uuid().v4();

  Future<List<Map<String, dynamic>>> getSuggestions(String input) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&sessiontoken=$sessionToken';
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(
      data['predictions'].map(
        (p) => {"description": p['description'], "place_id": p['place_id']},
      ),
    );
  }

  Future<FullAddress> getPlaceDetails(String placeId) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&sessiontoken=$sessionToken';

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data['status'] == 'OK') {
      final result = data['result'];
      // Extract all address-related data
      final addressComponents = GooglePlaceParser.extractAddressComponents(
        result["address_components"],
      );

      // Lat + Lng together as single object
      final geo = GooglePlaceParser.getLatLng(result["geometry"]);

      return FullAddress(
        latitude: geo.lat,
        longitude: geo.lng,
        accuracy: null,
        postalCode: addressComponents["postalCode"],
        country: addressComponents["country"],
        state: addressComponents["state"],
        city: addressComponents["city"],
      );
    } else {
      throw Exception("Failed to fetch place details: ${data['status']}");
    }
  }

  /// Resolves high-precision LatLng coordinates from a textual address query using:
  /// 1. Google Geocoding API (`maps/api/geocode/json`)
  /// 2. Google Places Autocomplete + Place Details fallback (`maps/api/place/autocomplete/json`)
  Future<LatLng?> getCoordinatesFromAddress(String address) async {
    final query = address.trim();
    if (query.isEmpty || apiKey.isEmpty) return null;

    // 1. Primary: Google Geocoding API
    try {
      final encoded = Uri.encodeComponent(query);
      final geocodeUrl =
          'https://maps.googleapis.com/maps/api/geocode/json?address=$encoded&key=$apiKey';
      final response = await http.get(Uri.parse(geocodeUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK' &&
            data['results'] is List &&
            (data['results'] as List).isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          final lat = (location['lat'] as num).toDouble();
          final lng = (location['lng'] as num).toDouble();
          log("Google Geocoding API matched: ($lat, $lng) for query: $query");
          return LatLng(lat, lng);
        }
      }
    } catch (e) {
      log("Google Geocoding API error: $e");
    }

    // 2. Secondary fallback: Google Places Autocomplete + Place Details
    try {
      final suggestions = await getSuggestions(query);
      if (suggestions.isNotEmpty && suggestions.first['place_id'] != null) {
        final placeId = suggestions.first['place_id'] as String;
        final details = await getPlaceDetails(placeId);
        if (details.latitude != null && details.longitude != null) {
          log("Google Places Autocomplete fallback matched: (${details.latitude}, ${details.longitude}) for query: $query");
          return LatLng(details.latitude!, details.longitude!);
        }
      }
    } catch (e) {
      log("Google Places Autocomplete fallback error: $e");
    }

    return null;
  }
}

class GooglePlaceParser {
  static Map<String, String?> extractAddressComponents(List components) {
    String? city;
    String? district;
    String? state;
    String? country;
    String? postalCode;

    for (var c in components) {
      final types = c['types'] as List;

      if (types.contains('locality')) city = c['long_name'];
      if (types.contains('administrative_area_level_2')) {
        district = c['long_name'];
      }
      if (types.contains('administrative_area_level_1')) {
        state = c['long_name'];
      }
      if (types.contains('country')) country = c['long_name'];
      if (types.contains('postal_code')) postalCode = c['long_name'];
    }

    return {
      "city": city ?? district,
      "state": state ?? district,
      "country": country,
      "postalCode": postalCode,
    };
  }

  static GeoPoint getLatLng(Map geometry) {
    final location = geometry["location"];
    return GeoPoint(
      lat: (location["lat"] as num).toDouble(),
      lng: (location["lng"] as num).toDouble(),
    );
  }
}

class GeoPoint {
  final double lat;
  final double lng;

  GeoPoint({required this.lat, required this.lng});
}
