import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VillageMapWidget extends StatefulWidget {
  final Function(String house, String issue)? onMarkerTap;
  const VillageMapWidget({super.key, this.onMarkerTap});

  @override
  State<VillageMapWidget> createState() => _VillageMapWidgetState();
}

class _VillageMapWidgetState extends State<VillageMapWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Real Village Map Asset
              Positioned.fill(
                child: Image.asset(
                  'assets/village_map.jpg',
                  fit: BoxFit.cover,
                  // Removed darkening filters to restore original map clarity
                ),
              ),

              // Tech Grid Overlay
              Positioned.fill(
                child: IgnorePointer(
                  child: Opacity(
                    opacity: 0.08,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: GridPainter(),
                      ),
                    ),
                  ),
                ),
              ),

              // Animated Scan Line
              Positioned.fill(
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _scanController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: ScanLinePainter(
                          progress: _scanController.value,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // HUD Corner Brackets
              Positioned.fill(
                child: CustomPaint(
                  painter: HudCornerPainter(),
                ),
              ),

              // Tech Markers / Repair Requests
              Positioned(
                top: constraints.maxHeight * 0.22,
                left: constraints.maxWidth * 0.22,
                child: _buildMarkerWidget(
                  icon: Icons.water_drop,
                  color: const Color(0xFFFF9900), // Bright Orange
                  house: 'B12',
                  issue: 'Leak Pipe',
                ),
              ),
              Positioned(
                top: constraints.maxHeight * 0.55,
                left: constraints.maxWidth * 0.45,
                child: _buildMarkerWidget(
                  icon: Icons.electric_bolt,
                  color: const Color(0xFFFF3333), // Vivid Red
                  house: 'A05',
                  issue: 'Power Outage',
                ),
              ),
              Positioned(
                top: constraints.maxHeight * 0.35,
                left: constraints.maxWidth * 0.65,
                child: _buildMarkerWidget(
                  icon: Icons.build,
                  color: const Color(0xFFFFD700),
                  house: 'C08',
                  issue: 'Broken Faucet',
                ),
              ),
              Positioned(
                top: constraints.maxHeight * 0.70,
                left: constraints.maxWidth * 0.15,
                child: _buildMarkerWidget(
                  icon: Icons.roofing,
                  color: const Color(0xFF00BFFF),
                  house: 'D03',
                  issue: 'Roof Leak',
                ),
              ),
              Positioned(
                top: constraints.maxHeight * 0.40,
                left: constraints.maxWidth * 0.78,
                child: _buildMarkerWidget(
                  icon: Icons.ac_unit,
                  color: const Color(0xFF00FFCC), // Neon Cyan
                  house: 'E11',
                  issue: 'AC Failure',
                ),
              ),

              // Bottom vignette
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 120,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF0A0A0A).withOpacity(0.4), // Reduced from 0.95
                      ],
                    ),
                  ),
                ),
              ),

              // Top vignette
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 80,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF0A0A0A).withOpacity(0.3), // Reduced from 0.7
                      ],
                    ),
                  ),
                ),
              ),

              // Redundant header removed - now managed by legal_dashboard_screen.dart

              // Bottom status bar overlay
              Positioned(
                bottom: 14,
                left: 28,
                right: 28,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _hudBadge("Repair Points", "5", Colors.orange),
                        const SizedBox(width: 16),
                        _hudBadge("Urgent", "2", Colors.red),
                        const SizedBox(width: 16),
                        _hudBadge("In Progress", "3", const Color(0xFF00FF9F)),
                      ],
                    ),
                    Text(
                      "ZONE A-E  ·  SECTOR OVERVIEW",
                      style: GoogleFonts.notoSans(
                        color: Colors.white24,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _hudBadge(String label, String count, Color color) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          "$label ",
          style: GoogleFonts.notoSans(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          count,
          style: GoogleFonts.notoSans(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildMarkerWidget({
    required IconData icon,
    required Color color,
    required String house,
    required String issue,
  }) {
    return GestureDetector(
      onTap: () => widget.onMarkerTap?.call(house, issue),
      child: RepaintBoundary(
        child: _PulsingMarker(
          icon: icon,
          color: color,
          house: house,
          issue: issue,
        ),
      ),
    );
  }
}

// Pulsing marker with animation
class _PulsingMarker extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String house;
  final String issue;

  const _PulsingMarker({
    required this.icon,
    required this.color,
    required this.house,
    required this.issue,
  });

  @override
  State<_PulsingMarker> createState() => _PulsingMarkerState();
}

class _PulsingMarkerState extends State<_PulsingMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulseValue = _pulseController.value;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Outer pulse ring
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.color.withOpacity(0.3 * pulseValue),
                      width: 2 + (pulseValue * 2),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.85), // Solid dark background for contrast
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.color, 
                        width: 1.8, 
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withOpacity(0.5 + pulseValue * 0.3),
                          blurRadius: 10 + (pulseValue * 6), // Sharper glow
                          spreadRadius: 1 + (pulseValue * 1),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.icon, 
                      color: widget.color, 
                      size: 16, // Balanced size
                    ),
                  ),
                ),
                // Connector line
                Container(
                  width: 1.5,
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [widget.color, widget.color.withOpacity(0.0)],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 6),
            // Glass label - High Contrast
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                border: Border.all(
                  color: widget.color.withOpacity(0.8),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.2),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'UNIT: ${widget.house}',
                    style: GoogleFonts.shareTechMono(
                      color: widget.color,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.issue.toUpperCase(),
                    style: GoogleFonts.shareTechMono(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// Grid Painter
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC5A059).withOpacity(0.08)
      ..strokeWidth = 0.5;

    const spacing = 50.0;
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Scan Line Painter
class ScanLinePainter extends CustomPainter {
  final double progress;
  ScanLinePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height * progress;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          const Color(0xFF00FF9F).withOpacity(0.06),
          const Color(0xFF00FF9F).withOpacity(0.12),
          const Color(0xFF00FF9F).withOpacity(0.06),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, y - 40, size.width, 80));

    canvas.drawRect(Rect.fromLTWH(0, y - 40, size.width, 80), paint);

    // Thin bright line
    final linePaint = Paint()
      ..color = const Color(0xFF00FF9F).withOpacity(0.3)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
  }

  @override
  bool shouldRepaint(ScanLinePainter oldDelegate) => true;
}

// HUD Corner Bracket Painter
class HudCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC5A059).withOpacity(0.4)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const len = 30.0;
    const margin = 12.0;

    // Top-left
    canvas.drawLine(
      const Offset(margin, margin),
      const Offset(margin + len, margin),
      paint,
    );
    canvas.drawLine(
      const Offset(margin, margin),
      const Offset(margin, margin + len),
      paint,
    );

    // Top-right
    canvas.drawLine(
      Offset(size.width - margin, margin),
      Offset(size.width - margin - len, margin),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - margin, margin),
      Offset(size.width - margin, margin + len),
      paint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(margin, size.height - margin),
      Offset(margin + len, size.height - margin),
      paint,
    );
    canvas.drawLine(
      Offset(margin, size.height - margin),
      Offset(margin, size.height - margin - len),
      paint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(size.width - margin, size.height - margin),
      Offset(size.width - margin - len, size.height - margin),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - margin, size.height - margin),
      Offset(size.width - margin, size.height - margin - len),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
