import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class JobSeekerLocationMapPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String? jobSeekerName;
  final String? address;

  const JobSeekerLocationMapPage({
    super.key,
    required this.latitude,
    required this.longitude,
    this.jobSeekerName,
    this.address,
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
  }

  // ভবিষ্যতে WebSocket থেকে নতুন লোকেশন আসলে এই ফাংশন দিয়ে সহজেই আপডেট করতে পারবেন
  void updateLocation(double newLat, double newLng) {
    setState(() {
      _currentPosition = LatLng(newLat, newLng);
      _markers.clear();
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
        },
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
