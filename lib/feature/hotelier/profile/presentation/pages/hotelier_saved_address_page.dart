import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_tracking/app/route/app_routes.dart';
import 'package:location_tracking/core/constants/app_size.dart';
import 'package:location_tracking/feature/hotelier/auth/presentation/bloc/hotelier_auth_bloc.dart';
import '../../data/model/profile_response_model_hiring.dart';

class HotelierSavedAddressPage extends StatefulWidget {
  const HotelierSavedAddressPage({super.key});

  @override
  State<HotelierSavedAddressPage> createState() =>
      _HotelierSavedAddressPageState();
}

class _HotelierSavedAddressPageState extends State<HotelierSavedAddressPage> {
  @override
  void initState() {
    super.initState();
    context.read<HotelierAuthBloc>().add(GetProfileHotelierEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Saved Address',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final state = context.read<HotelierAuthBloc>().state;
              ProfileResponseModelHiring? currentProfile;
              if (state is GetProfileHotelierSuccessState) {
                currentProfile = state.profile;
              }
              final value = await Navigator.pushNamed(
                context,
                AppRoutes.hotelierEditAddress,
                arguments: currentProfile,
              );
              if (!context.mounted) return;
              if (value == true) {
                context.read<HotelierAuthBloc>().add(
                      GetProfileHotelierEvent(isRefresh: true),
                    );
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<HotelierAuthBloc, HotelierAuthState>(
        buildWhen: (previous, current) =>
            current is GetProfileHotelierLoadingState ||
            current is GetProfileHotelierSuccessState ||
            current is GetProfileHotelierFailedState,
        builder: (context, state) {
          if (state is GetProfileHotelierLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetProfileHotelierFailedState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                  AppSize.gapH16,
                  ElevatedButton(
                    onPressed: () {
                      context.read<HotelierAuthBloc>().add(
                            GetProfileHotelierEvent(isRefresh: true),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          ProfileResponseModelHiring? profile;
          if (state is GetProfileHotelierSuccessState) {
            profile = state.profile;
          }

          final orgName = profile?.organizationName?.toString().trim() ??
              profile?.name?.toString().trim() ??
              'Hotelier Venue';
          final streetAddress =
              profile?.address?.toString().trim() ?? 'No address registered';
          final postalCode = profile?.postalCode?.toString().trim() ?? 'N/A';
          final latitude =
              profile?.latitude?.toString().trim() ?? 'Not Available';
          final longitude =
              profile?.longitude?.toString().trim() ?? 'Not Available';

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSize.p16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Main Address Card
                        Container(
                          padding: const EdgeInsets.all(AppSize.p16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(AppSize.radiusLg),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(AppSize.p16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A1C29),
                                      borderRadius:
                                          BorderRadius.circular(AppSize.radiusMd),
                                    ),
                                    child: const Icon(
                                      Icons.hotel,
                                      color: Colors.white,
                                    ),
                                  ),
                                  AppSize.gapW8,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          orgName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const Text(
                                          "Primary Venue Address",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius:
                                          BorderRadius.circular(AppSize.radiusSm),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green.shade600,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          "VERIFIED",
                                          style: TextStyle(
                                            color: Colors.green.shade600,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Divider(height: 1),
                              ),

                              // Street Address
                              const Text(
                                "VENUE / STREET ADDRESS",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                streetAddress,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              AppSize.gapH16,

                              // Postcode & Status
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoBox(
                                      "POSTCODE",
                                      postalCode,
                                    ),
                                  ),
                                  AppSize.gapW8,
                                  Expanded(
                                    child: _buildInfoBox(
                                      "ORGANIZATION STATUS",
                                      profile?.organizationStatus?.toString() ??
                                          "Active",
                                    ),
                                  ),
                                ],
                              ),
                              AppSize.gapH16,

                              // Copy Button
                              Align(
                                alignment: Alignment.centerLeft,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(text: streetAddress),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Address copied to clipboard!',
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.copy,
                                    size: 16,
                                    color: Colors.black54,
                                  ),
                                  label: const Text(
                                    "Copy Full Address",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side:
                                        BorderSide(color: Colors.grey.shade300),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppSize.radiusMd,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSize.gapH16,

                        // GPS Verified Location Card
                        Container(
                          padding: const EdgeInsets.all(AppSize.p16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(AppSize.radiusLg),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.tealAccent.shade100
                                      .withValues(alpha: 0.5),
                                  borderRadius:
                                      BorderRadius.circular(AppSize.radiusMd),
                                ),
                                child: Icon(
                                  Icons.my_location,
                                  color: Colors.teal.shade700,
                                ),
                              ),
                              AppSize.gapW8,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "GPS Verified Venue Coordinates",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Coordinates: $latitude, $longitude",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius:
                                      BorderRadius.circular(AppSize.radiusSm),
                                ),
                                child: const Text(
                                  "PINNED",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        AppSize.gapH16,

                        // Shift Matching Radius Card
                        Container(
                          padding: const EdgeInsets.all(AppSize.p16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F6F9),
                            borderRadius:
                                BorderRadius.circular(AppSize.radiusLg),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.near_me,
                                  color: Colors.black87,
                                  size: 16,
                                ),
                              ),
                              AppSize.gapW8,
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Job Posting & Worker Location Matching",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Tovozo uses your registered venue address to calculate worker proximity and match qualified candidates nearby.",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Button
                Padding(
                  padding: const EdgeInsets.all(AppSize.p16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final value = await Navigator.pushNamed(
                          context,
                          AppRoutes.hotelierEditAddress,
                          arguments: profile,
                        );
                        if (!context.mounted) return;
                        if (value == true) {
                          context.read<HotelierAuthBloc>().add(
                                GetProfileHotelierEvent(isRefresh: true),
                              );
                        }
                      },
                      icon: const Icon(
                        Icons.edit_location_alt,
                        color: Colors.black87,
                      ),
                      label: const Text(
                        "Edit Venue Address",
                        style: TextStyle(
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.radiusMd),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
