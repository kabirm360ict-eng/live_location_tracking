import 'package:flutter/material.dart';
import 'package:location_tracking/core/constants/app_size.dart';

/// Clean state presentation for empty search, no results, or search errors.
class LocationSearchEmptyView extends StatelessWidget {
  const LocationSearchEmptyView({
    super.key,
    required this.query,
    required this.onPickOnMap,
    required this.onCustomAddress,
    this.errorMessage,
    this.onRetry,
  });

  final String query;
  final VoidCallback onPickOnMap;
  final VoidCallback onCustomAddress;
  final String? errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final isError = errorMessage != null && errorMessage!.isNotEmpty;
    final isInitial = query.trim().isEmpty && !isError;

    final IconData icon = isError
        ? Icons.error_outline_rounded
        : (isInitial
            ? Icons.search_rounded
            : Icons.location_off_rounded);

    final String title = isError
        ? 'Could not load places'
        : (isInitial
            ? 'Search for an address or postcode'
            : 'No matching places found');

    final String subtitle = isError
        ? (errorMessage!)
        : (isInitial
            ? 'Enter your street name, landmark, town, city, or postcode to find your exact work location.'
            : 'We could not find any locations matching "$query". Try checking the spelling or use the options below.');

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon Badge
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isError
                    ? Colors.red.withValues(alpha: 0.1)
                    : primaryColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isError ? Colors.red : primaryColor,
                size: 30,
              ),
            ),

            const SizedBox(height: 18),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                fontFamily: 'Libertinus Sans',
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions / Retry
            if (isError && onRetry != null)
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusSm),
                  ),
                ),
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text(
                  'Try Again',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pick on Map Option
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: onPickOnMap,
                    icon: Icon(Icons.map_outlined, size: 16, color: primaryColor),
                    label: const Text(
                      'Pick on Map',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Custom Address Option
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: onCustomAddress,
                    icon: const Icon(Icons.edit_note_rounded, size: 16),
                    label: const Text(
                      'Custom Address',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
