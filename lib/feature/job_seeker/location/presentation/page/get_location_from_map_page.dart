import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_tracking/core/constants/app_size.dart';
import 'package:location_tracking/core/model/full_address.dart';
import 'package:location_tracking/core/utilities/get_address.dart';
import 'package:location_tracking/core/utilities/location_utils.dart';
import 'package:location_tracking/core/widgets/app_map_center_pin.dart';
import 'package:location_tracking/feature/job_seeker/location/presentation/page/google_auto_complete_address_page.dart';

// import '../../../../core/constants/app_sizes.dart';
// import '../../../../core/models/full_address.dart';
// import '../../../../core/utilities/get_address.dart';
// import '../../../../core/utilities/location_utils.dart';
// import '../../../../core/widgets/app_map_center_pin.dart';
// import 'google_auto_complete_address_page.dart';

/// Interactive Map Location Picker for TOVOZO.
///
/// Harmonized with [RegistrationPageJob] and the staffing design system:
/// - Floating search card with address and postcode lookup.
/// - Interactive center pin with dynamic elevation, coordinate reticle, and tooltip.
/// - One-touch GPS re-centering & tactile zoom controls.
/// - Rich bottom address card with postcode chips, street breakdown, and verification status.
/// - Clean permission-denied state with quick action recovery.
class GetLocationFromMapPage extends StatefulWidget {
  const GetLocationFromMapPage({
    super.key,
    this.isJobSeeker = false,
    this.addressDetailsHave,
  });

  /// Whether the caller is a job seeker choosing their shift work radius.
  final bool isJobSeeker;

  /// Optional pre-existing address to initialize the camera position.
  final FullAddress? addressDetailsHave;

  @override
  State<GetLocationFromMapPage> createState() => _GetLocationFromMapPageState();
}

class _GetLocationFromMapPageState extends State<GetLocationFromMapPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  // Default  central coordinate (London) used as fallback
  static const LatLng _fallbackPosition = LatLng(51.5074, -0.1278);

  bool _isLocationPermissionGranted = true;
  final TextEditingController _addressController = TextEditingController();
  FullAddress? hotelAddressDetails;

  LatLng? _currentPosition;
  final Completer<GoogleMapController> _mapController = Completer();

  bool _isFetchingAddress = false;
  bool _isMapMoving = false;
  Timer? _debounce;

  // Animation controller for the center pin bounce
  late final AnimationController _pinAnimController;
  late final Animation<double> _pinBounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _pinAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    _pinBounce = Tween<double>(begin: 0.0, end: -20.0).animate(
      CurvedAnimation(parent: _pinAnimController, curve: Curves.easeOutBack),
    );

    _checkPermissionStatus();
    _determinePosition();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pinAnimController.dispose();
    _debounce?.cancel();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissionStatus();
    }
  }

  Future<void> _checkPermissionStatus() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    final permission = await Geolocator.checkPermission();
    if (mounted) {
      setState(() {
        _isLocationPermissionGranted =
            serviceEnabled &&
            (permission == LocationPermission.always ||
                permission == LocationPermission.whileInUse);
      });
      if (_isLocationPermissionGranted && _currentPosition == null) {
        _determinePosition();
      }
    }
  }

  Future<void> _animateCameraTo(LatLng position, {double zoom = 16.5}) async {
    try {
      final controller = await _mapController.future;
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: zoom),
        ),
      );
    } catch (e) {
      debugPrint('Error animating camera: $e');
    }
  }

  Future<void> _zoomCamera(bool zoomIn) async {
    try {
      final controller = await _mapController.future;
      await controller.animateCamera(
        zoomIn ? CameraUpdate.zoomIn() : CameraUpdate.zoomOut(),
      );
    } catch (e) {
      debugPrint('Error zooming map: $e');
    }
  }

  Future<void> _determinePosition() async {
    try {
      Position? position;
      if (widget.addressDetailsHave != null &&
          widget.addressDetailsHave!.latitude != null &&
          widget.addressDetailsHave!.longitude != null) {
        hotelAddressDetails = widget.addressDetailsHave;
        position = Position(
          latitude: widget.addressDetailsHave!.latitude!,
          longitude: widget.addressDetailsHave!.longitude!,
          timestamp: DateTime.now(),
          accuracy: widget.addressDetailsHave!.accuracy ?? 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
        _addressController.text = widget.addressDetailsHave!.fullAddress ?? '';
      } else {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      }

      if (mounted) {
        final target = LatLng(position.latitude, position.longitude);
        setState(() => _currentPosition = target);
        _animateCameraTo(target);

        if (widget.addressDetailsHave == null) {
          _fetchAddressForPosition(target);
        }
      }
    } catch (e) {
      debugPrint('Error determining initial position: $e');
      if (mounted && _currentPosition == null) {
        // Fallback to  London coordinate
        setState(() => _currentPosition = _fallbackPosition);
        _animateCameraTo(_fallbackPosition, zoom: 12.0);
        _fetchAddressForPosition(_fallbackPosition);
      }
    }
  }

  Future<void> _fetchAddressForPosition(LatLng position) async {
    if (mounted) setState(() => _isFetchingAddress = true);
    try {
      final details = await getAddressFromLatLng(position);
      if (mounted) {
        setState(() {
          hotelAddressDetails = details;
          _addressController.text = details?.fullAddress ?? '';
          _isFetchingAddress = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching address details: $e');
      if (mounted) setState(() => _isFetchingAddress = false);
    }
  }

  void _onMapCameraMoveStart() {
    _debounce?.cancel();
    if (!_isMapMoving) {
      setState(() => _isMapMoving = true);
      _pinAnimController.forward();
    }
  }

  void _onMapCameraIdle() {
    _pinAnimController.reverse();
    setState(() => _isMapMoving = false);
    if (_currentPosition != null) {
      _debounce = Timer(const Duration(milliseconds: 550), () {
        _fetchAddressForPosition(_currentPosition!);
      });
    }
  }

  void _onMapCameraMove(CameraPosition position) {
    _currentPosition = position.target;
  }

  Future<void> _openAutocompleteSearch() async {
    final result = await Navigator.push<FullAddress>(
      context,
      MaterialPageRoute(
        builder: (context) => GoogleAutoCompleteAddressPage(
          address: _addressController.text,
        ),
      ),
    );

    if (result != null && mounted) {
      // Return the confirmed FullAddress directly to caller (e.g. RegistrationPageJob)
      // to preserve custom address fields and prevent map reverse-geocoding overwrites.
      Navigator.pop(context, result);
    }
  }

  Future<void> _recenterToCurrentGps() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final latLng = LatLng(pos.latitude, pos.longitude);
      await _animateCameraTo(latLng);
      if (mounted) {
        setState(() => _currentPosition = latLng);
        _fetchAddressForPosition(latLng);
      }
    } catch (e) {
      debugPrint('Error recentering to GPS: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not fetch your current GPS position.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final primaryColor = cs.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          // ── UPPER MAP AREA ──
          Expanded(
            child: Stack(
              children: [
                // 1. Google Map
                if (_currentPosition != null)
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition!,
                      zoom: 16.5,
                    ),
                    onMapCreated: (controller) {
                      if (!_mapController.isCompleted) {
                        _mapController.complete(controller);
                      }
                    },
                    onCameraMoveStarted: _onMapCameraMoveStart,
                    onCameraMove: _onMapCameraMove,
                    onCameraIdle: _onMapCameraIdle,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                  )
                else if (!_isLocationPermissionGranted)
                  _buildPermissionDeniedView(cs)
                else
                  const Center(child: CircularProgressIndicator.adaptive()),

                // 2. Interactive Center Pin (Reusable Core Widget)
                if (_currentPosition != null)
                  AppMapCenterPin(
                    isMoving: _isMapMoving,
                    bounceAnimation: _pinBounce,
                    tooltipText: hotelAddressDetails?.street ??
                        hotelAddressDetails?.area ??
                        hotelAddressDetails?.city,
                    primaryColor: primaryColor,
                  ),

                // 3. Top Floating Search Bar & Controls
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 16,
                  right: 16,
                  child: _buildTopSearchHeader(primaryColor),
                ),

                // 4. Floating Action Tools (GPS Recenter + Zoom In / Out)
                if (_currentPosition != null)
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: _buildFloatingMapTools(primaryColor),
                  ),
              ],
            ),
          ),

          // ── BOTTOM  ADDRESS SHEET ──
          _buildAddressBottomSheet(primaryColor),
        ],
      ),
    );
  }

  /// Top Floating Search Bar aligned with  design standards
  Widget _buildTopSearchHeader(Color primaryColor) {
    return Row(
      children: [
        // Back Button
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.pop(context),
              child: const Padding(
                padding: EdgeInsets.all(11),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black87,
                  size: 17,
                ),
              ),
            ),
          ),
        ),
    
        const SizedBox(width: 10),
    
        // Search Bar Card
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _openAutocompleteSearch,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _addressController.text.isNotEmpty
                              ? _addressController.text
                              : 'Search address or postcode...',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: _addressController.text.isNotEmpty
                                ? Colors.black87
                                : Colors.grey.shade500,
                            fontSize: 13.5,
                            fontWeight: _addressController.text.isNotEmpty
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (_addressController.text.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Icon(
                          Icons.edit_location_alt_outlined,
                          color: Colors.grey.shade400,
                          size: 18,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Floating tool controls (GPS Recenter + Zoom)
  Widget _buildFloatingMapTools(Color primaryColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Zoom In
        _buildToolButton(
          icon: Icons.add_rounded,
          onTap: () => _zoomCamera(true),
        ),

        const SizedBox(height: 6),

        // Zoom Out
        _buildToolButton(
          icon: Icons.remove_rounded,
          onTap: () => _zoomCamera(false),
        ),

        const SizedBox(height: 12),

        // My GPS Location Button
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _recenterToCurrentGps,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.my_location_rounded,
                  color: primaryColor,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Icon(icon, color: Colors.black87, size: 18),
          ),
        ),
      ),
    );
  }

  ///  Standard Bottom Address Sheet
  Widget _buildAddressBottomSheet(Color primaryColor) {
    final streetTitle = hotelAddressDetails?.street?.isNotEmpty == true
        ? hotelAddressDetails!.street!
        : (hotelAddressDetails?.area?.isNotEmpty == true
            ? hotelAddressDetails!.area!
            : (hotelAddressDetails?.city?.isNotEmpty == true
                ? hotelAddressDetails!.city!
                : 'Selected Location'));

    final detailsSubtitle = [
      if (hotelAddressDetails?.area?.isNotEmpty == true &&
          hotelAddressDetails?.area != streetTitle)
        hotelAddressDetails!.area,
      if (hotelAddressDetails?.city?.isNotEmpty == true)
        hotelAddressDetails!.city,
      if (hotelAddressDetails?.state?.isNotEmpty == true &&
          hotelAddressDetails?.state != hotelAddressDetails?.city)
        hotelAddressDetails!.state,
      if (hotelAddressDetails?.country?.isNotEmpty == true)
        hotelAddressDetails!.country,
    ].whereType<String>().join(', ');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 42,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Header Row (Label + Verification Indicator)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.isJobSeeker
                            ? 'Work & Shift Location'
                            : 'Selected Address',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          fontFamily: 'Libertinus Sans',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Verified Pin',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF047857),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Main Address Display Card
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _isFetchingAddress
                    ? _buildAddressLoadingCard(primaryColor)
                    : _buildAddressContentCard(
                        streetTitle: streetTitle,
                        detailsSubtitle: detailsSubtitle,
                        primaryColor: primaryColor,
                      ),
              ),

              const SizedBox(height: 12),

              // Drag Tip
              Row(
                children: [
                  Icon(
                    Icons.touch_app_outlined,
                    size: 15,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Drag map to fine-tune pinpoint • Tap address to edit postcode',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Primary Confirmation Button
              SizedBox(
                width: double.infinity,
                height: AppSize.buttonHeight,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.radiusSm),
                    ),
                  ),
                  onPressed: (_isFetchingAddress || hotelAddressDetails == null)
                      ? null
                      : () {
                          Navigator.pop(
                            context,
                            hotelAddressDetails!.copyWith(
                              street: _addressController.text.trim().isNotEmpty
                                  ? _addressController.text
                                  : hotelAddressDetails!.street,
                              isUserConfirmed: true,
                            ),
                          );
                        },
                  icon: const Icon(Icons.check_circle_rounded, size: 19),
                  label: Text(
                    widget.isJobSeeker
                        ? 'Confirm Work Location'
                        : 'Confirm Location',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Libertinus Sans',
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shimmer loading state for address card
  Widget _buildAddressLoadingCard(Color primaryColor) {
    return Container(
      key: const ValueKey('loading_address'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: primaryColor,
              backgroundColor: primaryColor.withValues(alpha: 0.18),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Pinpointing address details...',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// Populated address content card with  Postcode pill
  Widget _buildAddressContentCard({
    required String streetTitle,
    required String detailsSubtitle,
    required Color primaryColor,
  }) {
    final postcode = hotelAddressDetails?.postalCode?.trim();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const ValueKey('loaded_address'),
        borderRadius: BorderRadius.circular(16),
        onTap: _openAutocompleteSearch,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200, width: 1.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      streetTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        fontFamily: 'Libertinus Sans',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              if (detailsSubtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  detailsSubtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (postcode != null && postcode.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('📮', style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 4),
                          Text(
                            postcode,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Permission denied view with clear  recovery actions
  Widget _buildPermissionDeniedView(ColorScheme cs) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_off_rounded,
                size: 34,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Location Permission Required',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                fontFamily: 'Libertinus Sans',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Enable GPS location permissions so TOVOZO can pinpoint your exact shift matching radius.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.radiusSm),
                ),
              ),
              onPressed: () async {
                await requestLocationAccess(context);
                _checkPermissionStatus();
              },
              icon: const Icon(Icons.my_location_rounded, size: 18),
              label: const Text(
                'Enable Location Access',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
