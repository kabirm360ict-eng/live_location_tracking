import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_tracking/app/route/app_routes.dart';
import 'package:location_tracking/core/constants/app_size.dart';
import 'package:location_tracking/feature/job_seeker/auth/presentation/bloc/auth_job_bloc.dart';

import '../../data/model/profile_get_job_seeker_model.dart';

class SavedAddressPage extends StatefulWidget {
  const SavedAddressPage({super.key});

  @override
  State<SavedAddressPage> createState() => _SavedAddressPageState();
}

class _SavedAddressPageState extends State<SavedAddressPage> {

    @override
  void initState() {
    super.initState();
    context.read<AuthJobBloc>().add(GetProfileJobSeekerEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Saved Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final state = context.read<AuthJobBloc>().state;
              ProfileGetJobSeekerModel? currentProfile;
              if (state is GetProfileJobSeekerSuccessState) {
                currentProfile = state.profileGetJobSeekerModel;
              }
              Navigator.pushNamed(context, AppRoutes.editAddressPage, arguments: currentProfile).then((value) {
                if (value == true) {
                  context.read<AuthJobBloc>().add(GetProfileJobSeekerEvent());
                }
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthJobBloc, AuthJobState>(
        buildWhen: (previous, current) =>
            current is GetProfileJobSeekerLoadingState ||
            current is GetProfileJobSeekerSuccessState ||
            current is GetProfileJobSeekerFailedState,
        builder: (context, state) {
          if (state is GetProfileJobSeekerLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          ProfileGetJobSeekerModel? profile;
          if(state is GetProfileJobSeekerSuccessState){
            profile = state.profileGetJobSeekerModel;
          }
          
          final streetAddress = profile?.homeAddress?.toString().trim() ?? '123 Main Street, Springfield';
          final city = profile?.city?.toString().trim() ?? 'Chittagong';
          final country = profile?.country?.toString().trim() ?? 'Bangladesh';
          final postalCode = profile?.homePostalCode?.toString().trim() ?? '12366';
          final latitude = profile?.latitude?.toString().trim() ?? '40.730610';
          final longitude = profile?.longitude?.toString().trim() ?? '-73.935242';

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
                            borderRadius: BorderRadius.circular(AppSize.radiusLg),
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
                                      borderRadius: BorderRadius.circular(AppSize.radiusMd),
                                    ),
                                    child: const Icon(Icons.home, color: Colors.white),
                                  ),
                                  AppSize.gapW8,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Registered Residence",
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        Text(
                                          "Primary Home Address",
                                          style: TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(AppSize.radiusSm),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.green.shade600, size: 14),
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
                              Text("STREET ADDRESS", style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(streetAddress, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                              AppSize.gapH16,
                              
                              // City & Postcode
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildInfoBox("TOWN / CITY", city),
                                  ),
                                  AppSize.gapW8,
                                  Expanded(
                                    child: _buildInfoBox("POSTCODE", postalCode),
                                  ),
                                ],
                              ),
                              AppSize.gapH16,
                              
                              // Country
                              _buildInfoBox("COUNTRY", country),
                              AppSize.gapH16,
                              
                              // Copy Button
                              Align(
                                alignment: Alignment.centerLeft,
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.copy, size: 16, color: Colors.black54),
                                  label: const Text("Copy Full Address", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.grey.shade300),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.radiusMd)),
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                            borderRadius: BorderRadius.circular(AppSize.radiusLg),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.tealAccent.shade100.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(AppSize.radiusMd),
                                ),
                                child: Icon(Icons.my_location, color: Colors.teal.shade700),
                              ),
                              AppSize.gapW8,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("GPS Verified Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    const SizedBox(height: 2),
                                    Text("Coordinates: $latitude, $longitude", style: TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'monospace')),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(AppSize.radiusSm),
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
                        
                        // Shift Matching Card
                        Container(
                          padding: const EdgeInsets.all(AppSize.p16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F6F9),
                            borderRadius: BorderRadius.circular(AppSize.radiusLg),
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
                                child: const Icon(Icons.near_me, color: Colors.black87, size: 16),
                              ),
                              AppSize.gapW8,
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Shift Matching & Commute Radius", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
                                    SizedBox(height: 4),
                                    Text(
                                      "Tovozo uses your registered home address to automatically calculate commute times and display high-paying shifts within your preferred travel distance.",
                                      style: TextStyle(color: Colors.black54, fontSize: 12, height: 1.4),
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
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.editAddressPage, arguments: profile).then((value) {
                          if (value == true) {
                            context.read<AuthJobBloc>().add(GetProfileJobSeekerEvent());
                          }
                        });
                      },
                      icon: const Icon(Icons.edit_location_alt, color: Colors.black87),
                      label: const Text("Edit Registered Address", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
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
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}
