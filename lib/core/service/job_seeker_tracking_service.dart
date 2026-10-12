import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:location_tracking/core/constants/app_urls.dart';
import 'package:location_tracking/core/dio/injection_container.dart';
import 'package:location_tracking/core/local_database/auth_db.dart';

class JobSeekerTrackingService {
  static final JobSeekerTrackingService _instance =JobSeekerTrackingService._internal();
  factory JobSeekerTrackingService() => _instance;
  JobSeekerTrackingService._internal();

  socket_io.Socket? _socket;
  StreamSubscription<Position>? _positionStreamSubscription;
  Position? _lastSentPosition;

  final ValueNotifier<bool> isConnectedNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isTrackingActiveNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isGpsEnabledNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<Position?> lastSentPositionNotifier = ValueNotifier<Position?>(null);
  final ValueNotifier<DateTime?> lastSentTimeNotifier = ValueNotifier<DateTime?>(null);

  bool get isConnected => isConnectedNotifier.value;
  bool get isTrackingActive => isTrackingActiveNotifier.value;

  String? currentUserId;
  String? get socketId => _socket?.id;

  /// Check device GPS hardware status
  Future<bool> checkGpsStatus() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    isGpsEnabledNotifier.value = enabled;
    return enabled;
  }

  /// Initialize socket connection for Job Seeker
  Future<void> initSocket() async {
    if (_socket != null && _socket!.connected) {
      if (kDebugMode) {
        print('⚡ [JobSeeker Socket] Already connected (Socket ID: ${_socket?.id})');
      }
      return;
    }

    try {
      final token = await getIt<AuthLocalDB>().getToken() ?? '';
      final userId = await getIt<AuthLocalDB>().getUserId() ?? '';
      currentUserId = userId;

      if (token.isEmpty) {
        if (kDebugMode) {
          print('⚠️ [JobSeeker Socket] No token found in AuthLocalDB. Skipping connect.');
        }
        return;
      }

      final socketUrl = AppUrls.socketUrl;
      if (kDebugMode) {
        print('🚀 [JobSeeker Socket] Connecting to $socketUrl');
        print('🚀 [JobSeeker Socket] Auth payload: id=$userId, type=JOB_SEEKER, tokenLength=${token.length}');
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
              'type': 'JOB_SEEKER',
            })
            .setQuery({
              'token': token,
              'id': userId,
              'type': 'JOB_SEEKER',
            })
            .setExtraHeaders({'Authorization': 'Bearer $token'})
            .enableReconnection()
            .setReconnectionDelay(2000)
            .build(),
      );

      _socket?.connect();

      _socket?.onConnect((_) {
        if (kDebugMode) {
          print('✅ [JobSeeker Socket] Connected successfully! Socket ID: ${_socket?.id}');
        }
        isConnectedNotifier.value = true;
      });

      // Listen for Hotelier starting the live watch (handle possible naming variations)
      void handleStartSignal(dynamic data) {
        if (kDebugMode) {
          print('🎯 [JobSeeker Socket] >>> RECEIVED START TRACKING SIGNAL! <<< Data: $data');
        }
        startTracking();
      }

      _socket?.on('start-location-tracking', handleStartSignal);
      _socket?.on('start_location_tracking', handleStartSignal);
      _socket?.on('start-tracking', handleStartSignal);
      _socket?.on('hotelier:watch', handleStartSignal);

      // Listen for Hotelier leaving/stopping the live watch
      void handleStopSignal(dynamic data) {
        if (kDebugMode) {
          print('🛑 [JobSeeker Socket] >>> RECEIVED STOP TRACKING SIGNAL! <<< Data: $data');
        }
        stopTracking();
      }

      _socket?.on('stop-location-tracking', handleStopSignal);
      _socket?.on('stop_location_tracking', handleStopSignal);
      _socket?.on('stop-tracking', handleStopSignal);
      _socket?.on('hotelier:unwatch', handleStopSignal);

      _socket?.onDisconnect((reason) {
        if (kDebugMode) {
          print('⚠️ [JobSeeker Socket] Disconnected. Reason: $reason');
        }
        isConnectedNotifier.value = false;
        stopTracking();
      });

      _socket?.onConnectError((err) {
        if (kDebugMode) {
          print('❌ [JobSeeker Socket] Connection error: $err');
        }
        isConnectedNotifier.value = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('❌ [JobSeeker Socket] Init exception: $e');
      }
    }
  }

  /// Start GPS tracking with distance filter (only when moving)
  Future<void> startTracking() async {
    if (_positionStreamSubscription != null) {
      if (kDebugMode) {
        print('⚡ [JobSeeker GPS] Already tracking');
      }
      return;
    }

    if (kDebugMode) {
      print('📍 [JobSeeker GPS] startTracking called. Checking permissions...');
    }

    // 1. Permission checks
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    isGpsEnabledNotifier.value = serviceEnabled;
    if (!serviceEnabled) {
      if (kDebugMode) {
        print('⚠️ [JobSeeker GPS] Location service is DISABLED on device! Opening location settings...');
      }
      await Geolocator.openLocationSettings();
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (kDebugMode) {
      print('📍 [JobSeeker GPS] Current permission: $permission');
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (kDebugMode) {
        print('📍 [JobSeeker GPS] Requested permission result: $permission');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (kDebugMode) {
        print('⚠️ [JobSeeker GPS] Location permission DENIED FOREVER. Opening App Settings...');
      }
      await Geolocator.openAppSettings();
      return;
    }
    if (permission == LocationPermission.denied) {
      if (kDebugMode) {
        print('⚠️ [JobSeeker GPS] Location permission DENIED!');
      }
      return;
    }

    isTrackingActiveNotifier.value = true;

    // 2. Send current initial location immediately once upon starting
    try {
      if (kDebugMode) {
        print('📍 [JobSeeker GPS] Fetching initial location...');
      }
      final initialPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (kDebugMode) {
        print('📍 [JobSeeker GPS] Initial location obtained: ${initialPosition.latitude}, ${initialPosition.longitude}');
      }
      _sendLocation(initialPosition);
    } catch (e) {
      if (kDebugMode) {
        print('❌ [JobSeeker GPS] Error getting initial position: $e');
      }
    }

    // 3. Start position stream with distanceFilter (hardware-level movement detection)
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 8, // 👈 Only triggers when moved >= 8 meters
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        _handlePositionUpdate(position);
      },
      onError: (err) {
        if (kDebugMode) {
          print('❌ [JobSeeker GPS] Position stream error: $err');
        }
      },
    );

    if (kDebugMode) {
      print('✅ [JobSeeker GPS] Live tracking stream ACTIVE (distanceFilter: 8m)');
    }
  }

  void _handlePositionUpdate(Position position) {
    // Extra safety: Verify real physical movement to prevent GPS wobbly jitter
    if (_lastSentPosition != null) {
      final distanceMoved = Geolocator.distanceBetween(
        _lastSentPosition!.latitude,
        _lastSentPosition!.longitude,
        position.latitude,
        position.longitude,
      );

      // If moved less than 5 meters, ignore (standing still / GPS drift)
      if (distanceMoved < 5.0) {
        if (kDebugMode) {
          print(
            '⏸️ [JobSeeker GPS] Moved only ${distanceMoved.toStringAsFixed(1)}m (< 5m). Skipping send.',
          );
        }
        return;
      }
    }

    _sendLocation(position);
  }

  void _sendLocation(Position position) {
    if (_socket == null || !_socket!.connected) {
      if (kDebugMode) {
        print('⚠️ [JobSeeker Socket] Cannot send location: socket not connected');
      }
      return;
    }

    final payload = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'heading': position.heading,
      'speed': position.speed,
      'accuracy': position.accuracy,
      'timestamp': DateTime.now().toIso8601String(),
    };

    _socket?.emit('send-location', payload);
    _lastSentPosition = position;
    lastSentPositionNotifier.value = position;
    lastSentTimeNotifier.value = DateTime.now();

    if (kDebugMode) {
      print('📡 [JobSeeker Socket] EMITTED "send-location": lat=${position.latitude}, lng=${position.longitude}, speed=${position.speed.toStringAsFixed(1)}');
    }
  }

  /// Stop GPS tracking stream
  void stopTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _lastSentPosition = null;
    isTrackingActiveNotifier.value = false;
    if (kDebugMode) {
      print('JobSeekerTrackingService: Tracking stopped');
    }
  }

  /// Disconnect socket completely (e.g. on logout)
  void disconnect() {
    stopTracking();
    _socket?.clearListeners();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    isConnectedNotifier.value = false;
    if (kDebugMode) {
      print('JobSeekerTrackingService: Socket disconnected');
    }
  }

  /// Reconnect socket cleanly
  Future<void> reconnect() async {
    disconnect();
    await initSocket();
  }
}
