import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location_tracking/core/service/job_seeker_tracking_service.dart';
import 'package:location_tracking/core/service/route_service.dart';
import 'package:location_tracking/core/utilities/get_address.dart';
import 'package:location_tracking/feature/job_seeker/get_job/domain/entities/job_seeker_job_item_entity.dart';
import '../widgets/distance_info_card.dart';
import '../widgets/location_search_modal.dart';

class JobSeekerMapDistancePage extends StatefulWidget {
  final JobSeekerJobItemEntity? job;

  const JobSeekerMapDistancePage({
    super.key,
    this.job,
  });

  @override
  State<JobSeekerMapDistancePage> createState() => _JobSeekerMapDistancePageState();
}

class _JobSeekerMapDistancePageState extends State<JobSeekerMapDistancePage> {
  GoogleMapController? _mapController;

  // Defaults to Dhaka fallback if GPS is not yet acquired
  static const LatLng _defaultLocation = LatLng(23.8103, 90.4125);

  LatLng? _jobSeekerPosition;
  String? _jobSeekerAddress;
  bool _isLoadingGps = true;
  String? _gpsError;

  // Destination state
  LatLng? _destinationPosition;
  String? _destinationAddress;
  RouteResult? _routeResult;
  double? _straightLineDistanceMeters;
  bool _isLoadingRoute = false;

  // Markers & Polylines
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    _initDestinationFromJob();
    _initJobSeekerLocation();
  }

  void _initDestinationFromJob() {
    final job = widget.job;
    if (job != null && job.latitudeDouble != null && job.longitudeDouble != null) {
      _destinationPosition = LatLng(job.latitudeDouble!, job.longitudeDouble!);
      _destinationAddress = (job.locationAddress != null && job.locationAddress!.isNotEmpty)
          ? job.locationAddress
          : job.organizationName;
      _updateMarkers();
    }
  }

  Future<void> _initJobSeekerLocation() async {
    setState(() {
      _isLoadingGps = true;
      _gpsError = null;
    });

    try {
      // 1. Check if device has permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _gpsError = 'Location permission is denied. Please allow GPS access in settings.';
          _isLoadingGps = false;
          _jobSeekerPosition = _defaultLocation;
        });
        _updateMarkers();
        return;
      }

      // 2. Check if GPS service is enabled
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        setState(() {
          _gpsError = 'Phone GPS is turned OFF. Please turn ON location service.';
        });
      }

      // Check if JobSeekerTrackingService already cached position
      final cachedPos = JobSeekerTrackingService().lastSentPositionNotifier.value;
      Position? currentPos;

      if (cachedPos != null) {
        currentPos = cachedPos;
      } else {
        currentPos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ),
        );
      }

      final latLng = LatLng(currentPos.latitude, currentPos.longitude);
      _jobSeekerPosition = latLng;
      _isLoadingGps = false;

      // Reverse geocode to get street / area name
      _reverseGeocodeJobSeeker(latLng);

      _updateMarkers();

      if (_destinationPosition != null) {
        _setDestination(
          _destinationPosition!,
          addressName: _destinationAddress,
        );
      } else {
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: 15),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _gpsError = 'Could not fetch current GPS: $e';
        _isLoadingGps = false;
        _jobSeekerPosition ??= _defaultLocation;
      });
      _updateMarkers();
    }
  }

  Future<void> _reverseGeocodeJobSeeker(LatLng pos) async {
    try {
      final fullAddress = await getAddressFromLatLng(pos);
      if (fullAddress != null && mounted) {
        final parts = [
          fullAddress.street,
          fullAddress.area,
          fullAddress.city,
          fullAddress.country,
        ].where((e) => e != null && e.isNotEmpty).toSet().toList();

        setState(() {
          _jobSeekerAddress = parts.isNotEmpty ? parts.join(', ') : null;
        });
        _updateMarkers();
      }
    } catch (_) {}
  }

  void _updateMarkers() {
    final markers = <Marker>{};

    if (_jobSeekerPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('job_seeker_origin'),
          position: _jobSeekerPosition!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(
            title: 'Job Seeker (You)',
            snippet: _jobSeekerAddress ??
                'Lat: ${_jobSeekerPosition!.latitude.toStringAsFixed(4)}, Lng: ${_jobSeekerPosition!.longitude.toStringAsFixed(4)}',
          ),
        ),
      );
    }

    if (_destinationPosition != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination_target'),
          position: _destinationPosition!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: _destinationAddress ?? 'Destination Location',
            snippet:
                '${_destinationPosition!.latitude.toStringAsFixed(4)}, ${_destinationPosition!.longitude.toStringAsFixed(4)}',
          ),
        ),
      );
    }

    setState(() {
      _markers.clear();
      _markers.addAll(markers);
    });
  }

  Future<void> _setDestination(LatLng destination, {String? addressName}) async {
    setState(() {
      _destinationPosition = destination;
      _destinationAddress = addressName;
      _isLoadingRoute = true;
      _straightLineDistanceMeters = null;
      _routeResult = null;
      _polylines.clear();
    });

    _updateMarkers();

    if (_jobSeekerPosition == null) return;

    // 1. Calculate straight line distance
    final straightMeters = Geolocator.distanceBetween(
      _jobSeekerPosition!.latitude,
      _jobSeekerPosition!.longitude,
      destination.latitude,
      destination.longitude,
    );

    setState(() {
      _straightLineDistanceMeters = straightMeters;
    });

    // 2. Fetch real road route from RouteService (OSRM)
    try {
      final route = await RouteService.getRoadRoute(
        origin: _jobSeekerPosition!,
        destination: destination,
      );

      if (route != null && mounted) {
        setState(() {
          _routeResult = route;
          _isLoadingRoute = false;
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('road_route'),
              points: route.points,
              color: const Color(0xFF1E88E5),
              width: 5,
              jointType: JointType.round,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
            ),
          );
        });
      } else {
        // Fallback straight line polyline if OSRM gives no route
        if (mounted) {
          setState(() {
            _isLoadingRoute = false;
            _polylines.add(
              Polyline(
                polylineId: const PolylineId('straight_route'),
                points: [_jobSeekerPosition!, destination],
                color: const Color(0xFF1E88E5),
                width: 4,
                patterns: [PatternItem.dash(15), PatternItem.gap(10)],
              ),
            );
          });
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingRoute = false;
        });
      }
    }

    // Adjust camera to fit both origin & destination markers
    _fitCameraBounds();
  }

  void _fitCameraBounds() {
    if (_mapController == null ||
        _jobSeekerPosition == null ||
        _destinationPosition == null) {
      return;
    }

    final p1 = _jobSeekerPosition!;
    final p2 = _destinationPosition!;

    final southWest = LatLng(
      min(p1.latitude, p2.latitude),
      min(p1.longitude, p2.longitude),
    );
    final northEast = LatLng(
      max(p1.latitude, p2.latitude),
      max(p1.longitude, p2.longitude),
    );

    final bounds = LatLngBounds(southwest: southWest, northeast: northEast);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 80),
        );
      }
    });
  }

  void _onMapTapped(LatLng tappedPoint) async {
    String? resolvedName;
    try {
      final fullAddress = await getAddressFromLatLng(tappedPoint);
      if (fullAddress != null) {
        final parts = [
          fullAddress.street,
          fullAddress.area,
          fullAddress.city,
        ].where((e) => e != null && e.isNotEmpty).toSet().toList();
        resolvedName = parts.isNotEmpty ? parts.join(', ') : null;
      }
    } catch (_) {}

    _setDestination(
      tappedPoint,
      addressName: resolvedName ??
          'Point (${tappedPoint.latitude.toStringAsFixed(4)}, ${tappedPoint.longitude.toStringAsFixed(4)})',
    );
  }

  Future<void> _openSearchModal() async {
    final result = await LocationSearchModal.show(context);
    if (result != null && mounted) {
      final fullTitle = result.subtitle != null && result.subtitle!.isNotEmpty
          ? '${result.title}, ${result.subtitle}'
          : result.title;
      _setDestination(result.coordinates, addressName: fullTitle);
    }
  }

  Future<void> _launchGoogleMapsNavigation() async {
    if (_jobSeekerPosition == null || _destinationPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a destination first.')),
      );
      return;
    }

    final origin = _jobSeekerPosition!;
    final dest = _destinationPosition!;

    // Google Maps Navigation Directions URL
    final googleMapsUrl ='https://www.google.com/maps/dir/?api=1&origin=${origin.latitude},${origin.longitude}&destination=${dest.latitude},${dest.longitude}&travelmode=driving';

    final uri = Uri.parse(googleMapsUrl);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        // Fallback to in-app web if external app failed
        await launchUrl(uri);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open Google Maps: $e')),
        );
      }
    }
  }

  void _clearDestination() {
    setState(() {
      _destinationPosition = null;
      _destinationAddress = null;
      _routeResult = null;
      _straightLineDistanceMeters = null;
      _polylines.clear();
    });
    _updateMarkers();

    if (_jobSeekerPosition != null) {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _jobSeekerPosition!, zoom: 15),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final originPos = _jobSeekerPosition ?? _defaultLocation;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.92),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Location & Distance',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Refresh GPS',
            icon: _isLoadingGps
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location, color: Colors.blue),
            onPressed: _initJobSeekerLocation,
          ),
          PopupMenuButton<MapType>(
            tooltip: 'Map Type',
            icon: const Icon(Icons.layers_outlined, color: Colors.black87),
            onSelected: (type) => setState(() => _currentMapType = type),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: MapType.normal,
                child: Text('Normal Map'),
              ),
              const PopupMenuItem(
                value: MapType.satellite,
                child: Text('Satellite Map'),
              ),
              const PopupMenuItem(
                value: MapType.terrain,
                child: Text('Terrain Map'),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          // 1. Google Map View
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: originPos,
              zoom: 14.5,
            ),
            mapType: _currentMapType,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
            markers: _markers,
            polylines: _polylines,
            onTap: _onMapTapped,
            onMapCreated: (controller) {
              _mapController = controller;
              if (_destinationPosition != null && _jobSeekerPosition != null) {
                _fitCameraBounds();
              } else if (_jobSeekerPosition != null) {
                controller.animateCamera(
                  CameraUpdate.newLatLngZoom(_jobSeekerPosition!, 15),
                );
              }
            },
          ),

          // 2. Top Job Seeker Coordinates Card & Search Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // GPS Status & Coordinates Chip Card
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _jobSeekerPosition != null
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Job Seeker GPS Location',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            if (_jobSeekerPosition != null)
                              Text(
                                '${_jobSeekerPosition!.latitude.toStringAsFixed(4)}, ${_jobSeekerPosition!.longitude.toStringAsFixed(4)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                          ],
                        ),
                        if (_jobSeekerAddress != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            _jobSeekerAddress!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (_gpsError != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            _gpsError!,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Search Destination Button Bar
                  GestureDetector(
                    onTap: _openSearchModal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.blue, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _destinationAddress != null
                                  ? _destinationAddress!
                                  : 'Search any location / address...',
                              style: TextStyle(
                                color: _destinationAddress != null
                                    ? Colors.black87
                                    : Colors.grey.shade600,
                                fontSize: 14,
                                fontWeight: _destinationAddress != null
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (_destinationPosition != null)
                            GestureDetector(
                              onTap: _clearDestination,
                              child: const Icon(
                                Icons.close,
                                color: Colors.grey,
                                size: 20,
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Tap or Search',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Floating Re-Center Button
          Positioned(
            right: 16,
            bottom: _destinationPosition != null ? 260 : 110,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_destinationPosition != null)
                  FloatingActionButton.small(
                    heroTag: 'fit_bounds_btn',
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue.shade700,
                    tooltip: 'Fit Route',
                    onPressed: _fitCameraBounds,
                    child: const Icon(Icons.crop_free),
                  ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'my_location_btn',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue.shade700,
                  tooltip: 'Go to My Location',
                  onPressed: () {
                    if (_jobSeekerPosition != null) {
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(_jobSeekerPosition!, 16),
                      );
                    } else {
                      _initJobSeekerLocation();
                    }
                  },
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          ),

          // 4. Bottom Distance and Launch Google Maps Card
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: DistanceInfoCard(
              origin: originPos,
              destination: _destinationPosition,
              originAddress: _jobSeekerAddress,
              destinationAddress: _destinationAddress,
              routeResult: _routeResult,
              straightLineDistanceMeters: _straightLineDistanceMeters,
              isLoadingRoute: _isLoadingRoute,
              onLaunchGoogleMaps: _launchGoogleMapsNavigation,
              onClearDestination: _clearDestination,
            ),
          ),
        ],
      ),
    );
  }
}
