import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteResult {
  final List<LatLng> points;
  final double distanceMeters;
  final double durationSeconds;

  RouteResult({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  String get formattedDistance {
    if (distanceMeters >= 1000) {
      return '${(distanceMeters / 1000).toStringAsFixed(1)} km';
    }
    return '${distanceMeters.toStringAsFixed(0)} m';
  }

  String get formattedDuration {
    final minutes = (durationSeconds / 60).round();
    if (minutes < 1) return '< 1 min';
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final remMinutes = minutes % 60;
      return '${hours}h ${remMinutes}m';
    }
    return '$minutes mins';
  }
}

class RouteService {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
    ),
  );

  /// Fetch real road route coordinates following streets and turns
  static Future<RouteResult?> getRoadRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    try {
      final url =
          'https://router.project-osrm.org/route/v1/driving/'
          '${origin.longitude},${origin.latitude};'
          '${destination.longitude},${destination.latitude}'
          '?overview=full&geometries=geojson';

      final response = await _dio.get(url);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : jsonDecode(response.data.toString()) as Map<String, dynamic>;

        if (data['code'] == 'Ok' && data['routes'] != null) {
          final routes = data['routes'] as List;
          if (routes.isNotEmpty) {
            final firstRoute = routes[0] as Map<String, dynamic>;
            final geometry = firstRoute['geometry'] as Map<String, dynamic>?;
            final coordinates = geometry?['coordinates'] as List?;

            if (coordinates != null && coordinates.isNotEmpty) {
              final points = coordinates.map<LatLng>((coord) {
                final lng = (coord[0] as num).toDouble();
                final lat = (coord[1] as num).toDouble();
                return LatLng(lat, lng);
              }).toList();

              final distance =
                  (firstRoute['distance'] as num?)?.toDouble() ?? 0.0;
              final duration =
                  (firstRoute['duration'] as num?)?.toDouble() ?? 0.0;

              return RouteResult(
                points: points,
                distanceMeters: distance,
                durationSeconds: duration,
              );
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('RouteService error: $e');
      }
    }
    return null;
  }
}
