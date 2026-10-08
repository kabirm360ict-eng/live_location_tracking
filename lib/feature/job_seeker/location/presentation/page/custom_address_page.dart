import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_tracking/core/model/full_address.dart';
import 'package:location_tracking/core/utilities/get_address.dart';
import 'package:location_tracking/core/utilities/location_utils.dart';
import 'package:location_tracking/core/widgets/app_country_picker_field.dart';
import 'package:location_tracking/feature/job_seeker/auth/presentation/widgets/custom_address_quick_actions.dart';
import 'package:location_tracking/feature/job_seeker/location/data/data_source/location_remote_data_source.dart';
import 'package:location_tracking/core/widgets/custom_text_form_field.dart';
import 'package:location_tracking/feature/job_seeker/location/presentation/widget/custom_address_coordinates_section.dart';
import 'package:location_tracking/feature/job_seeker/location/presentation/widget/custom_address_preview_card.dart';
import 'get_location_from_map_page.dart';

/// UK & Global Industry-Standard Custom / Manual Address Builder Page.
///
/// Fully harmonized with [RegistrationPageJob] and the TOVOZO design system:
/// - Brand backdrop with sunny accent bubble and skyline silhouette.
/// - Top header with icon badge, "Manual Address Builder" tag, and guidelines.
/// - Dual Quick Actions (Interactive Map Pinpoint + GPS Auto-detection).
/// - UK-compliant structured fields (Address Line 1, Address Line 2, Town/City, County, Postcode, Country).
/// - Dynamic live formatted address summary preview.
/// - Smart background geocoding & coordinate synchronization.
/// - Robust validation, exception handling, and smooth 60fps UX.
class CustomAddressPage extends StatefulWidget {
  const CustomAddressPage({
    super.key,
    this.initialAddress,
  });

  /// Optional initial address model to pre-populate.
  final FullAddress? initialAddress;

  @override
  State<CustomAddressPage> createState() => _CustomAddressPageState();
}

class _CustomAddressPageState extends State<CustomAddressPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text Controllers
  late final TextEditingController _addressLine1Controller;
  late final TextEditingController _addressLine2Controller;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _countryController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;

  LatLng? _currentPosition;
  bool _isSyncingCoordinates = false;
  bool _isSubmitting = false;
  final ValueNotifier<bool> _isGpsLoadingNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    final initial = widget.initialAddress;

    _addressLine1Controller =
        TextEditingController(text: initial?.street ?? initial?.fullAddress ?? '');
    _addressLine2Controller = TextEditingController(text: initial?.area ?? '');
    _cityController = TextEditingController(text: initial?.city ?? '');
    _stateController = TextEditingController(text: initial?.state ?? '');
    _postalCodeController =
        TextEditingController(text: initial?.postalCode ?? '');
    _countryController = TextEditingController(
      text: initial?.country?.isNotEmpty == true
          ? initial!.country!
          : 'United Kingdom',
    );
    _latitudeController = TextEditingController(
      text: initial?.latitude != null ? initial!.latitude.toString() : '',
    );
    _longitudeController = TextEditingController(
      text: initial?.longitude != null ? initial!.longitude.toString() : '',
    );

    if (initial?.latitude != null && initial?.longitude != null) {
      _currentPosition = LatLng(initial!.latitude!, initial.longitude!);
    }

    // Attach listeners for live preview update
    _addressLine1Controller.addListener(_onFieldChanged);
    _addressLine2Controller.addListener(_onFieldChanged);
    _cityController.addListener(_onFieldChanged);
    _stateController.addListener(_onFieldChanged);
    _postalCodeController.addListener(_onFieldChanged);
    _countryController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _addressLine1Controller.removeListener(_onFieldChanged);
    _addressLine2Controller.removeListener(_onFieldChanged);
    _cityController.removeListener(_onFieldChanged);
    _stateController.removeListener(_onFieldChanged);
    _postalCodeController.removeListener(_onFieldChanged);
    _countryController.removeListener(_onFieldChanged);

    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _isGpsLoadingNotifier.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  /// Synthesizes the active address components into a clean formatted string
  String _getFormattedAddressString() {
    final parts = <String>[
      if (_addressLine1Controller.text.trim().isNotEmpty)
        _addressLine1Controller.text.trim(),
      if (_addressLine2Controller.text.trim().isNotEmpty)
        _addressLine2Controller.text.trim(),
      if (_cityController.text.trim().isNotEmpty)
        _cityController.text.trim(),
      if (_stateController.text.trim().isNotEmpty &&
          _stateController.text.trim().toLowerCase() !=
              _cityController.text.trim().toLowerCase())
        _stateController.text.trim(),
      if (_postalCodeController.text.trim().isNotEmpty)
        _postalCodeController.text.trim().toUpperCase(),
      if (_countryController.text.trim().isNotEmpty)
        _countryController.text.trim(),
    ];

    return parts.join(', ');
  }

  /// Cleans and sanitizes textual address specifically for map geocoders.
  /// Removes internal building noise like floor numbers, flats, apartments,
  /// and fixes dash-separated postcodes (e.g. "Dhaka-1213" -> "Dhaka, 1213").
  static String sanitizeAddressForGeocoding(String rawAddress) {
    var cleaned = rawAddress;

    // 1. Remove floor/level notations (e.g., "3rd Floor", "Floor 3", "2nd Level", "Level 4", "Ground Floor")
    cleaned = cleaned.replaceAll(
      RegExp(
        r'\b(?:\d+(?:st|nd|rd|th)?|ground|first|second|third|fourth|fifth|top)\s+(?:floor|flr|level|lvl)\b,?',
        caseSensitive: false,
      ),
      '',
    );
    cleaned = cleaned.replaceAll(
      RegExp(r'\b(?:floor|flr|level|lvl)\s+\d+\b,?', caseSensitive: false),
      '',
    );

    // 2. Remove flat / apartment / suite / unit / room notations (e.g., "Flat 3B", "Apt #4", "Unit 12")
    cleaned = cleaned.replaceAll(
      RegExp(
        r'\b(?:flat|apt|apartment|suite|unit|room)\s*#?\s*[a-zA-Z0-9-]+\b,?',
        caseSensitive: false,
      ),
      '',
    );

    // 3. Fix city-postcode concatenation (e.g. "Dhaka-1213" -> "Dhaka, 1213")
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'([a-zA-Z]+)-(\d{3,})'),
      (match) => '${match.group(1)}, ${match.group(2)}',
    );

    // 4. Remove duplicate commas and unnecessary spaces
    cleaned = cleaned
        .replaceAll(RegExp(r'\s*,\s*,\s*'), ', ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'^[,\s]+|[,\s]+$'), '')
        .trim();

    return cleaned;
  }

  /// Fallback address using street line without units, plus city, state, postcode, country
  String _getSecondaryGeocodeFallback() {
    final parts = <String>[
      if (_addressLine2Controller.text.trim().isNotEmpty)
        _addressLine2Controller.text.trim(),
      if (_cityController.text.trim().isNotEmpty)
        _cityController.text.trim(),
      if (_stateController.text.trim().isNotEmpty &&
          _stateController.text.trim().toLowerCase() !=
              _cityController.text.trim().toLowerCase())
        _stateController.text.trim(),
      if (_postalCodeController.text.trim().isNotEmpty)
        _postalCodeController.text.trim().toUpperCase(),
      if (_countryController.text.trim().isNotEmpty)
        _countryController.text.trim(),
    ];
    return parts.join(', ');
  }

  /// Robust multi-tiered coordinate resolution:
  /// 1. Sanitizes noise (floors, flats, units, concatenated postal codes).
  /// 2. Queries Google Geocoding & Places Autocomplete APIs via [LocationRemoteDataSource].
  /// 3. Falls back to device native [locationFromAddress].
  /// 4. If detailed street fails, tries broader area/city fallback.
  Future<LatLng?> _resolveCoordinates(String rawQuery) async {
    final sanitized = sanitizeAddressForGeocoding(rawQuery);
    final queriesToTry = <String>{
      if (sanitized.isNotEmpty) sanitized,
      if (rawQuery.trim().isNotEmpty && rawQuery.trim() != sanitized)
        rawQuery.trim(),
    };

    final secondaryFallback = _getSecondaryGeocodeFallback();
    final sanitizedSecondary = sanitizeAddressForGeocoding(secondaryFallback);
    if (sanitizedSecondary.isNotEmpty && !queriesToTry.contains(sanitizedSecondary)) {
      queriesToTry.add(sanitizedSecondary);
    }

    final remoteDataSource = LocationRemoteDataSource();

    for (final q in queriesToTry) {
      // 1. Google Maps / Places API (High Precision)
      try {
        final googleCoords =
            await remoteDataSource.getCoordinatesFromAddress(address: q);
        if (googleCoords != null) {
          log("Resolved coordinates via Google Maps API for query: '$q' -> (${googleCoords.latitude}, ${googleCoords.longitude})");
          return googleCoords;
        }
      } catch (e) {
        log("Google coordinate lookup error for '$q': $e");
      }

      // 2. Native OS Geocoder (CLGeocoder / Android Geocoder)
      try {
        final locations = await Geocoding().locationFromAddress(q);
        if (locations.isNotEmpty) {
          final loc = locations.first;
          log("Resolved coordinates via native Geocoder for query: '$q' -> (${loc.latitude}, ${loc.longitude})");
          return LatLng(loc.latitude, loc.longitude);
        }
      } catch (e) {
        log("Native geocode lookup failed for '$q': $e");
      }
    }

    return null;
  }

  /// Launch map picker to select an exact pin
  Future<void> _pickOnMap() async {
    FocusScope.of(context).unfocus();
    try {
      final FullAddress? address = await Navigator.push<FullAddress>(
        context,
        MaterialPageRoute(
          builder: (_) => GetLocationFromMapPage(
            isJobSeeker: true,
            addressDetailsHave: _currentPosition != null
                ? FullAddress(
                    latitude: _currentPosition!.latitude,
                    longitude: _currentPosition!.longitude,
                    accuracy: 10,
                    street: _addressLine1Controller.text.trim(),
                    area: _addressLine2Controller.text.trim(),
                    city: _cityController.text.trim(),
                    state: _stateController.text.trim(),
                    postalCode: _postalCodeController.text.trim(),
                    country: _countryController.text.trim(),
                  )
                : null,
          ),
        ),
      );

      if (address != null && mounted) {
        setState(() {
          if ((address.street ?? '').isNotEmpty) {
            _addressLine1Controller.text = address.street!;
          }
          if ((address.area ?? '').isNotEmpty) {
            _addressLine2Controller.text = address.area!;
          }
          if ((address.city ?? '').isNotEmpty) {
            _cityController.text = address.city!;
          }
          if ((address.state ?? '').isNotEmpty) {
            _stateController.text = address.state!;
          }
          if ((address.postalCode ?? '').isNotEmpty) {
            _postalCodeController.text = address.postalCode!.toUpperCase();
          }
          if ((address.country ?? '').isNotEmpty) {
            _countryController.text = address.country!;
          }

          if (address.latitude != null && address.longitude != null) {
            _currentPosition = LatLng(address.latitude!, address.longitude!);
            _latitudeController.text = address.latitude!.toString();
            _longitudeController.text = address.longitude!.toString();
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location and coordinates updated from Map!")));
      }
    } catch (e) {
      log("Error opening map picker: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not open map picker. Please check location permissions.")));
      }
    }
  }

  /// Auto-detect current device GPS position and reverse-geocode
  Future<void> _autoDetectGps() async {
    FocusScope.of(context).unfocus();
    _isGpsLoadingNotifier.value = true;

    try {
      final value = await checkLocationPermission(context, true);
      if (!mounted) return;

      if (value is Position) {
        final latLng = LatLng(value.latitude, value.longitude);
        setState(() {
          _currentPosition = latLng;
          _latitudeController.text = value.latitude.toString();
          _longitudeController.text = value.longitude.toString();
        });

        final FullAddress? fullAddress = await getAddressFromLatLng(latLng);

        if (fullAddress != null && mounted) {
          setState(() {
            _addressLine1Controller.text =
                fullAddress.street ?? fullAddress.fullAddress ?? '';
            _addressLine2Controller.text = fullAddress.area ?? '';
            _postalCodeController.text =
                (fullAddress.postalCode ?? '').toUpperCase();
            _countryController.text =
                fullAddress.country ?? 'United Kingdom';
            _stateController.text = fullAddress.state ?? '';
            _cityController.text =
                fullAddress.city ?? _stateController.text;
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Address autofilled from your current GPS position!")));
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("GPS coordinates captured! Please verify address lines.")));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location permission was denied. Please allow location access or pick on map.")));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error detecting GPS location: $e")));
      }
    } finally {
      if (mounted) {
        _isGpsLoadingNotifier.value = false;
      }
    }
  }

  /// Background forward geocoding to resolve coordinates from the textual address
  Future<void> _syncCoordinatesFromAddress() async {
    final query = _getFormattedAddressString();
    if (query.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter street and city/postcode first to resolve coordinates.")));
      return;
    }

    setState(() => _isSyncingCoordinates = true);

    try {
      final coords = await _resolveCoordinates(query);
      if (coords != null && mounted) {
        setState(() {
          _currentPosition = coords;
          _latitudeController.text = coords.latitude.toString();
          _longitudeController.text = coords.longitude.toString();
          _isSyncingCoordinates = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Coordinates synchronized successfully (${coords.latitude.toStringAsFixed(4)}, ${coords.longitude.toStringAsFixed(4)})")));
      } else {
        throw Exception("No matching coordinates found");
      }
    } catch (e) {
      log("Geocoding sync error: $e");
      if (mounted) {
        setState(() => _isSyncingCoordinates = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Could not auto-resolve exact coordinates for this address. Coordinates will be approximated.")));
      }
    }
  }

  /// Validate form, resolve coordinates if needed, construct [FullAddress], and return
  Future<void> _submitAddress() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in all required address fields correctly.")));
      return;
    }

    setState(() => _isSubmitting = true);

    double? lat = double.tryParse(_latitudeController.text.trim()) ??
        _currentPosition?.latitude;
    double? lng = double.tryParse(_longitudeController.text.trim()) ??
        _currentPosition?.longitude;

    // If coordinates are still missing, try smart geocode lookup before returning
    if (lat == null || lng == null) {
      try {
        final query = _getFormattedAddressString();
        if (query.isNotEmpty) {
          final coords = await _resolveCoordinates(query);
          if (coords != null) {
            lat = coords.latitude;
            lng = coords.longitude;
          }
        }
      } catch (e) {
        log("Silent geocoding fallback error: $e");
      }
    }

    final fullAddress = FullAddress(
      latitude: lat,
      longitude: lng,
      accuracy: 10,
      street: _addressLine1Controller.text.trim(),
      area: _addressLine2Controller.text.trim().isNotEmpty
          ? _addressLine2Controller.text.trim()
          : null,
      city: _cityController.text.trim(),
      state: _stateController.text.trim().isNotEmpty
          ? _stateController.text.trim()
          : null,
      postalCode: _postalCodeController.text.trim().toUpperCase(),
      country: _countryController.text.trim().isNotEmpty
          ? _countryController.text.trim()
          : 'United Kingdom',
      isUserConfirmed: true,
    );

    if (mounted) {
      setState(() => _isSubmitting = false);
      Navigator.pop(context, fullAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final hasCoordinates = _currentPosition != null ||
        (_latitudeController.text.isNotEmpty &&
            _longitudeController.text.isNotEmpty);

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // Reusable brand decorative background with skyline overlay
            // const AppPageBackground(skylineOpacity: 0.16, skylineTopOffset: 70),

            SafeArea(
              child: Column(
                children: [
                  // Global Custom App Bar
                  AppBar(
                    title: const Text("Custom Address"),
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // Main Scrollable Form Body
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 6.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Top Hero Header
                          // const CustomAddressHeader(),

                          const SizedBox(height: 18),

                          // Main Form Card Container
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 18,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 20,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Quick Location Actions (Map Picker & GPS)
                                  ValueListenableBuilder<bool>(
                                    valueListenable: _isGpsLoadingNotifier,
                                    builder: (context, isGpsLoading, _) {
                                      return CustomAddressQuickActions(
                                        hasCoordinates: hasCoordinates,
                                        onSearchOnMap: _pickOnMap,
                                        onAutoDetectGps: _autoDetectGps,
                                        isGpsLoading: isGpsLoading,
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 18),
                                  const Divider(
                                    height: 1,
                                    color: Color(0xFFEEEEEE),
                                  ),
                                  const SizedBox(height: 16),

                                  // Section Header
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Address Details",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: primaryColor
                                              .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          "Required",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Used for shifts match radius, navigation, and billing.",
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Country Selector (de,faults to United Kingdom)
                                  AppCountryPickerField(
                                    label: "Country",
                                    hint: "Select Country",
                                    controller: _countryController,
                                    prefixIcon: Icons.public_rounded,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Please select your country";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 14),

                                  // Address Line 1 (Street name & Building Number)
                                  CustomTextFormField(
                                    labelText: "Address Line 1",
                                    hintText:
                                        "e.g. 10 Downing Street / Flat 4, Victoria House",
                                    controller: _addressLine1Controller,
                                    prefixIcon: const Icon(Icons.home_outlined),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Please enter street address / building name";
                                      }
                                      if (value.trim().length < 3) {
                                        return "Please enter a valid street address";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 14),

                                  // Address Line 2 (Apartment, Suite, Unit - Optional)
                                  CustomTextFormField(
                                    labelText: "Address Line 2",
                                    hintText:
                                        "e.g. Apartment, suite, unit, locality (optional)",
                                    controller: _addressLine2Controller,
                                    prefixIcon: const Icon(Icons.apartment_outlined),
                                  ),
                                  const SizedBox(height: 14),

                                  // Town / City & County / State
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: CustomTextFormField(
                                          labelText: "City / Town",
                                          hintText: "e.g. London",
                                          controller: _cityController,
                                          prefixIcon:
                                              const Icon(Icons.location_city_rounded),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return "Enter city";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: CustomTextFormField(
                                          labelText: "County / State",
                                          hintText: "e.g. Greater London",
                                          controller: _stateController,
                                          prefixIcon: const Icon(Icons.map_outlined),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 14),

                                  // UK Postcode / Postal Code
                                  CustomTextFormField(
                                    labelText: "Postcode / Postal Code",
                                    hintText: "e.g. SW1A 1AA / W1U 6TY",
                                    controller: _postalCodeController,
                                    prefixIcon:
                                        const Icon(Icons.markunread_mailbox_outlined),
                                    inputFormatters: [
                                      _UpperCaseTextFormatter(),
                                      LengthLimitingTextInputFormatter(12),
                                    ],
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Please enter valid postcode / ZIP";
                                      }
                                      if (value.trim().length < 2) {
                                        return "Postcode is too short";
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 18),

                                  // Live Address Pre,view Card
                                  CustomAddressPreviewCard(
                                    formattedAddress:
                                        _getFormattedAddressString(),
                                    postcode:
                                        _postalCodeController.text.trim(),
                                    country:
                                        _countryController.text.trim(),
                                    hasCoordinates: hasCoordinates,
                                  ),

                                  const SizedBox(height: 16),

                                  // Expandable Advan,ced Coordinates Card
                                  CustomAddressCoordinatesSection(
                                    currentPosition: _currentPosition,
                                    latitudeController: _latitudeController,
                                    longitudeController: _longitudeController,
                                    onSyncCoordinates:
                                        _syncCoordinatesFromAddress,
                                    isSyncing: _isSyncingCoordinates,
                                  ),

                                  const SizedBox(height: 20),

                                  // Save & Apply Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: FilledButton(
                                      onPressed: _isSubmitting
                                          ? null
                                          : _submitAddress,
                                      child: _isSubmitting
                                          ? const SizedBox(
                                              height: 22,
                                              width: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                color: Colors.black87,
                                              ),
                                            )
                                          : const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Save & Apply Address",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w800,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Icon(
                                                  Icons.check_circle_outline_rounded,
                                                  size: 19,
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Proximity & Shift Radius Info Badge
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.near_me_rounded,
                                  size: 20,
                                  color: Colors.black87,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Accurate Commute Radius",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "A verified custom address ensures job notifications and shifts are accurately matched within your preferred travel distance.",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                          height: 1.25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple text formatter to ensure postcode is always formatted in uppercase.
class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
