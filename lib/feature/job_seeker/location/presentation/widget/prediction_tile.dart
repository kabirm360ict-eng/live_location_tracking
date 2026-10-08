import 'package:flutter/material.dart';
import 'package:location_tracking/feature/job_seeker/location/data/model/prediction_list_response_model.dart';

/// A sleek, high-performance tile displaying an address prediction.
///
/// Automatically splits the full description into:
/// - [primaryText]: The main street or building name (bolded).
/// - [secondaryText]: The district, city, and country subtitle.
class PredictionTile extends StatelessWidget {
  const PredictionTile({
    super.key,
    required this.prediction,
    required this.onTap,
    this.isLoading = false,
  });

  final PredictionListResponseModel prediction;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final description = (prediction.description ?? '').trim();

    // Parse primary (place / street) and secondary (city / region)
    String primaryText = description;
    String secondaryText = '';

    final commaIndex = description.indexOf(',');
    if (commaIndex != -1) {
      primaryText = description.substring(0, commaIndex).trim();
      secondaryText = description.substring(commaIndex + 1).trim();
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        splashColor: primaryColor.withValues(alpha: 0.12),
        highlightColor: primaryColor.withValues(alpha: 0.06),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Leading Location Badge
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.25),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.location_on_rounded,
                    color: primaryColor,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Address Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      primaryText.isNotEmpty ? primaryText : 'Unknown Location',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        fontFamily: 'Libertinus Sans',
                        letterSpacing: 0.2,
                      ),
                    ),
                    if (secondaryText.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        secondaryText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Trailing Indicator or Loading Spinner
              if (isLoading)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: primaryColor,
                  ),
                )
              else
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
