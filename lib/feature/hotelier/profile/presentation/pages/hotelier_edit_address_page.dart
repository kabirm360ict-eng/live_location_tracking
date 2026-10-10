import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_tracking/core/constants/app_size.dart';
import 'package:location_tracking/core/widgets/app_country_picker_field.dart';
import 'package:location_tracking/core/widgets/custom_text_form_field.dart';
import 'package:location_tracking/feature/hotelier/auth/presentation/bloc/hotelier_auth_bloc.dart';
import '../../data/model/profile_response_model_hiring.dart';
import '../../data/model/profile_update_request_model_hiring.dart';

class HotelierEditAddressPage extends StatefulWidget {
  final ProfileResponseModelHiring? initialProfile;

  const HotelierEditAddressPage({super.key, this.initialProfile});

  @override
  State<HotelierEditAddressPage> createState() =>
      _HotelierEditAddressPageState();
}

class _HotelierEditAddressPageState extends State<HotelierEditAddressPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _organizationNameController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _countryController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;

  @override
  void initState() {
    super.initState();
    final p = widget.initialProfile;
    _organizationNameController = TextEditingController(
      text: p?.organizationName?.toString() ?? '',
    );
    _addressController = TextEditingController(
      text: p?.address?.toString() ?? '',
    );
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _postalCodeController = TextEditingController(
      text: p?.postalCode?.toString() ?? '',
    );
    _countryController = TextEditingController();
    _latitudeController = TextEditingController(
      text: p?.latitude?.toString() ?? '',
    );
    _longitudeController = TextEditingController(
      text: p?.longitude?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _organizationNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      context.read<HotelierAuthBloc>().add(
            UpdateProfileHotelierEvent(
              payload: ProfileUpdateRequestModelHiring(
                organizationName: _organizationNameController.text.trim(),
                organizationAddressAddress: _addressController.text.trim(),
                organizationAddressPostalCode:
                    _postalCodeController.text.trim(),
                organizationAddressLatitude:
                    _latitudeController.text.trim(),
                organizationAddressLongitude:
                    _longitudeController.text.trim(),
                country: _countryController.text.trim(),
                state: _stateController.text.trim(),
                city: _cityController.text.trim(),
                is2FaOn: widget.initialProfile?.is2FaOn,
              ),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Venue Address'),
        centerTitle: true,
      ),
      body: BlocConsumer<HotelierAuthBloc, HotelierAuthState>(
        listenWhen: (previous, current) =>
            current is UpdateProfileHotelierSuccessState ||
            current is UpdateProfileHotelierFailedState,
        listener: (context, state) {
          if (state is UpdateProfileHotelierSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Venue address updated successfully!"),
              ),
            );
            Navigator.pop(context, true);
          } else if (state is UpdateProfileHotelierFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is UpdateProfileHotelierLoadingState;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSize.p16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCountryPickerField(
                      label: "Country",
                      hint: "Select Country",
                      controller: _countryController,
                      prefixIcon: Icons.public_rounded,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    AppSize.gapH16,
                    CustomTextFormField(
                      labelText: "Organization / Venue Name",
                      hintText: "Enter organization name",
                      controller: _organizationNameController,
                      prefixIcon: const Icon(Icons.business_outlined),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter organization name";
                        }
                        return null;
                      },
                    ),
                    AppSize.gapH16,
                    CustomTextFormField(
                      labelText: "Venue / Street Address",
                      hintText: "e.g. 123 Main Street, Suite 100",
                      controller: _addressController,
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter address";
                        }
                        return null;
                      },
                    ),
                    AppSize.gapH16,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            labelText: "City / Town",
                            hintText: "e.g. Sylhet",
                            controller: _cityController,
                            prefixIcon:
                                const Icon(Icons.location_city_outlined),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        AppSize.gapW16,
                        Expanded(
                          child: CustomTextFormField(
                            labelText: "State / Division",
                            hintText: "e.g. Sylhet Division",
                            controller: _stateController,
                            prefixIcon: const Icon(Icons.map_outlined),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ],
                    ),
                    AppSize.gapH16,
                    CustomTextFormField(
                      labelText: "Postcode",
                      hintText: "e.g. 1001",
                      controller: _postalCodeController,
                      prefixIcon: const Icon(Icons.markunread_mailbox_outlined),
                      keyboardType: TextInputType.text,
                    ),
                    AppSize.gapH24,

                    // Coordinates Section
                    Container(
                      padding: const EdgeInsets.all(AppSize.p16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius:
                            BorderRadius.circular(AppSize.radiusLg),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Geographical Coordinates (Optional)",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Fine-tune exact latitude and longitude for map accuracy.",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          AppSize.gapH16,
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  labelText: "Latitude",
                                  hintText: "e.g. 24.904781",
                                  controller: _latitudeController,
                                  prefixIcon: const Icon(Icons.my_location),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              AppSize.gapW16,
                              Expanded(
                                child: CustomTextFormField(
                                  labelText: "Longitude",
                                  hintText: "e.g. 91.860008",
                                  controller: _longitudeController,
                                  prefixIcon: const Icon(Icons.location_on),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    AppSize.gapH32,

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _saveAddress,
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black87,
                                ),
                              )
                            : const Icon(Icons.save, color: Colors.black87),
                        label: Text(
                          isLoading ? "Saving..." : "Save Address",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade500,
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppSize.radiusLg),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
