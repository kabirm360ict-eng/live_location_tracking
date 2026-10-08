import 'package:flutter/material.dart';

/// Live preview card that displays the synthesized address representation
/// as the user enters or edits their manual address fields.
class CustomAddressPreviewCard extends StatelessWidget {
  const CustomAddressPreviewCard({
    super.key,
    required this.formattedAddress,
    required this.postcode,
    required this.country,
    required this.hasCoordinates,
  });

  final String formattedAddress;
  final String postcode;
  final String country;
  final bool hasCoordinates;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isNotEmpty = formattedAddress.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isNotEmpty
              ? primaryColor.withValues(alpha: 0.35)
              : Colors.grey.shade200,
          width: 1.1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.remove_red_eye_outlined,
                    size: 15,
                    color: Colors.grey.shade700,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "Address Live Preview",
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              if (postcode.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.4),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    postcode.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          Text(
            isNotEmpty
                ? formattedAddress
                : "Your formatted address preview will appear here as you type...",
            style: TextStyle(
              fontSize: 13,
              fontWeight: isNotEmpty ? FontWeight.w600 : FontWeight.w400,
              color: isNotEmpty ? Colors.black87 : Colors.grey.shade400,
              height: 1.35,
            ),
          ),
          if (country.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.public_rounded,
                  size: 13,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  country,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (hasCoordinates) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.pin_drop_rounded,
                    size: 13,
                    color: Color(0xFF10B981),
                  ),
                  const SizedBox(width: 3),
                  const Text(
                    "Pin attached",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
