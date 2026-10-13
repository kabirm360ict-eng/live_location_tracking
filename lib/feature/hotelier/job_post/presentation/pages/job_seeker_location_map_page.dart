import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:location_tracking/core/constants/app_urls.dart';
import 'package:location_tracking/core/dio/injection_container.dart';
import 'package:location_tracking/core/local_database/auth_db.dart';
import 'package:location_tracking/core/service/route_service.dart';

class JobSeekerLocationMapPage extends StatefulWidget {
  final int? jobSeekerId;
  final double latitude;
  final double longitude;
  final String? jobSeekerName;
  final String? address;
  final double? hotelierLatitude;
  final double? hotelierLongitude;
  final String? hotelierName;
  final String? hotelierAddress;

  const JobSeekerLocationMapPage({
    super.key,
    this.jobSeekerId,
    required this.latitude,
    required this.longitude,
    this.jobSeekerName,
    this.address,
    this.hotelierLatitude,
    this.hotelierLongitude,
    this.hotelierName,
    this.hotelierAddress,
  });

  @override
  State<JobSeekerLocationMapPage> createState() =>_JobSeekerLocationMapPageState();
}

class _JobSeekerLocationMapPageState extends State<JobSeekerLocationMapPage>
    with SingleTickerProviderStateMixin {
  GoogleMapController? _mapController;
  late LatLng _currentPosition;
  final Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  // Real Road Route following streets and turns
  List<LatLng> _roadRoutePoints = [];
  double? _roadDistanceMeters;
  double? _roadDurationSeconds;
  LatLng? _lastFetchedRouteOrigin;
  bool _isFetchingRoute = false;

  socket_io.Socket? _socket;
  bool _isConnected = false;
  bool _hasReceivedLiveLocation = false;
  bool _autoFollow = true;
  bool _isDisposed = false;

  // Pathao-style Smooth Animation & Rotation
  late AnimationController _animController;
  late Animation<double> _animation;
  Tween<double> _latTween = Tween<double>(begin: 0, end: 0);
  Tween<double> _lngTween = Tween<double>(begin: 0, end: 0);
  double _currentBearing = 0.0;
  BitmapDescriptor? _jobSeekerIcon;

  @override
  void initState() {
    super.initState();
    _currentPosition = LatLng(widget.latitude, widget.longitude);

    // Animation Controller for Pathao-like smooth interpolation
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _animation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );

    _animController.addListener(() {
      if (_isDisposed || !mounted) return;
      final currentLat = _latTween.evaluate(_animation);
      final currentLng = _lngTween.evaluate(_animation);
      final interpolated = LatLng(currentLat, currentLng);

      _currentPosition = interpolated;
      _updateJobSeekerMarker(interpolated, _currentBearing);

      if (_autoFollow && !_isDisposed && mounted) {
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(interpolated),
        );
      }
    });

    _initCustomMarkerAndMap();
    _connectSocket();
  }

  Future<void> _initCustomMarkerAndMap() async {
    _jobSeekerIcon = await _createDirectionalMarkerIcon();

    _updateJobSeekerMarker(_currentPosition, _currentBearing);

    // Hotelier Destination Marker
    if (widget.hotelierLatitude != null && widget.hotelierLongitude != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('hotelier_marker'),
          position: LatLng(widget.hotelierLatitude!, widget.hotelierLongitude!),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: widget.hotelierName ?? 'Hotel Location',
            snippet: widget.hotelierAddress ?? 'Workplace Destination',
          ),
        ),
      );
      _updatePolyline();
      _fetchRoadRoute();
    }

    if (!_isDisposed && mounted) setState(() {});
  }

  /// Create custom navigation / Pathao-style directional arrow marker bitmap
  Future<BitmapDescriptor> _createDirectionalMarkerIcon() async {
    try {
      final pictureRecorder = ui.PictureRecorder();
      final canvas = Canvas(pictureRecorder);
      const size = 120.0;

      // Glow shadow
      final shadowPaint = Paint()
        ..color = const Color(0xFF007AFF).withValues(alpha: 0.25)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(const Offset(size / 2, size / 2), 56, shadowPaint);

      // White outer disc
      final whitePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(const Offset(size / 2, size / 2), 46, whitePaint);

      // Primary Blue disc (Pathao / Google Navigation Blue)
      final bluePaint = Paint()
        ..color = const Color(0xFF007AFF)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(const Offset(size / 2, size / 2), 38, bluePaint);

      // Arrow pointing up (Heading 0 deg)
      final arrowPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      final path = Path()
        ..moveTo(size / 2, size / 2 - 22)
        ..lineTo(size / 2 + 18, size / 2 + 18)
        ..lineTo(size / 2, size / 2 + 9)
        ..lineTo(size / 2 - 18, size / 2 + 18)
        ..close();
      canvas.drawPath(path, arrowPaint);

      final picture = pictureRecorder.endRecording();
      final image = await picture.toImage(size.toInt(), size.toInt());
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      if (bytes != null) {
        return BitmapDescriptor.bytes(
          bytes.buffer.asUint8List(),
          width: 36,
          height: 36,
        );
      }
    } catch (e) {
      debugPrint('Error creating custom marker: $e');
    }
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
  }

  void _updateJobSeekerMarker(LatLng position, double bearing) {
    if (_isDisposed || !mounted) return;
    _markers.removeWhere((m) => m.markerId.value == 'job_seeker_marker');
    _markers.add(
      Marker(
        markerId: const MarkerId('job_seeker_marker'),
        position: position,
        rotation: bearing,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        icon: _jobSeekerIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(
          title: widget.jobSeekerName ?? 'Job Seeker',
          snippet: widget.address ?? 'Current Location',
        ),
      ),
    );
    _updatePolyline();
    if (!_isDisposed && mounted) setState(() {});
  }

  void _updatePolyline() {
    if (widget.hotelierLatitude == null || widget.hotelierLongitude == null) {
      return;
    }
    final destination =
        LatLng(widget.hotelierLatitude!, widget.hotelierLongitude!);

    List<LatLng> points;
    if (_roadRoutePoints.isEmpty) {
      points = [_currentPosition, destination];
    } else if (_roadRoutePoints.length < 2) {
      points = [_currentPosition, ..._roadRoutePoints];
    } else {
      // Find the segment in _roadRoutePoints closest to _currentPosition.
      // All points before this segment are behind the vehicle and must NOT be drawn backwards!
      int bestSegmentIndex = 0;
      double minDistance = double.infinity;

      for (int i = 0; i < _roadRoutePoints.length - 1; i++) {
        final d = _distanceToSegmentSquared(
          _currentPosition,
          _roadRoutePoints[i],
          _roadRoutePoints[i + 1],
        );
        if (d < minDistance) {
          minDistance = d;
          bestSegmentIndex = i;
        }
      }

      // Remaining forward points towards the destination
      final aheadPoints = _roadRoutePoints.sublist(bestSegmentIndex + 1);
      points = [_currentPosition, ...aheadPoints];
    }

    _polylines = {
      Polyline(
        polylineId: const PolylineId('route_line'),
        points: points,
        color: const Color(0xFF007AFF),
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
        patterns: _roadRoutePoints.isNotEmpty
            ? const []
            : [PatternItem.dash(18), PatternItem.gap(10)],
      ),
    };
  }

  double _distanceToSegmentSquared(LatLng p, LatLng a, LatLng b) {
    final l2 = _latLngDistanceSquared(a, b);
    if (l2 == 0) return _latLngDistanceSquared(p, a);
    final t = max(
      0.0,
      min(
        1.0,
        ((p.latitude - a.latitude) * (b.latitude - a.latitude) +
                (p.longitude - a.longitude) * (b.longitude - a.longitude)) /
            l2,
      ),
    );
    final projLat = a.latitude + t * (b.latitude - a.latitude);
    final projLng = a.longitude + t * (b.longitude - a.longitude);
    return _latLngDistanceSquared(p, LatLng(projLat, projLng));
  }

  double _latLngDistanceSquared(LatLng p1, LatLng p2) {
    final dLat = p1.latitude - p2.latitude;
    final dLng = p1.longitude - p2.longitude;
    return dLat * dLat + dLng * dLng;
  }

  /// Fetch genuine turn-by-turn road route via OSRM
  Future<void> _fetchRoadRoute({LatLng? origin}) async {
    if (_isDisposed ||
        widget.hotelierLatitude == null ||
        widget.hotelierLongitude == null ||
        _isFetchingRoute) {
      return;
    }
    final routeOrigin = origin ?? _currentPosition;
    _isFetchingRoute = true;
    _lastFetchedRouteOrigin = routeOrigin;

    try {
      final result = await RouteService.getRoadRoute(
        origin: routeOrigin,
        destination:
            LatLng(widget.hotelierLatitude!, widget.hotelierLongitude!),
      );

      if (_isDisposed || !mounted) return;

      if (result != null && result.points.isNotEmpty) {
        _roadRoutePoints = result.points;
        _roadDistanceMeters = result.distanceMeters;
        _roadDurationSeconds = result.durationSeconds;
        _updatePolyline();
        if (!_isDisposed && mounted) setState(() {});
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching road route: $e');
      }
    } finally {
      _isFetchingRoute = false;
    }
  }

  // Socket Connection and Event Listeners
  Future<void> _connectSocket() async {
    try {
      final token = await getIt<AuthLocalDB>().getToken() ?? '';
      final userId = await getIt<AuthLocalDB>().getUserId() ?? '';
      final socketUrl = AppUrls.socketUrl;

      if (kDebugMode) {
        print('Connecting to Socket.io: $socketUrl with id: $userId for JobSeekerId: ${widget.jobSeekerId}');
      }

      _socket = socket_io.io(
        socketUrl,
        socket_io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .enableForceNew()
            .setAuth({
              'token': token,
              'id': int.tryParse(userId) ?? userId,
              'type': 'HOTELIER',
            })
            .setQuery({
              'token': token,
              'id': userId,
              'type': 'HOTELIER',
            })
            .setExtraHeaders({'Authorization': 'Bearer $token'})
            .enableReconnection()
            .setReconnectionDelay(2000)
            .build(),
      );

      _socket?.connect();

      _socket?.onConnect((_) {
        if (_isDisposed || !mounted) return;
        if (kDebugMode) {
          print('✅ [Hotelier Socket] Connected successfully! Socket ID: ${_socket?.id}');
        }
        setState(() => _isConnected = true);

        // Tell server hotelier is watching this job seeker
        if (widget.jobSeekerId != null) {
          if (kDebugMode) {
            print('📡 [Hotelier Socket] Emitting hotelier:watch for JobSeekerId: ${widget.jobSeekerId}');
          }
          _socket?.emit('hotelier:watch', {
            'jobSeekerId': widget.jobSeekerId,
          });
        }
      });

      _socket?.on('receive-location', (data) {
        if (_isDisposed || !mounted) return;
        if (kDebugMode) {
          print('📡 [Hotelier Socket] >>> RECEIVED receive-location! <<< Data: $data');
        }
        if (!_hasReceivedLiveLocation) {
          _hasReceivedLiveLocation = true;
          if (mounted) setState(() {});
        }
        _onLocationReceived(data);
      });

      _socket?.onDisconnect((reason) {
        if (_isDisposed || !mounted) return;
        if (kDebugMode) {
          print('⚠️ [Hotelier Socket] Disconnected. Reason: $reason');
        }
        setState(() {
          _isConnected = false;
          _hasReceivedLiveLocation = false;
        });
      });

      _socket?.onConnectError((err) {
        if (_isDisposed || !mounted) return;
        if (kDebugMode) {
          print('❌ [Hotelier Socket] Connection error: $err');
        }
        setState(() {
          _isConnected = false;
          _hasReceivedLiveLocation = false;
        });
      });
    } catch (e) {
      if (kDebugMode) {
        print('Socket init exception: $e');
      }
    }
  }

  void _onLocationReceived(dynamic rawData) {
    Map<String, dynamic> data;
    if (rawData is Map) {
      data = Map<String, dynamic>.from(rawData);
    } else if (rawData is String) {
      try {
        data = jsonDecode(rawData);
      } catch (_) {
        return;
      }
    } else {
      return;
    }

    final lat = double.tryParse('${data['latitude'] ?? data['lat'] ?? ''}');
    final lng = double.tryParse('${data['longitude'] ?? data['lng'] ?? ''}');
    if (lat == null || lng == null || lat == 0.0 || lng == 0.0) return;

    final double? explicitBearing = double.tryParse(
      '${data['bearing'] ?? data['heading'] ?? ''}',
    );

    _animateMarkerTo(LatLng(lat, lng), explicitBearing: explicitBearing);
  }

  /// Pathao-style Smooth Movement between coordinates
  void _animateMarkerTo(LatLng newPosition, {double? explicitBearing}) {
    final startPosition = _currentPosition;
    final endPosition = newPosition;

    // Calculate bearing for directional rotation
    final targetBearing = explicitBearing ?? _calculateBearing(startPosition, endPosition);
    if (targetBearing != 0.0) {
      _currentBearing = targetBearing;
    }

    _latTween = Tween<double>(begin: startPosition.latitude,end: endPosition.latitude);
    _lngTween = Tween<double>(begin: startPosition.longitude,end: endPosition.longitude);

    _animController.reset();
    _animController.forward();

    // Re-calculate genuine road route if moved > 35m or if never fetched
    final lastOrigin = _lastFetchedRouteOrigin;
    if (lastOrigin == null ||
        Geolocator.distanceBetween(
          lastOrigin.latitude,
          lastOrigin.longitude,
          newPosition.latitude,
          newPosition.longitude,
        ) > 35) {
      _fetchRoadRoute(origin: newPosition);
    }
  }

  double _calculateBearing(LatLng start, LatLng end) {
    if (start.latitude == end.latitude && start.longitude == end.longitude) {
      return _currentBearing;
    }
    final lat1 = start.latitude * (pi / 180.0);
    final lon1 = start.longitude * (pi / 180.0);
    final lat2 = end.latitude * (pi / 180.0);
    final lon2 = end.longitude * (pi / 180.0);

    final dLon = lon2 - lon1;
    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    final radians = atan2(y, x);
    return (radians * (180.0 / pi) + 360.0) % 360.0;
  }

  void _fitBothMarkers() {
    if (widget.hotelierLatitude == null || widget.hotelierLongitude == null) {
      _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition));
      return;
    }
    final southwest = LatLng(
      [_currentPosition.latitude, widget.hotelierLatitude!]
          .reduce((a, b) => a < b ? a : b),
      [_currentPosition.longitude, widget.hotelierLongitude!]
          .reduce((a, b) => a < b ? a : b),
    );
    final northeast = LatLng(
      [_currentPosition.latitude, widget.hotelierLatitude!]
          .reduce((a, b) => a > b ? a : b),
      [_currentPosition.longitude, widget.hotelierLongitude!]
          .reduce((a, b) => a > b ? a : b),
    );
    final bounds = LatLngBounds(southwest: southwest, northeast: northeast);
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  double? get _distanceInMeters {
    if (widget.hotelierLatitude == null || widget.hotelierLongitude == null) {
      return null;
    }
    return _roadDistanceMeters ??
        Geolocator.distanceBetween(
          _currentPosition.latitude,
          _currentPosition.longitude,
          widget.hotelierLatitude!,
          widget.hotelierLongitude!,
        );
  }

  String get _formattedDistance {
    final d = _distanceInMeters;
    if (d == null) return '';
    if (d >= 1000) {
      return '${(d / 1000).toStringAsFixed(1)} km';
    }
    return '${d.toStringAsFixed(0)} m';
  }

  String get _formattedEta {
    if (_roadDurationSeconds == null || _roadDurationSeconds! <= 0) return '';
    final minutes = (_roadDurationSeconds! / 60).round();
    if (minutes < 1) return '< 1 min';
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final remMin = minutes % 60;
      return remMin > 0 ? '$hours hr $remMin min' : '$hours hr';
    }
    return '$minutes min';
  }

  @override
  void dispose() {
    _isDisposed = true;

    // 1. Unwatch on backend
    if (widget.jobSeekerId != null && _socket != null && _socket!.connected) {
      _socket?.emit('hotelier:unwatch', {
        'jobSeekerId': widget.jobSeekerId,
      });
      if (kDebugMode) {
        print('Emitted hotelier:unwatch for ${widget.jobSeekerId}');
      }
    }

    // 2. Clear ALL listeners BEFORE disconnecting to prevent defunct setState
    _socket?.clearListeners();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;

    // 3. Stop and dispose animation controller
    _animController.stop();
    _animController.dispose();

    // 4. Dispose map controller
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 16.0,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (controller) {
              _mapController = controller;
              if (widget.hotelierLatitude != null &&
                  widget.hotelierLongitude != null) {
                _fitBothMarkers();
              }
            },
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
          ),

          // 2. Top Header with Back Button & Live Status Pill
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Back Button
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black87,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Live Status Pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: !_isConnected
                                ? Colors.orangeAccent
                                : (!_hasReceivedLiveLocation
                                    ? Colors.blueAccent
                                    : Colors.greenAccent.shade700),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(!_isConnected ? 'Connecting...': (!_hasReceivedLiveLocation ? 'Waiting for Job Seeker...': 'Live Tracking'),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: !_isConnected
                                ? Colors.orange.shade800
                                : (!_hasReceivedLiveLocation
                                    ? Colors.blue.shade800
                                    : Colors.green.shade800),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Fit Both / Recenter Button
                  InkWell(
                    onTap: _fitBothMarkers,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.zoom_out_map,
                        color: Colors.black87,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Floating Bottom Sheet (Pathao-style Ride / Job Seeker Info)
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rider / Job Seeker Header Row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFF007AFF).withValues(alpha: 0.12),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFF007AFF),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.jobSeekerName ?? 'Applicant',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _formattedDistance.isNotEmpty
                                  ? '$_formattedDistance${_formattedEta.isNotEmpty ? ' • ~$_formattedEta' : ''} away from hotel'
                                  : 'On the way to destination',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Auto follow toggle button
                      IconButton(
                        onPressed: () {
                          setState(() => _autoFollow = !_autoFollow);
                          if (_autoFollow) {
                            _mapController?.animateCamera(
                              CameraUpdate.newLatLng(_currentPosition),
                            );
                          }
                        },
                        icon: Icon(
                          _autoFollow ? Icons.my_location : Icons.location_searching,
                          color: _autoFollow ? const Color(0xFF007AFF) : Colors.grey,
                        ),
                        tooltip: _autoFollow ? 'Auto-following Job Seeker': 'Follow paused',
                      ),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),

                  // Destination Details Row
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.hotelierName != null
                              ? '${widget.hotelierName} (${widget.hotelierAddress ?? 'Destination'})'
                              : widget.hotelierAddress ?? 'Workplace Destination',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
