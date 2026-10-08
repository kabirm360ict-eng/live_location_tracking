import 'package:flutter/material.dart';
import 'package:location_tracking/core/constants/app_size.dart';
import 'package:location_tracking/core/widgets/app_country_picker_field.dart';
import 'package:location_tracking/feature/job_seeker/auth/presentation/widgets/custom_address_quick_actions.dart';
class EditAddressPage extends StatefulWidget {
  const EditAddressPage({super.key});

  @override
  State<EditAddressPage> createState() => _EditAddressPageState();
}

class _EditAddressPageState extends State<EditAddressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(AppSize.p16),
            child: const Column(
              children: [
            //  CustomAddressQuickActions(
              // hasCoordinates: hasCoordinates, 
              // onSearchOnMap: onSearchOnMap, 
              // onAutoDetectGps: onAutoDetectGps,
              // ),
              
              // AppCountryPickerField(
              //                           label: "Country",
              //                           hint: "Select Country",
              //                           controller: _countryController,
              //                           prefixIcon: Icons.public_rounded,
              //                           autovalidateMode:
              //                               AutovalidateMode.onUserInteraction,
              //                           validator: (value) {
              //                             if (value == null ||
              //                                 value.trim().isEmpty) {
              //                               return "Please select your country";
              //                             }
              //                             return null;
              //                           },
              //                         ),

              
            ]),
          ),
        ),
      ),
    );
  }
}