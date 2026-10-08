import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_tracking/core/constants/app_size.dart';
import 'package:location_tracking/core/model/full_address.dart';
import 'package:location_tracking/core/utilities/get_address.dart';
import 'package:location_tracking/core/utilities/location_utils.dart';
import 'package:location_tracking/core/widgets/app_country_picker_field.dart';
import 'package:location_tracking/core/widgets/custom_text_form_field.dart';
import 'package:location_tracking/feature/job_seeker/auth/presentation/bloc/auth_job_bloc.dart';
import 'package:location_tracking/feature/job_seeker/location/presentation/page/get_location_from_map_page.dart';
import 'package:location_tracking/feature/job_seeker/profile/data/model/profile_get_job_seeker_model.dart';
import 'package:location_tracking/feature/job_seeker/profile/data/model/profile_update_job_seeker_model.dart';
class EditAddressPage extends StatefulWidget {
  const EditAddressPage({super.key,this.initialProfile});

final ProfileGetJobSeekerModel? initialProfile;
  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _addressLine1Controller;
  late final TextEditingController _addressLine2Controller;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _countryController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;

  LatLng? _currentPosition;
    bool _isGpsLoading = false;



  @override
  void initState() {
    super.initState();
    final p = widget.initialProfile;
    _addressLine1Controller = TextEditingController(text: p?.homeAddress?.toString()??'');
    _addressLine2Controller = TextEditingController();
    _cityController = TextEditingController(text: p?.city?.toString()??'');
    _stateController = TextEditingController(text: p?.state?.toString()??'');
    _postalCodeController = TextEditingController(text: p?.homePostalCode?.toString()??'');
    _countryController = TextEditingController(text: p?.country?.toString()??'');
    _latitudeController = TextEditingController(text: p?.latitude?.toString()??''); 
    _longitudeController = TextEditingController(text: p?.longitude?.toString()??'');   
  }

  @override
  void dispose() {
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }







/// Launch map picker to select an exact pin
  Future<void> _pickOnMap() async {
    HapticFeedback.lightImpact();
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
            _latitudeController.text = address.latitude.toString();
            _longitudeController.text = address.longitude.toString();
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Address & coordinates updated from Map!")));
      }
    } catch (e) {
      debugPrint("Map pick error: $e");
    }
  }



 /// Auto-detect location using device GPS and reverse geocoding
  Future<void> _autoDetectGps() async {
    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();
    setState(() => _isGpsLoading = true);

    try {
      final value = await checkLocationPermission(context, true);
      if (!mounted) return;

      if (value is Position) {
        final pos = LatLng(value.latitude, value.longitude);
        setState(() {
          _currentPosition = pos;
          _latitudeController.text = pos.latitude.toString();
          _longitudeController.text = pos.longitude.toString();
        });

        final FullAddress? fullAddress = await getAddressFromLatLng(pos);

        if (fullAddress != null && mounted) {
          setState(() {
            if ((fullAddress.street ?? '').isNotEmpty) {
              _addressLine1Controller.text =
                  fullAddress.street ?? fullAddress.fullAddress ?? '';
            }
            if ((fullAddress.area ?? '').isNotEmpty) {
              _addressLine2Controller.text = fullAddress.area!;
            }
            if ((fullAddress.city ?? '').isNotEmpty) {
              _cityController.text = fullAddress.city!;
            }
            if ((fullAddress.state ?? '').isNotEmpty) {
              _stateController.text = fullAddress.state!;
            }
            if ((fullAddress.postalCode ?? '').isNotEmpty) {
              _postalCodeController.text =
                  fullAddress.postalCode!.toUpperCase();
            }
            if ((fullAddress.country ?? '').isNotEmpty) {
              _countryController.text = fullAddress.country!;
            }
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("GPS location and address auto-detected successfully!")),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Coordinates captured. Please enter street details below.")),
          );
        }
      } else if (mounted) { 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location permission was denied.")),
        );
      }
    } catch (e) {
      debugPrint("GPS Detection error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not get current location: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGpsLoading = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final hasCoordinates = _currentPosition != null|| (_latitudeController.text.isNotEmpty && _longitudeController.text.isNotEmpty);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Address'),
        centerTitle: true,
      ),
      body: BlocListener<AuthJobBloc, AuthJobState>(
        listenWhen: (previous, current) =>
            current is UpdateProfileJobSeekerSuccessState ||
            current is UpdateProfileJobSeekerFailedState,
        listener: (context, state) {
          if (state is UpdateProfileJobSeekerSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Address updated successfully!")),
            );
            Navigator.pop(context, true);
          } else if (state is UpdateProfileJobSeekerFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(AppSize.p16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            //  CustomAddressQuickActions(
            //   hasCoordinates: hasCoordinates, 
            //   onSearchOnMap: _pickOnMap, 
            //   onAutoDetectGps: _autoDetectGps,
            //   statusMessage: _isGpsLoading? "Detecting your current GPS location...": null,
            //   ),
              AppSize.gapH16,
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
                  AppSize.gapH16,

                  CustomTextFormField(
                    labelText: "Address Line 1",
                    controller: _addressLine1Controller,
                    prefixIcon: const Icon(Icons.home_outlined),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter your address";
                      }
                      return null;
                    },
                  ),
                  AppSize.gapH16,
                  CustomTextFormField(
                    labelText: "Address Line 2 (Optional)",
                    hintText: "e.g. Apartment, suite, unit, locality",
                    controller: _addressLine2Controller,
                    prefixIcon: const Icon(Icons.business_outlined),
                    keyboardType: TextInputType.text,
                  ),
                  AppSize.gapH16,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          labelText: "City / Town",
                          controller: _cityController,
                          prefixIcon: const Icon(Icons.location_city_outlined),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Required";
                            }
                            return null;
                          },
                        ),
                      ),
                      AppSize.gapW16,
                      Expanded(
                        child: CustomTextFormField(
                          labelText: "State (Optional)",
                          controller: _stateController,
                          prefixIcon: const Icon(Icons.map_outlined),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                  AppSize.gapH16,
                  CustomTextFormField(
                    labelText: "Postcode / Postal Code",
                    controller: _postalCodeController,
                    prefixIcon: const Icon(Icons.markunread_mailbox_outlined),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                  AppSize.gapH24,
                  
                  // Address Live Preview Card
                  Container(
                    padding: const EdgeInsets.all(AppSize.p16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.amber.shade200),
                      borderRadius: BorderRadius.circular(AppSize.radiusLg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.remove_red_eye_outlined, size: 16),
                                AppSize.gapW8,
                                const Text("Address Live Preview", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade100,
                                borderRadius: BorderRadius.circular(AppSize.radiusSm),
                              ),
                              child: const Text("12366", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                            ),
                          ],
                        ),
                        AppSize.gapH16,
                        const Text(
                          "123 Main Street, Springfield, Chittagong, Chittagong Division, 12366, Bangladesh",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        AppSize.gapH16,
                        Row(
                          children: [
                            const Icon(Icons.public, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            const Text("Bangladesh", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            const SizedBox(width: 8),
                            const Text("•", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            const SizedBox(width: 8),
                            Icon(Icons.location_on, size: 12, color: Colors.green.shade600),
                            const SizedBox(width: 4),
                            Text("Pin attached", style: TextStyle(color: Colors.green.shade600, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppSize.gapH24,
                  
                  // Latitude / Longitude section
                  Container(
                    padding: const EdgeInsets.all(AppSize.p16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(AppSize.radiusLg),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Fine-tune the exact geographical latitude and longitude coordinates for map accuracy.",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        AppSize.gapH16,
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                labelText: "Latitude",
                                controller: _latitudeController,
                                prefixIcon: const Icon(Icons.my_location),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            AppSize.gapW16,
                            Expanded(
                              child: CustomTextFormField(
                                labelText: "Longitude",
                                controller: _longitudeController,
                                prefixIcon: const Icon(Icons.location_on_outlined),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppSize.gapH24,
                  Padding(
                  padding: const EdgeInsets.all(AppSize.p16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context.read<AuthJobBloc>().add(
                        UpdateProfileJobSeekerEvent(
                          profileUpdateJobSeekerModel: ProfileUpdateJobSeekerModel(
                            address: _addressLine1Controller.text,
                            city: _cityController.text,
                            country: _countryController.text,
                            postalCode: _postalCodeController.text,
                            latitude: _latitudeController.text, 
                            longitude: _longitudeController.text, 
                          ),
                          files: [], 
                        ),
                      );
                      },
                      icon: const Icon(Icons.save, color: Colors.black87),
                      label: const Text("Save Address", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade500,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.radiusLg)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}