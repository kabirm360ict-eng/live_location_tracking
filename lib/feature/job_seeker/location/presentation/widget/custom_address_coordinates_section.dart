import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_tracking/core/widgets/custom_text_form_field.dart';

/// Clean and expandable coordinates management section.
/// Provides auto-sync status, geocoding triggers, and optional advanced manual overrides.
class CustomAddressCoordinatesSection extends StatefulWidget {
  const CustomAddressCoordinatesSection({
    super.key,
    required this.currentPosition,
    required this.latitudeController,
    required this.longitudeController,
    required this.onSyncCoordinates,
    required this.isSyncing,
    this.isRequired = false,
  });

  final LatLng? currentPosition;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final Future<void> Function() onSyncCoordinates;
  final bool isSyncing;
  final bool isRequired;

  @override
  State<CustomAddressCoordinatesSection> createState() =>
      _CustomAddressCoordinatesSectionState();
}

class _CustomAddressCoordinatesSectionState
    extends State<CustomAddressCoordinatesSection> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Fine-tune the exact geographical latitude and longitude coordinates for map accuracy.",
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          labelText: "Latitude",
                          hintText: "e.g. 51.5074",
                          controller: widget.latitudeController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          prefixIcon: const Icon(Icons.my_location_rounded),
                          validator: (value) {
                            if (widget.isRequired && (value == null || value.trim().isEmpty)) {
                              return 'Please enter latitude';
                            }
                            if (value != null && value.trim().isNotEmpty) {
                              if (double.tryParse(value.trim()) == null) {
                                return 'Invalid latitude';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextFormField(
                          labelText: "Longitude",
                          hintText: "e.g. -0.1278",
                          controller: widget.longitudeController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          prefixIcon: const Icon(Icons.location_on_outlined),
                          validator: (value) {
                            if (widget.isRequired && (value == null || value.trim().isEmpty)) {
                              return 'Please enter longitude';
                            }
                            if (value != null && value.trim().isNotEmpty) {
                              if (double.tryParse(value.trim()) == null) {
                                return 'Invalid longitude';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: OutlinedButton.icon(
                      onPressed: widget.isSyncing
                          ? null
                          : widget.onSyncCoordinates,
                      icon: widget.isSyncing
                          ? SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: primaryColor,
                              ),
                            )
                          : const Icon(Icons.sync_rounded, size: 16),
                      label: Text(
                        widget.isSyncing
                            ? "Resolving Coordinates..."
                            : "Sync Coordinates with Address",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
