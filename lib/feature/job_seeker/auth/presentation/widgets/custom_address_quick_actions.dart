import 'package:flutter/material.dart';
class CustomAddressQuickActions extends StatelessWidget {
  const CustomAddressQuickActions({
    super.key,
    required this.hasCoordinates,
    required this.onSearchOnMap,
    required this.onAutoDetectGps,
    this.statusMessage,
    this.isGpsLoading = false,
  });

  final bool hasCoordinates;
  final VoidCallback onSearchOnMap;
  final VoidCallback onAutoDetectGps;
  final String? statusMessage;
  final bool isGpsLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.map,
                label: "Pick on Map",
                subtitle: "Set pin visually",
                onPressed: onSearchOnMap,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.my_location_rounded,
                label: "Auto-detect",
                subtitle: "Device GPS",
                onPressed: onAutoDetectGps,
                isLoading: isGpsLoading,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Live location capture status banner
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: hasCoordinates
                ? primaryColor.withValues(alpha: 0.1)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hasCoordinates
                  ? primaryColor.withValues(alpha: 0.4)
                  : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                hasCoordinates
                    ? Icons.check_circle_rounded
                    : Icons.info_outline_rounded,
                size: 16,
                color: hasCoordinates ? Colors.black87 : Colors.grey.shade700,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  statusMessage ??
                      (hasCoordinates
                          ? "GPS coordinates attached! You can verify or edit details below."
                          : "Use Map / GPS to autofill or enter fields manually below."),
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight:
                        hasCoordinates ? FontWeight.w700 : FontWeight.w500,
                    color:
                        hasCoordinates ? Colors.black87 : Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onPressed,
    this.isLoading = false,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black87,
                        ),
                      )
                    : Icon(icon, size: 18, color: Colors.black87),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
