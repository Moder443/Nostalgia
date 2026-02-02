import 'package:flutter/material.dart';

/// A widget that renders a film grain noise overlay
/// for nostalgic visual effect
class GrainOverlay extends StatelessWidget {
  final double opacity;

  const GrainOverlay({
    super.key,
    this.opacity = 0.05,
  });

  @override
  Widget build(BuildContext context) {
    // Simplified grain effect - just a subtle gradient overlay
    // to avoid performance issues with CustomPainter
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: opacity * 0.5),
            ],
          ),
        ),
      ),
    );
  }
}
