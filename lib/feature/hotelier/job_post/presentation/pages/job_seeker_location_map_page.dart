import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class JobSeekerLocationMapPage extends StatefulWidget {
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
  State<JobSeekerLocationMapPage> createState() =>
      _JobSeekerLocationMapPageState();
}

class _JobSeekerLocationMapPageState extends State<JobSeekerLocationMapPage> {
  GoogleMapController? _mapController;
  late LatLng _currentPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // ১. শুরুতে প্রাপ্ত Latitude ও Longitude দিয়ে কারেন্ট পজিশন সেট করা
    _currentPosition = LatLng(widget.latitude, widget.longitude);

    // ২. ম্যাপে Job Seeker-এর জন্য একটি মার্কার অ্যাড করা
    _markers.add(
      Marker(
        markerId: const MarkerId('job_seeker_marker'),
        position: _currentPosition,
        infoWindow: InfoWindow(
          title: widget.jobSeekerName ?? 'Job Seeker',
          snippet: widget.address ?? 'Current Location',
        ),
      ),
    );

    // ৩. Hotelier-এর লোকেশন থাকলে সেটির জন্যও মার্কার অ্যাড করা
    if (widget.hotelierLatitude != null && widget.hotelierLongitude != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('hotelier_marker'),
          position: LatLng(widget.hotelierLatitude!, widget.hotelierLongitude!),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          infoWindow: InfoWindow(
            title: widget.hotelierName ?? 'Hotel Location',
            snippet: widget.hotelierAddress ?? 'Work Location',
          ),
        ),
      );
    }
  }

  void _fitBothMarkers() {
    if (widget.hotelierLatitude == null || widget.hotelierLongitude == null) return;
    final southwest = LatLng(
      [widget.latitude, widget.hotelierLatitude!].reduce((a, b) => a < b ? a : b),
      [widget.longitude, widget.hotelierLongitude!].reduce((a, b) => a < b ? a : b),
    );
    final northeast = LatLng(
      [widget.latitude, widget.hotelierLatitude!].reduce((a, b) => a > b ? a : b),
      [widget.longitude, widget.hotelierLongitude!].reduce((a, b) => a > b ? a : b),
    );
    final bounds = LatLngBounds(southwest: southwest, northeast: northeast);
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

  // ভবিষ্যতে WebSocket থেকে নতুন লোকেশন আসলে এই ফাংশন দিয়ে সহজেই আপডেট করতে পারবেন
  void updateLocation(double newLat, double newLng) {
    setState(() {
      _currentPosition = LatLng(newLat, newLng);
      _markers.removeWhere((m) => m.markerId.value == 'job_seeker_marker');
      _markers.add(
        Marker(
          markerId: const MarkerId('job_seeker_marker'),
          position: _currentPosition,
          infoWindow: InfoWindow(
            title: widget.jobSeekerName ?? 'Job Seeker',
            snippet: widget.address ?? 'Current Location',
          ),
        ),
      );
    });

    // ক্যামেরাও নতুন লোকেশনে স্মুথলি মুভ করবে
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(_currentPosition),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jobSeekerName ?? 'Job Seeker Location'),
      ),
      body: GoogleMap(
        // প্রাথমিক ক্যামেরা ভিউ
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 15.0,
        ),
        // ম্যাপে মার্কার দেখানো
        markers: _markers,
        // ম্যাপ তৈরি হলে কন্ট্রোলার পাওয়া যায়
        onMapCreated: (controller) {
          _mapController = controller;
          if (widget.hotelierLatitude != null && widget.hotelierLongitude != null) {
            _fitBothMarkers();
          }
        },
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
