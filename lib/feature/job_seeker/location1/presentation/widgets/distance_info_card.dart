import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_tracking/core/service/route_service.dart';

class DistanceInfoCard extends StatelessWidget {
  final LatLng origin;
  final LatLng? destination;
  final String? originAddress;
  final String? destinationAddress;
  final RouteResult? routeResult;
  final double? straightLineDistanceMeters;
  final bool isLoadingRoute;
  final VoidCallback onLaunchGoogleMaps;
  final VoidCallback onClearDestination;

  const DistanceInfoCard({
    super.key,
    required this.origin,
    this.destination,
    this.originAddress,
    this.destinationAddress,
    this.routeResult,
    this.straightLineDistanceMeters,
    this.isLoadingRoute = false,
    required this.onLaunchGoogleMaps,
    required this.onClearDestination,
  });

  String _formatStraightDistance(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(2)} km';
    }
    return '${meters.toStringAsFixed(0)} m';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (destination == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_rounded,
                color: theme.colorScheme.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Search or Tap on Map',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Select a destination to calculate distance & route',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final distanceText = routeResult?.formattedDistance ??
        (straightLineDistanceMeters != null
            ? _formatStraightDistance(straightLineDistanceMeters!)
            : 'Calculating...');

    final durationText = routeResult?.formattedDuration;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with distance badge and close button
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.directions_car, size: 16, color: Colors.blue.shade700),
                    const SizedBox(width: 6),
                    Text(
                      isLoadingRoute ? 'Routing...' : distanceText,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ),
              if (durationText != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer_outlined, size: 15, color: Colors.green.shade700),
                      const SizedBox(width: 4),
                      Text(
                        durationText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.green.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const Spacer(),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onClearDestination,
                icon: const Icon(Icons.close, size: 20),
                tooltip: 'Clear destination',
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Route Nodes (Origin -> Destination)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  const Icon(Icons.my_location, size: 16, color: Colors.blue),
                  Container(
                    width: 2,
                    height: 28,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    color: Colors.grey.shade300,
                  ),
                  const Icon(Icons.location_on, size: 18, color: Colors.red),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Origin
                    Text(
                      'Job Seeker (Current)',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      originAddress ??
                          '${origin.latitude.toStringAsFixed(4)}, ${origin.longitude.toStringAsFixed(4)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 14),
                    // Destination
                    Text(
                      'Destination',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      destinationAddress ??
                          '${destination!.latitude.toStringAsFixed(4)}, ${destination!.longitude.toStringAsFixed(4)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Button: Launch Google Maps URL
          ElevatedButton.icon(
            onPressed: onLaunchGoogleMaps,
            icon: const Icon(Icons.directions, color: Colors.white),
            label: const Text(
              'Open in Google Maps',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A73E8), // Google Maps Blue
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }
}
