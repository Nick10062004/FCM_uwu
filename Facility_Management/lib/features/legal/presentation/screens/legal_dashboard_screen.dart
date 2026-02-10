import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/technician_card.dart';
import '../widgets/village_map_widget.dart';

class LegalDashboardScreen extends StatelessWidget {
  const LegalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Charcoal black from Image 2
      body: Stack(
        children: [
          // 1. Full Screen Background Map
          const Positioned.fill(
            child: VillageMapWidget(),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent, // Fully transparent
              ),
              child: _buildHeader(),
            ),
          ),
          
          // 3. Clean Technician Status Bar (Bottom Overlay)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent, // Fully transparent
              ),
              child: _buildTechnicianBar(random),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Shield Icon in Premium Container from Image
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFF151515), // Deep Charcoal
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFC5A059).withOpacity(0.3), // Gold Metallic
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.shield_rounded,
                  color: Color(0xFFC5A059), // Gold Metallic
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'FCM PLATFORM',
                    style: GoogleFonts.notoSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                    ),
                  ),
                  Text(
                    'ENTERPRISE QUALITY MANAGEMENT',
                    style: GoogleFonts.notoSans(
                      color: const Color(0xFFC5A059),
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _headerInfo('22°C', Icons.wb_sunny_outlined),
              _headerInfo('HUMIDITY 49%', Icons.water_drop_outlined),
              _headerInfo('WIND 4 KM/H', Icons.air),
              const Icon(Icons.keyboard_arrow_down, color: Color(0xFFFFD700), size: 16),
              const SizedBox(width: 15),
              const Icon(Icons.close, color: Colors.white38, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerInfo(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFFD700).withOpacity(0.8), size: 14),
          const SizedBox(width: 8),
          Text(
            label, 
            style: GoogleFonts.notoSans(
              color: Colors.white.withOpacity(0.9), 
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightSidebar() {
    return Container(
      width: 60,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4), // Semi-transparent for overlay
        border: const Border(left: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: Column(
        children: [
          _sideIcon(Icons.folder_open),
          _sideIcon(Icons.exit_to_app, label: 'ESC'),
          _sideIcon(Icons.settings, label: 'SET'),
          _sideIcon(Icons.tab, label: 'TAB'),
        ],
      ),
    );
  }

  Widget _sideIcon(IconData icon, {String? label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: [
          Icon(icon, color: Colors.white54, size: 28),
          if (label != null)
            Text(label, style: const TextStyle(color: Colors.white24, fontSize: 8)),
        ],
      ),
    );
  }

  Widget _buildTechnicianBar(Random random) {
    final technicians = [
      {'name': 'RATTANAPHA S.', 'status': 'AIR COND', 'color': const Color(0xFF00FF9F), 'image': 'assets/jib_air.jpg'},
      {'name': 'WICHAI V.', 'status': 'ELECTRICAL', 'color': const Color(0xFF00FF9F), 'image': 'assets/wichai_electric.jpg'},
      {'name': 'KONGKIAT P.', 'status': 'PLUMBING', 'color': const Color(0xFF00FF9F), 'image': 'assets/kong_plumbing.jpg'},
      {'name': 'APICHAT C.', 'status': 'MASONRY', 'color': const Color(0xFF00FF9F), 'image': 'assets/jack_senior.jpg'},
      {'name': 'NICHCHA K.', 'status': 'PAINTING', 'color': const Color(0xFF00FF9F), 'image': 'assets/grace_paint.jpg'},
      {'name': 'PEERAPOL M.', 'status': 'SYSTEMS', 'color': const Color(0xFF00FF9F), 'image': 'assets/prism_it.jpg'},
      {'name': 'SATTAWAT L.', 'status': 'MAINTENANCE', 'color': const Color(0xFF00FF9F), 'image': 'assets/coupe_maint.jpg'},
    ];

    return Container(
      height: 260, // Slightly more height
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center the tech cards
            children: technicians.map((tech) {
              return TechnicianCard(
                name: tech['name'] as String,
                status: tech['status'] as String,
                statusColor: tech['color'] as Color,
                imagePath: tech['image'] as String?,
                isActive: random.nextBool(), // Randomized state
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
