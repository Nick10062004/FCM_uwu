import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VillageMapWidget extends StatelessWidget {
  const VillageMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black, // Dark background behind map
      ),
      child: Stack(
        children: [
          // Real Village Map Asset - Set to Fill the entire area
          Positioned.fill(
            child: Image.asset(
              'assets/village_map.jpg',
              fit: BoxFit.cover, 
              color: Colors.black.withOpacity(0.3), // Darken map
              colorBlendMode: BlendMode.darken,
            ),
          ),
          // Cyber Grid Overlay (Moved to top of image)
          Positioned.fill(
            child: Opacity(
              opacity: 0.15, // Subtle grid
              child: CustomPaint(
                painter: GridPainter(),
              ),
            ),
          ),
          // Tech Markers / Repair Requests
          _buildMarker(
            top: 110, 
            left: 210, 
            icon: Icons.water_drop, 
            color: Colors.orange,
            house: 'B12',
            issue: 'LEAKAGE',
          ),
          _buildMarker(
            top: 260, 
            left: 460, 
            icon: Icons.electric_bolt, 
            color: Colors.red,
            house: 'A05',
            issue: 'BLACKOUT',
          ),
          _buildMarker(
            top: 160, 
            left: 610, 
            icon: Icons.build, 
            color: const Color(0xFFFFD700),
            house: 'C08',
            issue: 'BROKEN FAUCET',
          ),
        ],
      ),
    );
  }

  Widget _buildMarker({
    required double top, 
    required double left, 
    required IconData icon, 
    required Color color,
    required String house,
    required String issue,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Marker Icon with Pulsing Effect
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                width: 2,
                height: 15,
                color: color,
              ),
            ],
          ),
          const SizedBox(width: 8),
          // Repair Ticket Label (Clean Transparent)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A).withOpacity(0.9),
              border: Border.all(color: color.withOpacity(0.5), width: 1.0),
              borderRadius: BorderRadius.circular(2),
              boxShadow: const [
                BoxShadow(color: Colors.black54, blurRadius: 4),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                    Text(
                      'H: $house',
                      style: GoogleFonts.notoSans(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      issue,
                      style: GoogleFonts.notoSans(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD700).withOpacity(0.1)
      ..strokeWidth = 1.0;

    const spacing = 40.0;
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
