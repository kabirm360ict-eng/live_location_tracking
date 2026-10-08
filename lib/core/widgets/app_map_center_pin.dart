import 'package:flutter/material.dart';

/// A reusable, animated center pin for interactive map location pickers.
///
/// Features:
/// - Floating callout tooltip with current status or place name.
/// - Fluid spring-bounce elevation when dragging the map.
/// - Downward needle pointing to the exact geographic anchor.
/// - Dynamic ground shadow and pulsing coordinate crosshair reticle.
class AppMapCenterPin extends StatelessWidget {
  const AppMapCenterPin({
    super.key,
    required this.isMoving,
    required this.bounceAnimation,
    this.tooltipText,
    this.primaryColor,
  });

  /// Whether the user is currently panning or zooming the map.
  final bool isMoving;

  /// Bounce animation controller value driving vertical lift.
  final Animation<double> bounceAnimation;

  /// Optional text to show in the callout pill above the pin.
  final String? tooltipText;

  /// Primary accent color (defaults to [ColorScheme.primary]).
  final Color? primaryColor;

  @override
  Widget build(BuildContext context) {
    final color = primaryColor ?? Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // ── GROUND TARGET RETICLE & SHADOW ──
          Positioned(
            bottom: -2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pulsing ground crosshair ring when dragging
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isMoving ? 1.0 : 0.0,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 2),
                      color: color.withValues(alpha: 0.15),
                    ),
                    child: Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                // Ground shadow beneath the needle tip
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isMoving ? 10 : 20,
                  height: isMoving ? 4 : 8,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: isMoving ? 0.2 : 0.4),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ],
            ),
          ),

          // ── FLOATING ANIMATED PIN WITH CALLOUT ──
          AnimatedBuilder(
            animation: bounceAnimation,
            builder: (context, child) {
              return Transform.translate(
                // Lift the pin up so needle points right at center
                offset: Offset(0, bounceAnimation.value - 34),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Callout Tooltip Pill
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isMoving ? color : Colors.black87,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.18),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isMoving
                                ? Icons.open_with_rounded
                                : Icons.place_rounded,
                            size: 13,
                            color: isMoving ? Colors.black87 : Colors.white,
                          ),
                          const SizedBox(width: 5),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 180),
                            child: Text(
                              isMoving
                                  ? 'Move to pinpoint'
                                  : (tooltipText != null &&
                                          tooltipText!.isNotEmpty
                                      ? tooltipText!
                                      : 'Selected location'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isMoving ? Colors.black87 : Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Pin Head (Golden circular badge with icon & high contrast)
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.45),
                            blurRadius: 14,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.black87,
                          size: 26,
                        ),
                      ),
                    ),

                    // Downward needle stem
                    CustomPaint(
                      size: const Size(10, 8),
                      painter: _PinStemPainter(color: color),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PinStemPainter extends CustomPainter {
  _PinStemPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PinStemPainter oldDelegate) =>
      oldDelegate.color != color;
}
