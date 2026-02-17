import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../widgets/technician_card.dart';

import '../widgets/village_map_widget.dart';

// Retro Terminal Theme Constants
const Color retroAmber = Color(0xFFFFB000);
const Color retroAmberDim = Color(0xFF8B6000);
const Color retroBg = Color(0xFF050505);

Widget _terminalText(String text, {double fontSize = 12, Color color = retroAmber, FontWeight fontWeight = FontWeight.normal, double letterSpacing = 0.5}) {
  return Text(
    text,
    style: GoogleFonts.shareTechMono(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
    ),
  );
}

Widget _terminalHeader(String text, {double fontSize = 28, Color color = retroAmber}) {
  return Text(
    text,
    style: GoogleFonts.vt323(
      color: color,
      fontSize: fontSize,
      letterSpacing: 1.0,
    ),
  );
}

class LegalDashboardScreen extends StatefulWidget {

  const LegalDashboardScreen({super.key});

  @override

  State<LegalDashboardScreen> createState() => _LegalDashboardScreenState();

}

class _LegalDashboardScreenState extends State<LegalDashboardScreen> {
  void _showTechnicianDossier(BuildContext context, Map<String, dynamic> tech) {
    // Check if tech is active
    final bool isActive = tech['isActive'] as bool? ?? true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Widget dialogContent = Container(
                width: 1100,
                height: 800,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F0F0F),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: const Color(0xFFC5A059).withOpacity(0.2), width: 1.5),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 60, spreadRadius: 10),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Stack(
                    children: [
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Icon(Icons.security_rounded, size: 300, color: const Color(0xFFC5A059).withOpacity(0.02)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(48),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 180,
                                        height: 240,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(24),
                                          border: Border.all(color: const Color(0xFFC5A059).withOpacity(0.3), width: 2),
                                          image: DecorationImage(
                                            image: AssetImage(tech['image'] as String),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 32),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _terminalText("PERSONNEL_DOSSIER // ${tech['id']}", fontSize: 10, color: const Color(0xFFC5A059).withOpacity(0.5), letterSpacing: 2),
                                            const SizedBox(height: 12),
                                            Text((tech['name'] as String).toUpperCase(), style: GoogleFonts.notoSans(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900)),
                                            Text(tech['role'] as String, style: GoogleFonts.notoSans(color: const Color(0xFFC5A059), fontSize: 14, fontWeight: FontWeight.w800)),
                                            const SizedBox(height: 24),
                                            Wrap(
                                              spacing: 12,
                                              children: (tech['abilities'] as List<dynamic>).map((a) => Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFC5A059).withOpacity(0.05),
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: const Color(0xFFC5A059).withOpacity(0.1)),
                                                ),
                                                child: _terminalText((a as String).toUpperCase(), fontSize: 9, fontWeight: FontWeight.bold, color: const Color(0xFFC5A000 + 0x59)),
                                              )).toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 40),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _dossierInfoItem("AGE", "${tech['age']}"),
                                              _dossierInfoItem("HEIGHT", tech['height'] as String),
                                              _dossierInfoItem("BIRTHPLACE", tech['birthplace'] as String),
                                              const SizedBox(height: 24),
                                              _terminalText("FIELD_BIOGRAPHY", fontSize: 10, color: Colors.white24, fontWeight: FontWeight.w900, letterSpacing: 1),
                                              const SizedBox(height: 12),
                                              Text(tech['bio'] as String, style: GoogleFonts.notoSans(color: Colors.white70, fontSize: 13, height: 1.6)),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 40),
                                        Container(
                                          width: 200,
                                          height: 200,
                                          child: CustomPaint(
                                            painter: RadarChartPainter(
                                              stats: Map<String, double>.from(tech['stats'] as Map),
                                              color: const Color(0xFFC5A059),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  Center(
                                    child: SizedBox(
                                      width: 200,
                                      child: ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFC5A059).withOpacity(0.1),
                                          foregroundColor: const Color(0xFFC5A059),
                                          side: BorderSide(color: const Color(0xFFC5A059).withOpacity(0.3)),
                                          padding: const EdgeInsets.symmetric(vertical: 20),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                        child: _terminalText("DISMISS DOSSIER", fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 60),
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _terminalText("AVAILABILITY_MATRIX", fontSize: 10, color: Colors.white24, fontWeight: FontWeight.w900, letterSpacing: 1),
                                          const SizedBox(height: 4),
                                          Text("WORK SCHEDULE", style: GoogleFonts.notoSans(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                                        ],
                                      ),
                                      _terminalText("SYNCED // 2026.02.17", fontSize: 9, color: const Color(0xFF00FF9F).withOpacity(0.5), fontWeight: FontWeight.bold),
                                    ],
                                  ),
                                  const SizedBox(height: 32),
                                  Expanded(
                                    child: _buildTechScheduleCalendar(tech['name'] as String, tech['role'] as String, setDialogState, [], showDelete: false),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 24,
                        right: 24,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded, color: Colors.white38),
                        ),
                      ),
                    ],
                  ),
                ),
              );

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
              child: isActive 
                  ? dialogContent 
                  : ColorFiltered(
                      colorFilter: const ColorFilter.matrix([
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0.2126, 0.7152, 0.0722, 0, 0,
                        0,      0,      0,      1, 0,
                      ]),
                      child: dialogContent,
                    ),
            );
          },
        );
      },
    );
  }

  Widget _dossierInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _terminalText(label, fontSize: 9, color: Colors.white24, fontWeight: FontWeight.w900, letterSpacing: 1),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.notoSans(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  int _selectedIndex = 0;

  List<Map<String, dynamic>> get _techniciansData => [
    {
      'name': 'Jib', 
      'role': 'AIR COND. SPECIALIST', 
      'id': 'TECH-401', 
      'phone': '+66 81 234 5678',
      'email': 'jib.ice@fcm.com',
      'image': 'assets/jib_air.jpg',
      'age': 28,
      'height': "165 cm",
      'birthplace': 'Bangkok, Thailand',
      'abilities': ['System Diagnostics', 'Refrigerant Recovery', 'HVAC Optimization'],
      'bio': 'Precise and efficient. Specialized in complex VRF systems and energy-saving cooling solutions.',
      'stats': {'Technical': 0.9, 'Speed': 0.85, 'Reliability': 0.95, 'Force': 0.3, 'Versatility': 0.8},
      'rating': 4.9,
      'isActive': true,
    },
    {
      'name': 'Wichai', 
      'role': 'SENIOR ELECTRICIAN', 
      'id': 'TECH-402', 
      'phone': '+66 82 345 6789',
      'email': 'wichai.volt@fcm.com',
      'image': 'assets/wichai_electric.jpg',
      'age': 45,
      'height': "175 cm",
      'birthplace': 'Udon Thani, Thailand',
      'abilities': ['High-Voltage Grid', 'PLC Programming', 'Infrared Thermography'],
      'bio': 'The most senior electrician in the team. Known for identifying electrical leaks before they happen.',
      'stats': {'Technical': 0.98, 'Speed': 0.6, 'Reliability': 0.99, 'Force': 0.4, 'Versatility': 0.8},
      'rating': 4.8,
      'isActive': true,
    },
    {
      'name': 'Kong', 
      'role': 'SENIOR PLUMBER', 
      'id': 'TECH-403', 
      'phone': '+66 83 456 7890',
      'email': 'kong.pipe@fcm.com',
      'image': 'assets/kong_plumbing.jpg',
      'age': 34,
      'height': "182 cm",
      'birthplace': 'Chiang Mai, Thailand',
      'abilities': ['Mainline Welding', 'Hydro-Static Testing', 'Septic Optimization'],
      'bio': 'Calm under pressure. Excellent at handling major water main bursts and system rerouting.',
      'stats': {'Technical': 0.85, 'Speed': 0.8, 'Reliability': 0.9, 'Force': 0.9, 'Versatility': 0.7},
      'rating': 4.6,
      'isActive': false,
    },
    {
      'name': 'Keng', 
      'role': 'MASONRY EXPERT', 
      'id': 'TECH-404', 
      'phone': '+66 84 567 8901',
      'email': 'keng.stone@fcm.com',
      'image': 'assets/jack_senior.jpg',
      'age': 39,
      'height': "170 cm",
      'birthplace': 'Phuket, Thailand',
      'abilities': ['Structural Reinforcement', 'Tile Precision', 'Waterproofing'],
      'bio': 'Obsessed with structural integrity. His tile work is legendary for its millimeter accuracy.',
      'stats': {'Technical': 0.92, 'Speed': 0.5, 'Reliability': 0.97, 'Force': 0.8, 'Versatility': 0.5},
      'rating': 4.7,
      'isActive': true,
    },
    {
      'name': 'Grace', 
      'role': 'PAINTING SPECIALIST', 
      'id': 'TECH-405', 
      'phone': '+66 85 678 9012',
      'email': 'grace.hue@fcm.com',
      'image': 'assets/grace_paint.jpg',
      'age': 26,
      'height': "162 cm",
      'birthplace': 'Bangkok, Thailand',
      'abilities': ['Epoxy Coating', 'Wall Texture Art', 'Color Matching'],
      'bio': 'Brings aesthetic perfection to functional spaces. Expert in industrial-grade protective coatings.',
      'stats': {'Technical': 0.88, 'Speed': 0.9, 'Reliability': 0.88, 'Force': 0.3, 'Versatility': 0.85},
      'rating': 4.5,
      'isActive': true,
    },
    {
      'name': 'Pee', 
      'role': 'SYSTEMS ENGINEER', 
      'id': 'TECH-406', 
      'phone': '+66 86 789 0123',
      'email': 'pee.tech@fcm.com',
      'image': 'assets/prism_it.jpg',
      'age': 31,
      'height': "178 cm",
      'birthplace': 'Nonthaburi, Thailand',
      'abilities': ['CCTV Networking', 'Smart Access Control', 'Firebase Integration'],
      'bio': 'Bridges the gap between hardware and software. Ensures the whole facility remains "Smart".',
      'stats': {'Technical': 0.95, 'Speed': 0.85, 'Reliability': 0.9, 'Force': 0.2, 'Versatility': 0.95},
      'rating': 4.9,
      'isActive': false,
    },
    {
      'name': 'Serm', 
      'role': 'MAINTENANCE HEAD', 
      'id': 'TECH-407', 
      'phone': '+66 87 890 1234',
      'email': 'serm.lead@fcm.com',
      'image': 'assets/coupe_maint.jpg',
      'age': 50,
      'height': "172 cm",
      'birthplace': 'Nakhon Pathom, Thailand',
      'abilities': ['Team Leadership', 'Budgeting', 'Crisis Protocol'],
      'bio': 'The leader who knows every bolt and pipe in the facility. Commands respect with absolute knowledge.',
      'stats': {'Technical': 0.8, 'Speed': 0.5, 'Reliability': 1.0, 'Force': 0.6, 'Versatility': 1.0},
      'rating': 5.0,
      'isActive': true,
    },
  ];

  final Random _random = Random();

  @override

  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          // --- Global Atmospheric Background (Black-Gold Gradient) ---
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFF0D0D0D), // Deep Black
                    Color(0xFF1A1A1A), // Medium Grey-Black
                    Color(0xFF0F0F0F), // Dark Base
                  ],
                ),
              ),
            ),
          ),
          
          // Background Map - Stays behind everything (more transparent to show the new gradient)
          Positioned.fill(
            child: Opacity(
              opacity: 0.85, // Restored from 0.3 for maximum clarity
              child: const VillageMapWidget()
            ),
          ),

          // Gradient overlays for map readability
          const Positioned(
            top: 0, left: 0, right: 0, height: 160,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x44000000), Colors.transparent], // Reduced from 0xCC
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 0, left: 0, right: 0, height: 160,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0x44000000), Colors.transparent], // Reduced from 0xCC
                  ),
                ),
              ),
            ),
          ),

          // --- Image 1 Glow Effect (Deep Orange/Amber Radial Glow) ---
          Positioned(
            bottom: -300,
            right: -100,
            child: IgnorePointer(
              child: Container(
                width: 1000,
                height: 1000,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFC5A059).withOpacity(0.1),
                      const Color(0xFFC5A059).withOpacity(0.02),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // --- Global Mesh Aura (Active for Tasks/Service Requests) ---
          if (_selectedIndex == 1) ...[
            Positioned(
              top: -200,
              right: -100,
              child: IgnorePointer(
                child: Container(
                  width: 800,
                  height: 700,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFC5A059).withOpacity(0.08), // Softer gold aura to blend with bg
                        const Color(0xFFC5A059).withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -150,
              left: -150,
              child: IgnorePointer(
                child: Container(
                  width: 1000,
                  height: 800,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF6366F1).withOpacity(0.15), 
                        const Color(0xFF6366F1).withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
          Positioned(
            top: 150,
            left: -200,
            child: IgnorePointer(
              child: Container(
                width: 600,
                height: 800,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFC5A059).withOpacity(0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Adding a warm center glow for "Color Play"
          Positioned(
            top: 300,
            right: 200,
            child: IgnorePointer(
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFC5A059).withOpacity(0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Main Layout Row: Sidebar + Content
          Row(
            children: [
              _HoverSidebar(
                selectedIndex: _selectedIndex,
                onIndexChanged: (index) => setState(() => _selectedIndex = index),
                onLogout: () => Navigator.pushReplacementNamed(context, '/login'),
              ),
              Expanded(
                child: SafeArea(
                  child: Stack(
                    children: [
                      Positioned.fill(child: _buildCurrentView()),
                      Positioned(top: 0, left: 0, right: 0, child: _buildHeader()),
                      if (_selectedIndex == 0)
                        _buildBottomPanel(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentView() {

    if (_selectedIndex == 0) return const SizedBox.shrink(); // Map is always visible behind

    return Container(
      color: const Color(0xFF0A0A0A), // Solid dark background to hide map
      child: Builder(

        builder: (context) {

          switch (_selectedIndex) {

            case 1:

              return _buildTasksView();

            case 2:

              return _buildTechniciansView();

            case 3:

              return _buildSettingsView();

            case 4:

              return _buildProfileView();

            case 5:

              return _buildStatisticsView();

            default:

              return const SizedBox.shrink();

          }

        },

      ),

    );

  }

  // --- Sub-Views ---

  Widget _buildBottomPanel() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 60), // Lift higher
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 3, height: 14, color: const Color(0xFFC5A059)),
                  const SizedBox(width: 10),
                  Text(
                    "TECHNICIANS CURRENTLY ON DUTY",
                    style: GoogleFonts.shareTechMono(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildTechnicianBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {

    final activities = [

      {"title": "Roof Leak Repair", "subtitle": "House 123/45 | 10 mins ago", "color": const Color(0xFFC5A059)},
      {"title": "Electrical Maintenance", "subtitle": "House 102/12 | 1 hr ago", "color": const Color(0xFF00FF9F)},
      {"title": "Garden Maintenance", "subtitle": "House 105/9 | 2 hrs ago", "color": Colors.white38},
      {"title": "New Service Request", "subtitle": "House 110/3 | 4 hrs ago", "color": const Color(0xFFC5A059)},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFFC5A059),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "RECENT ACTIVITY",
                style: GoogleFonts.notoSans(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...activities.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),

              child: Row(

                children: [

                  Container(

                    width: 8,

                    height: 8,

                    decoration: BoxDecoration(

                      color: item['color'] as Color,

                      shape: BoxShape.circle,

                      boxShadow: [

                        BoxShadow(

                          color: (item['color'] as Color).withOpacity(0.4),

                          blurRadius: 6,

                          spreadRadius: 1,

                        ),

                      ],

                    ),

                  ),

                  const SizedBox(width: 14),

                  Expanded(

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Text(item['title'] as String, style: GoogleFonts.notoSans(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),

                        const SizedBox(height: 2),

                        Text(item['subtitle'] as String, style: GoogleFonts.notoSans(color: Colors.white30, fontSize: 10)),

                      ],

                    ),

                  ),

                ],

              ),

            );

          }),

          const SizedBox(height: 8),

          GestureDetector(

            onTap: () => setState(() => _selectedIndex = 1),

            child: Container(

              width: double.infinity,

              padding: const EdgeInsets.symmetric(vertical: 12),

              decoration: BoxDecoration(

                color: Colors.white.withOpacity(0.03),

                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: Colors.white.withOpacity(0.06)),

              ),

              child: Center(

                child: Text(

                  "VIEW FULL HISTORY >",

                  style: GoogleFonts.notoSans(

                    color: const Color(0xFFC5A059),

                    fontSize: 12,

                    fontWeight: FontWeight.w700,

                  ),

                ),

              ),

            ),

          ),

        ],

      ),

    );

  }

  String _taskFilter = "ALL";

  Widget _buildTasksView() {

    final allTasks = [
      {"id": "5928", "status": "PENDING", "title": "Balcony Drain Clog", "house": "123/45", "requester": "Sombat", "date": "11 Feb 2026", "icon": Icons.water_drop},
      {"id": "5748", "status": "PENDING", "title": "Main Breaker Trip", "house": "105/9", "requester": "Wanida", "date": "11 Feb 2026", "icon": Icons.bolt},     
      {"id": "4216", "status": "WORKING", "title": "Walkway Light Out", "house": "102/12", "requester": "Vichit", "date": "10 Feb 2026", "icon": Icons.lightbulb, "staff": "Keng"},    
      {"id": "9488", "status": "DONE", "title": "Bathroom Leak Fix", "house": "105/9", "requester": "Wipa", "date": "10 Feb 2026", "icon": Icons.water_drop, "staff": "Wichai"},
      {"id": "1120", "status": "DENIED", "title": "Garden Wall Repaint", "house": "112/5", "requester": "Somchai", "date": "12 Feb 2026", "icon": Icons.brush},
      {"id": "3102", "status": "WORKING", "title": "Water Heater Malfunction", "house": "110/3", "requester": "Preecha", "date": "09 Feb 2026", "icon": Icons.thermostat, "staff": "Jib"},
      {"id": "2281", "status": "WORKING", "title": "Kitchen Sink Drain", "house": "108/2", "requester": "Amorn", "date": "11 Feb 2026", "icon": Icons.water_drop, "staff": "Kong"},
    ];

    final int totalCount = allTasks.length;
    final int pendingCount = allTasks.where((t) => t['status'] == "PENDING").length;
    final int workingCount = allTasks.where((t) => t['status'] == "WORKING").length;
    final int doneCount = allTasks.where((t) => t['status'] == "DONE").length;

    // --- Idea 2: Village Health Score Calculation ---
    const int totalHouses = 120;
    final activeIssueHouses = allTasks
        .where((t) => t['status'] != "DONE")
        .map((t) => t['house'] as String)
        .toSet()
        .length;
    final double healthScore = ((totalHouses - activeIssueHouses) / totalHouses) * 100;

    // --- Idea 3: Critical Focus Selection ---
    final criticalTask = allTasks.firstWhere(
      (t) => t['status'] == "PENDING" && (t['icon'] == Icons.bolt || t['icon'] == Icons.water_drop),
      orElse: () => allTasks.firstWhere((t) => t['status'] != "DONE", orElse: () => allTasks[0]),
    );

    final filteredTasks = _taskFilter == "ALL" 
        ? allTasks 
        : allTasks.where((t) => t['status'] == _taskFilter).toList();

    return Container(
      color: const Color(0xFF0A0A0A),
      child: Column(
        children: [
          // --- TOP ZONE: Header & HUD ---
          Container(
            padding: const EdgeInsets.fromLTRB(28, 90, 28, 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _terminalText("SYS.ADMIN // SERVICE REQUEST AUDIT", fontSize: 10, color: retroAmber.withOpacity(0.5), letterSpacing: 1.5),
                      const SizedBox(height: 12),
                      Text(
                        "Service Requests",
                        style: GoogleFonts.notoSans(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 340,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3), // Darker glass
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFC5A059).withOpacity(0.3)), // Gold border
                        ),
                        child: TextField(
                          style: GoogleFonts.notoSans(color: Colors.white, fontSize: 13),
                          cursorColor: const Color(0xFFC5A059),
                          decoration: InputDecoration(
                            hintText: "Search requests, ID or unit...",
                            hintStyle: GoogleFonts.notoSans(color: Colors.white24),
                            prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFC5A059), size: 20), // Gold Icon
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 11),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3), // Darker glass
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFC5A059).withOpacity(0.3)), // Gold border
                        ),
                        child: const Icon(Icons.tune_rounded, color: Color(0xFFC5A059), size: 20), // Gold Icon
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  _buildMetricCard(
                    label: "Success Rate",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("94.2%", style: GoogleFonts.notoSans(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: 0.942,
                            backgroundColor: Colors.white.withOpacity(0.05),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00FF9F)),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                    icon: Icons.track_changes_rounded,
                    color: const Color(0xFF00FF9F),
                  ),
                  const SizedBox(width: 16),
                  _buildMetricCard(
                    label: "Village Health",
                    child: Row(
                      children: [
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: healthScore / 100,
                                strokeWidth: 4,
                                backgroundColor: Colors.white.withOpacity(0.05),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                              ),
                              Text("${healthScore.toInt()}%", style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text("Safe Zone", style: GoogleFonts.notoSans(color: Colors.blueAccent.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    icon: Icons.shield_rounded,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(width: 16),
                  _buildMetricCard(
                    label: "Critical Focus",
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 18),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(criticalTask['house'] as String, style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              Text(criticalTask['title'] as String, style: GoogleFonts.notoSans(color: Colors.redAccent.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    icon: Icons.notification_important_rounded,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(width: 16),
                  _buildMetricCard(
                    label: "User Ratings",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(5, (index) => Icon(
                            index < 4 ? Icons.star_rounded : Icons.star_half_rounded,
                            color: const Color(0xFFC5A059),
                            size: 20,
                          )),
                        ),
                        const SizedBox(height: 6),
                        Text("4.8 / 5.0", style: GoogleFonts.notoSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                      ],
                    ),
                    icon: Icons.star_rate_rounded,
                    color: const Color(0xFFC5A059),
                  ),
                  const SizedBox(width: 16),
                  InkWell(
                    onTap: () => setState(() => _selectedIndex = 5),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC5A059).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFC5A059).withOpacity(0.2)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.arrow_forward_rounded, color: Color(0xFFC5A059)),
                          const SizedBox(height: 8),
                          _terminalText("FULL\nSTATS", fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFFC5A059)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // --- BOTTOM ZONE: Solid Workspace ---
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F0F), // Solid Dark Background
              borderRadius: const BorderRadius.only(topRight: Radius.circular(32)), // Remove top-left to avoid gap with sidebar
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.04)),
                right: BorderSide(color: Colors.white.withOpacity(0.04)),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 40,
                  offset: const Offset(0, -10),
                )
              ],
            ),
            padding: const EdgeInsets.fromLTRB(28, 40, 28, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Filter Tab Bar ---
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildModernTab("All", "$totalCount", _taskFilter == "ALL", () => setState(() => _taskFilter = "ALL")),
                          _buildModernTab("Pending", "$pendingCount", _taskFilter == "PENDING", () => setState(() => _taskFilter = "PENDING")),
                          _buildModernTab("Active", "$workingCount", _taskFilter == "WORKING", () => setState(() => _taskFilter = "WORKING")),
                          _buildModernTab("Completed", "$doneCount", _taskFilter == "DONE", () => setState(() => _taskFilter = "DONE")),
                        ],
                      ),
                    ),
                    const Spacer(),
                    _buildCommonAreaTaskButton(),
                  ],
                ),

                const SizedBox(height: 40),

                // --- Table Header ---
                _buildTableHeader(),
                
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: filteredTasks.length,
                    separatorBuilder: (_, __) => Divider(color: Colors.white.withOpacity(0.05), height: 1), 
                    itemBuilder: (context, index) => _buildModernTableRow(filteredTasks[index]),
                  ),
                ),
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }

  Widget _buildCommonAreaTaskButton() {
    return InkWell(
      onTap: () => _showCommonAreaTaskDialog(context),
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFC5A059).withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFC5A059).withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_business_rounded, color: Color(0xFFC5A059), size: 18),
            const SizedBox(width: 8),
            Text(
              "+ COMMON AREA TASK",
              style: GoogleFonts.notoSans(
                color: const Color(0xFFC5A059),
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommonAreaTaskDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController detailsController = TextEditingController();
    String? selectedLocation = "Public Park";
    String? selectedTechId;

    final List<String> locations = [
      "Public Park",
      "Clubhouse / Gym",
      "Swimming Pool",
      "Guardhouse / Entrance",
      "Common Area Lighting",
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            backgroundColor: const Color(0xFF0F0F0F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: const Color(0xFFC5A059).withOpacity(0.2)),
            ),
            child: Container(
              width: 600,
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _terminalText("SYS.TASK // NEW_COMMON_AREA", fontSize: 10, color: const Color(0xFFC5A059).withOpacity(0.5), letterSpacing: 2),
                          const SizedBox(height: 4),
                          Text("Add Common Area Repair Task", style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white24)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // --- Form Fields ---
                  // 1. Title
                  Text("Item / Repair Task", style: GoogleFonts.notoSans(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: titleController,
                    style: GoogleFonts.notoSans(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "e.g. Broken Park Lights, Clean Pool",
                      hintStyle: GoogleFonts.notoSans(color: Colors.white24),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.02),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. Location Dropdown
                  Text("Common Area Location", style: GoogleFonts.notoSans(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedLocation,
                        dropdownColor: const Color(0xFF1A1A1A),
                        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFC5A059)),
                        isExpanded: true,
                        style: GoogleFonts.notoSans(color: Colors.white, fontSize: 14),
                        items: locations.map((loc) => DropdownMenuItem(value: loc, child: Text(loc))).toList(),
                        onChanged: (val) => setDialogState(() => selectedLocation = val),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. Details
                  Text("Additional Details", style: GoogleFonts.notoSans(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: detailsController,
                    maxLines: 3,
                    style: GoogleFonts.notoSans(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Describe the issue...",
                      hintStyle: GoogleFonts.notoSans(color: Colors.white24),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.02),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- Technician Selection ---
                  Row(
                    children: [
                      Text("Assign Technician", style: GoogleFonts.notoSans(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      _terminalText("(CLICK TO SELECT)", fontSize: 9, color: const Color(0xFFC5A059)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _techniciansData.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final tech = _techniciansData[index];
                        final bool isSelected = selectedTechId == tech['id'];
                        return InkWell(
                          onTap: () => setDialogState(() => selectedTechId = tech['id']),
                          borderRadius: BorderRadius.circular(16),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 110,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFC5A059).withOpacity(0.15) : Colors.white.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? const Color(0xFFC5A059) : Colors.white.withOpacity(0.05),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundImage: AssetImage(tech['image']),
                                  backgroundColor: Colors.white10,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  tech['name'],
                                  style: GoogleFonts.notoSans(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  tech['role'],
                                  style: GoogleFonts.notoSans(color: Colors.white54, fontSize: 9),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (isSelected) ...[
                                  const SizedBox(height: 6),
                                  const Icon(Icons.check_circle, color: Color(0xFFC5A059), size: 16),
                                ]
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 32),

                  // --- Actions ---
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.white.withOpacity(0.1)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text("Cancel", style: GoogleFonts.notoSans(color: Colors.white70, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                             // Mock Action
                             Navigator.pop(context);
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                 backgroundColor: const Color(0xFFC5A059),
                                 content: Text("Common Area Task Created!", style: GoogleFonts.notoSans(color: Colors.black, fontWeight: FontWeight.bold))
                               )
                             );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC5A059),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: Text("Create Task", style: GoogleFonts.notoSans(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _terminalText(label, fontSize: 9, color: retroAmber.withOpacity(0.4)),
        _terminalText(value, fontSize: 16, fontWeight: FontWeight.bold, color: color),
      ],
    );
  }

  Widget _buildFilterTabs() {
    final filters = [
      {'id': 'ALL', 'label': 'ALL_TASKS', 'count': 6},
      {'id': 'PENDING', 'label': 'PENDING', 'count': 2},
      {'id': 'WORKING', 'label': 'IN_PROGRESS', 'count': 3},
      {'id': 'DONE', 'label': 'COMPLETED', 'count': 1},
    ];

    return Row(
      children: filters.map((f) {
        final bool isActive = _taskFilter == f['id'];

        return Padding(
          padding: const EdgeInsets.only(right: 24),
          child: InkWell(
            onTap: () => setState(() => _taskFilter = f['id'] as String),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (isActive) _terminalText(">", fontSize: 11, fontWeight: FontWeight.bold),
                    const SizedBox(width: 4),
                    _terminalText(
                      f['label'] as String,
                      fontSize: 11,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      color: isActive ? retroAmber : retroAmber.withOpacity(0.3),
                    ),
                  ],
                ),
                _terminalText(
                   "[ ${f['count']} ]",
                  fontSize: 9,
                  color: isActive ? retroAmber : retroAmber.withOpacity(0.1),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _taskListItem(Map<String, dynamic> task) {
    final statusColor = task['priority'] == 'High' ? Colors.red : retroAmber;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: retroAmber.withOpacity(0.2)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              color: statusColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(task['icon'] as IconData, color: retroAmber, size: 16),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _terminalText(
                            (task['title'] as String).toUpperCase(),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 4),
                          _terminalText(
                            "LOC: HOUSE ${task['house']} // REQ: ${task['requester']} // DATE: ${task['date']}",
                            fontSize: 10,
                            color: retroAmber.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    _terminalText(
                      "[ ${task['status']} ]",
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                    const SizedBox(width: 16),
                    _buildTaskActions(task),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskActions(Map<String, dynamic> task) {
    final String status = task['status'] as String;
    if (status == "PENDING") {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () => _showRejectTaskDialog(context, task),
            child: _terminalText("REJECT", 
                fontSize: 10, 
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFF4D4D).withOpacity(0.8)
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _showApproveAssignDialog(context, task),
            style: ElevatedButton.styleFrom(
              backgroundColor: retroAmber,
              foregroundColor: Colors.black,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: _terminalText("APPROVE & ASSIGN", fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      );
    } else if (status == "WORKING") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          _terminalText("ASSIGNED_TO: WICHAI", fontSize: 9, color: retroAmber.withOpacity(0.3)),
          const SizedBox(height: 6),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: retroAmber.withOpacity(0.2)),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: _terminalText("VIEW_PROGRESS", fontSize: 9, fontWeight: FontWeight.bold),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF00FF9F).withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF00FF9F).withOpacity(0.2)),
            ),
            child: Text("COMPLETED", 
              style: GoogleFonts.notoSans(
                color: const Color(0xFF00FF9F), 
                fontSize: 8, 
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              )
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (i) => 
              const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 12)
            ),
          ),
        ],
      );
    }
  }


  Widget _buildTechniciansView() {
    final technicians = _techniciansData;

    return Container(
      color: const Color(0xFF0D0D0D),
      padding: const EdgeInsets.fromLTRB(28, 90, 28, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _terminalText("SYS.ADMIN // PERSONNEL REGISTRY", fontSize: 10, color: const Color(0xFFC5A059).withOpacity(0.5), letterSpacing: 1.5),
          const SizedBox(height: 12),
          Text(
            "Technician Team List",
            style: GoogleFonts.notoSans(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 40),
          
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _staffHeaderCell("Photo", flex: 1),
                _staffHeaderCell("Member name", flex: 3),
                _staffHeaderCell("Mobile", flex: 2),
                _staffHeaderCell("Email", flex: 3),
                _staffHeaderCell("Status", flex: 2),
                _staffHeaderCell("Job", flex: 2),
                _staffHeaderCell("Rating", flex: 2),
              ],
            ),
          ),
          const SizedBox(height: 8),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 40),
              itemCount: technicians.length,
              separatorBuilder: (_, __) => Divider(color: Colors.white.withOpacity(0.03), height: 1),
              itemBuilder: (context, index) => _buildStaffRow(technicians[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _staffHeaderCell(String label, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: GoogleFonts.notoSans(color: Colors.white24, fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildStaffRow(Map<String, dynamic> tech) {
    bool isHovered = false;
    bool isActive = tech['isActive'] as bool? ?? true;
    return StatefulBuilder(
      builder: (context, setRowState) {
        return MouseRegion(
          onEnter: (_) => setRowState(() => isHovered = true),
          onExit: (_) => setRowState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: isHovered ? (isActive ? Colors.white.withOpacity(0.02) : Colors.white.withOpacity(0.01)) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Opacity(
              opacity: isActive ? 1.0 : 0.4,
              child: Row(
                children: [
                  // Photo
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.centerLeft,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: const Color(0xFFC5A059).withOpacity(0.1),
                        backgroundImage: AssetImage(tech['image'] as String),
                      ),
                    ),
                  ),
                  // Name
                  Expanded(
                    flex: 3,
                    child: InkWell(
                      onTap: () => _showTechnicianDossier(context, tech),
                      child: Text(
                        tech['name'] as String,
                        style: GoogleFonts.notoSans(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          decoration: isHovered && isActive ? TextDecoration.underline : TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                // Mobile
                Expanded(
                  flex: 2,
                  child: Text(
                    tech['phone'] as String,
                    style: GoogleFonts.notoSans(color: Colors.white60, fontSize: 13),
                  ),
                ),
                // Email
                Expanded(
                  flex: 3,
                  child: Text(
                    tech['email'] as String,
                    style: GoogleFonts.notoSans(color: Colors.white38, fontSize: 13),
                  ),
                ),
                // Status (Active/Inactive)
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFF00FF9F).withOpacity(0.1) : const Color(0xFFFF4D4D).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isActive ? "Active" : "Inactive",
                          style: GoogleFonts.notoSans(
                            color: isActive ? const Color(0xFF00FF9F) : const Color(0xFFFF4D4D),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Job
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Text(
                        tech['role'] as String,
                        style: GoogleFonts.notoSans(
                          color: Colors.white70,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Rating
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFC5A059), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${tech['rating']}",
                        style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

  Widget _techStat(String label, String value) {

    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Text(label, style: GoogleFonts.notoSans(color: Colors.white24, fontSize: 8, fontWeight: FontWeight.w900)),

        Text(value, style: GoogleFonts.notoSans(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),

      ],

    );

  }

  Widget _buildProfileView() {
    return Container(
      color: const Color(0xFF0A0A0A),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(40, 100, 40, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Account",
              style: GoogleFonts.notoSans(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 48),
            
            // Avatar & Name Header
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
                        image: const DecorationImage(
                          image: AssetImage('assets/prism_it.jpg'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 30, spreadRadius: 5),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2196F3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit_rounded, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Text(
                        "Admin",
                        style: GoogleFonts.notoSans(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Admin Zeta",
                      style: GoogleFonts.notoSans(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 60),

            // Form Fields: Name & Email
            Row(
              children: [
                Expanded(
                  child: _profileInputField("Name", "Admin Zeta"),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _profileInputField("Email", "admin@gmail.com", isLocked: true),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Action Cards: Change Password & Transfer Ownership
            Row(
              children: [
                Expanded(
                  child: _profileActionCard(
                    "Change password",
                    Icons.lock_outline_rounded,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _profileActionCard(
                    "Transfer ownership",
                    Icons.person_add_alt_1_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Danger Zone: Delete Account
            _profileActionCard(
              "Delete account",
              null,
              content: Text(
                "Contact our support team to process the deletion of your account.",
                style: GoogleFonts.notoSans(color: Colors.white38, fontSize: 12),
              ),
              isDanger: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileInputField(String label, String value, {bool isLocked = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.notoSans(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.notoSans(color: Colors.white70, fontSize: 14),
                ),
              ),
              if (isLocked)
                Icon(Icons.lock_rounded, color: Colors.white.withOpacity(0.4), size: 18),
            ],
          ),
        ),
      ],
    );
  }

  Widget _profileActionCard(String title, IconData? icon, {Widget? content, bool isDanger = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Container(
              width: 44,
              height: 44,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white70, size: 20),
            ),
          Text(
            title,
            style: GoogleFonts.notoSans(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (content != null) ...[
            const SizedBox(height: 8),
            content,
          ],
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, String label, String currentValue) {

    final TextEditingController controller = TextEditingController(text: label == "Password" ? "" : currentValue);
    final bool isPassword = label == "Password";

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF0D0D0D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: const Color(0xFFC5A059).withOpacity(0.2)),
          ),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPassword ? "Change Password" : "Edit $label",
                  style: GoogleFonts.notoSans(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 24),
                _dialogLabel(isPassword ? "New $label" : label),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  obscureText: isPassword,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Enter your $label...",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.15)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.02),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFC5A059)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("CANCEL", style: GoogleFonts.notoSans(color: Colors.white38)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC5A059),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text("SAVE CHANGES", style: GoogleFonts.notoSans(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

  }

  Widget _profileInfoRow(String label, String value, {String? actionText, VoidCallback? onTap}) {

    return Container(

      padding: const EdgeInsets.symmetric(vertical: 20),

      decoration: BoxDecoration(

        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),

      ),

      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [

          Text(

            label,

            style: GoogleFonts.notoSans(

              color: Colors.white38,

              fontSize: 14,

              fontWeight: FontWeight.w600,

            ),

          ),

          Row(

            children: [

              Text(

                value,

                style: GoogleFonts.notoSans(

                  color: Colors.white,

                  fontSize: 15,

                  fontWeight: FontWeight.w700,

                ),

              ),

              if (actionText != null) ...[

                const SizedBox(width: 12),

                TextButton(

                  onPressed: onTap,

                  style: TextButton.styleFrom(

                    padding: EdgeInsets.zero,

                    minimumSize: Size.zero,

                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,

                  ),

                  child: Text(

                    actionText,

                    style: GoogleFonts.notoSans(

                      color: const Color(0xFF5991C5), // Blue link color from screenshot

                      fontSize: 13,

                      fontWeight: FontWeight.bold,

                    ),

                  ),

                ),

              ],

            ],

          ),

        ],

      ),

    );

  }

  Widget _buildSettingsView() {

    return Container(

      color: const Color(0xFF0D0D0D),

      padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Text(

            "MANAGEMENT: SYSTEM CONFIGURATION",

            style: GoogleFonts.notoSans(color: const Color(0xFFC5A059), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5),

          ),

          Text(

            "SYSTEM CONFIGURATION",

            style: GoogleFonts.notoSans(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),

          ),

          const SizedBox(height: 32),

          _settingsRow("DARK MODE", "Dark Mode (System Sync)", true),

          _settingsRow("PUSH NOTIFICATIONS", "Push Notifications for all activities", true),

          _settingsRow("AUTO-ASSIGN", "Auto-assign tasks when technicians are available", false),

          _settingsRow("LANGUAGE", "English (US)", null),

        ],

      ),

    );

  }

  Widget _settingsRow(String title, String subtitle, bool? value) {

    return Container(

      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(

        color: const Color(0xFF151515),

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: Colors.white.withOpacity(0.05)),

      ),

      child: Row(

        children: [

          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(title, style: GoogleFonts.notoSans(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),

                Text(subtitle, style: GoogleFonts.notoSans(color: Colors.white38, fontSize: 12)),

              ],

            ),

          ),

          if (value != null)

            Switch(

              value: value,

              onChanged: (v) {},

              activeColor: const Color(0xFFC5A059),

              activeTrackColor: const Color(0xFFC5A059).withOpacity(0.3),

            ),

          if (value == null)

            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),

        ],

      ),

    );

  }

  Widget _buildHeader() {
    if (_selectedIndex == 1) return const SizedBox.shrink(); // Hide on Request screen
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "PHRA KHANONG FACILITY AUDIT // SES.ADMIN_01",
                style: GoogleFonts.notoSans(
                  color: Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "TODAY'S REPAIR REQUESTS",
                style: GoogleFonts.notoSans(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _headerInfo('22°C', Icons.wb_sunny_rounded),
              _headerInfo('Humidity 49%', Icons.water_drop_rounded),
              _headerInfo('Wind 4 km/h', Icons.air_rounded),
              const SizedBox(width: 20),
              const Icon(Icons.close_rounded, color: Colors.white24, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerInfo(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFC5A059), size: 14),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.notoSans(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicianBar() {
    final technicians = _techniciansData;

    return Container(
      height: 160,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: technicians.length,
          itemBuilder: (context, index) {
            final tech = technicians[index];
            final bool isActive = tech['isActive'] as bool? ?? true;
            final Color statusColor = isActive 
                ? const Color(0xFF00FF9F) 
                : Colors.white24;

            return _buildTechSelectionCard(
              tech['name'] as String,
              tech['role'] as String,
              tech['image'] as String,
              statusColor,
              isSelected: false,
              isActive: isActive,
              onTap: () => _showTechnicianDossier(context, tech),
            );
          },
        ),
      ),
    );
  }

  void _showTaskControlCenter(BuildContext context, Map<String, dynamic> task) {
    final String status = task['status'] as String;
    final Color accentColor = status == 'DONE' ? const Color(0xFF00FF9F) : (status == 'PENDING' ? const Color(0xFFFF4D4D) : const Color(0xFFFFB000));

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF0D0D0D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: accentColor.withOpacity(0.2)),
        ),
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _terminalText(status, fontSize: 10, color: accentColor, fontWeight: FontWeight.w900, letterSpacing: 2),
                      const SizedBox(height: 4),
                      Text(task['title'], style: GoogleFonts.notoSans(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Colors.white38)),
                ],
              ),
              const SizedBox(height: 24),
              _terminalText("LOCATION: HOUSE ${task['house']}", color: Colors.white70, fontSize: 12),
              _terminalText("REQUESTER: ${task['requester']}", color: Colors.white70, fontSize: 12),
              const SizedBox(height: 32),
              
              if (status == 'PENDING') ...[
                _buildControlButton(
                  label: "APPROVE & ASSIGN",
                  icon: Icons.check_circle_outline,
                  color: const Color(0xFFC5A059),
                  onTap: () {
                    Navigator.pop(context);
                    _showApproveAssignDialog(context, task);
                  },
                ),
                const SizedBox(height: 12),
                _buildControlButton(
                  label: "REJECT REQUEST",
                  icon: Icons.block_flipped,
                  color: const Color(0xFFFF4D4D),
                  onTap: () {
                    Navigator.pop(context);
                    _showRejectTaskDialog(context, task);
                  },
                ),
              ] else if (status == 'WORKING') ...[
                _buildControlButton(
                  label: "VIEW PROGRESS",
                  icon: Icons.trending_up,
                  color: const Color(0xFFFFB000),
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 12),
                _buildControlButton(
                  label: "CHANGE TECHNICIAN",
                  icon: Icons.person_search_outlined,
                  color: Colors.white24,
                  onTap: () {
                    Navigator.pop(context);
                    _showApproveAssignDialog(context, task);
                  },
                ),
              ] else if (status == 'DONE') ...[
                _buildControlButton(
                  label: "VIEW COMPLETION DETAILS",
                  icon: Icons.verified_user_outlined,
                  color: const Color(0xFF00FF9F),
                  onTap: () => Navigator.pop(context),
                ),
              ] else ...[
                // DENIED
                _buildControlButton(
                  label: "VIEW REJECTION REASON",
                  icon: Icons.info_outline,
                  color: const Color(0xFFFF4D4D),
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 12),
                _buildControlButton(
                  label: "RE-OPEN REQUEST",
                  icon: Icons.refresh,
                  color: Colors.white24,
                  onTap: () => Navigator.pop(context),
                ),
              ],
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: _terminalText("CLOSE", color: Colors.white24, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 16),
            Text(label, style: GoogleFonts.notoSans(color: color, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: color.withOpacity(0.3), size: 12),
          ],
        ),
      ),
    );
  }

  void _showRejectTaskDialog(BuildContext context, Map<String, dynamic> task) {

    final TextEditingController reasonController = TextEditingController();

    showDialog(

      context: context,

      builder: (context) {

        return StatefulBuilder(

          builder: (context, setDialogState) {

            return Dialog(

              backgroundColor: const Color(0xFF0D0D0D),

              shape: RoundedRectangleBorder(

                borderRadius: BorderRadius.circular(20),

                side: BorderSide(color: const Color(0xFFFF4D4D).withOpacity(0.2)),

              ),

              child: Container(

                width: 500,

                padding: const EdgeInsets.all(32),

                child: Column(

                  mainAxisSize: MainAxisSize.min,

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [

                        Text(

                          "Confirm Rejection",

                          style: GoogleFonts.notoSans(

                            color: const Color(0xFFFF4D4D),

                            fontSize: 24,

                            fontWeight: FontWeight.w900,

                          ),

                        ),

                        IconButton(

                          onPressed: () => Navigator.pop(context),

                          icon: const Icon(Icons.close, color: Colors.white38),

                        ),

                      ],

                    ),

                    const SizedBox(height: 32),

                    _dialogLabel("REASON FOR REJECTION (REQUIRED)"),

                    const SizedBox(height: 12),

                    TextField(

                      controller: reasonController,

                      maxLines: 4,

                      style: const TextStyle(color: Colors.white, fontSize: 14),

                      decoration: InputDecoration(

                        hintText: "Please specify the reason for rejection...",

                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.15)),

                        filled: true,

                        fillColor: Colors.white.withOpacity(0.02),

                        border: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(16),

                          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),

                        ),

                        enabledBorder: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(16),

                          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),

                        ),

                        focusedBorder: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(16),

                          borderSide: const BorderSide(color: Color(0xFFFF4D4D)),

                        ),

                      ),

                    ),

                    const SizedBox(height: 24),

                    _dialogLabel("Template Reasons:"),

                    const SizedBox(height: 12),

                    _rejectTemplateButton(

                      Icon(Icons.close_rounded, color: Colors.red.withOpacity(0.8), size: 18),

                      "Out of Responsibility",

                      () => setDialogState(() => reasonController.text = "This task is outside the scope of my current role and responsibilities."),

                    ),

                    const SizedBox(height: 12),

                    _rejectTemplateButton(

                      Icon(Icons.warning_amber_rounded, color: Colors.orange.withOpacity(0.8), size: 18),

                      "Equipment / Tool Issue",

                      () => setDialogState(() => reasonController.text = "Missing necessary equipment or tools to complete this task safely and effectively."),

                    ),

                    const SizedBox(height: 12),

                    _rejectTemplateButton(

                      Icon(Icons.edit_note_rounded, color: Colors.blue.withOpacity(0.8), size: 18),

                      "Incorrect Information",

                      () => setDialogState(() => reasonController.text = "The task details or location provided appear to be incorrect or incomplete."),

                    ),

                    const SizedBox(height: 40),

                    Row(

                      children: [

                        Expanded(

                          child: TextButton(

                            onPressed: () => Navigator.pop(context),

                            style: TextButton.styleFrom(

                              backgroundColor: Colors.white.withOpacity(0.05),

                              padding: const EdgeInsets.symmetric(vertical: 18),

                              shape: RoundedRectangleBorder(

                                borderRadius: BorderRadius.circular(12),

                                side: const BorderSide(color: Colors.white10),

                              ),

                            ),

                            child: Text(

                              "CANCEL",

                              style: GoogleFonts.notoSans(

                                color: Colors.white38,

                                fontSize: 14,

                                fontWeight: FontWeight.bold,

                              ),

                            ),

                          ),

                        ),

                        const SizedBox(width: 16),

                        Expanded(

                          child: ElevatedButton(

                            onPressed: () => Navigator.pop(context),

                            style: ElevatedButton.styleFrom(

                              backgroundColor: const Color(0xFFFF4D4D),

                              foregroundColor: Colors.white,

                              padding: const EdgeInsets.symmetric(vertical: 18),

                              elevation: 0,

                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

                            ),

                            child: Text(

                              "CONFIRM REJECTION",

                              style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w900),

                            ),

                          ),

                        ),

                      ],

                    ),

                  ],

                ),

              ),

            );

          },

        );

      },

    );

  }

  Widget _rejectTemplateButton(Widget icon, String label, VoidCallback onTap) {

    return InkWell(

      onTap: onTap,

      borderRadius: BorderRadius.circular(12),

      child: Container(

        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),

        decoration: BoxDecoration(

          color: Colors.white.withOpacity(0.04),

          border: Border.all(color: Colors.white.withOpacity(0.06)),

          borderRadius: BorderRadius.circular(12),

        ),

        child: Row(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            icon,

            const SizedBox(width: 10),

            Text(

              label,

              style: GoogleFonts.notoSans(

                color: Colors.white70,

                fontSize: 13,

                fontWeight: FontWeight.w600,

              ),

            ),

          ],

        ),

      ),

    );

  }

  void _showIndividualScheduleDialog(BuildContext context, String name, String role) {

    showDialog(

      context: context,

      builder: (context) {

        return StatefulBuilder(

          builder: (context, setDialogState) {

            return Dialog(

              backgroundColor: const Color(0xFF0D0D0D),

              shape: RoundedRectangleBorder(

                borderRadius: BorderRadius.circular(20),

                side: BorderSide(color: const Color(0xFFC5A059).withOpacity(0.2)),

              ),

              child: Container(

                width: 500,

                padding: const EdgeInsets.all(32),

                child: Column(

                  mainAxisSize: MainAxisSize.min,

                  children: [

                    Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [

                        Column(

                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [

                            Text(

                              "STAFF SCHEDULE",

                              style: GoogleFonts.notoSans(

                                color: const Color(0xFFC5A059),

                                fontSize: 10,

                                fontWeight: FontWeight.w900,

                                letterSpacing: 1.5,

                              ),

                            ),

                            Text(

                              "VERIFY TASK SCHEDULE",

                              style: GoogleFonts.notoSans(

                                color: Colors.white,

                                fontSize: 24,

                                fontWeight: FontWeight.w900,

                              ),

                            ),

                          ],

                        ),

                        IconButton(

                          onPressed: () => Navigator.pop(context),

                          icon: const Icon(Icons.close, color: Colors.white38),

                        ),

                      ],

                    ),

                    const SizedBox(height: 32),

                    _buildTechScheduleCalendar(name, role, setDialogState, [name], showDelete: false),

                    const SizedBox(height: 32),

                    SizedBox(

                      width: double.infinity,

                      child: ElevatedButton(

                        onPressed: () => Navigator.pop(context),

                        style: ElevatedButton.styleFrom(

                          backgroundColor: const Color(0xFFC5A059),

                          foregroundColor: Colors.black,

                          padding: const EdgeInsets.symmetric(vertical: 18),

                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

                        ),

                        child: Text(

                          "CLOSE",

                          style: GoogleFonts.notoSans(fontWeight: FontWeight.w900, letterSpacing: 1),

                        ),

                      ),

                    ),

                  ],

                ),

              ),

            );

          },

        );

      },

    );

  }


  void _showApproveAssignDialog(BuildContext context, Map<String, dynamic> task) {

    List<String> selectedTechs = [];

    showDialog(

      context: context,

      builder: (context) {

        return StatefulBuilder(

          builder: (context, setDialogState) {

            return Dialog(

              backgroundColor: const Color(0xFF0D0D0D),

              shape: RoundedRectangleBorder(

                borderRadius: BorderRadius.circular(20),

                side: BorderSide(color: const Color(0xFFC5A059).withOpacity(0.2)),

              ),

              child: Container(

                width: 600,

                padding: const EdgeInsets.all(32),

                child: SingleChildScrollView(

                  child: Column(

                    mainAxisSize: MainAxisSize.min,

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Row(

                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [

                          Column(

                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              Text(

                                "STAFF ASSIGNMENT",

                                style: GoogleFonts.notoSans(

                                  color: const Color(0xFFC5A059),

                                  fontSize: 10,

                                  fontWeight: FontWeight.w900,

                                  letterSpacing: 1.5,

                                ),

                              ),

                              Text(

                                "Assign Technicians",

                                style: GoogleFonts.notoSans(

                                  color: Colors.white,

                                  fontSize: 24,

                                  fontWeight: FontWeight.w900,

                                ),

                              ),

                            ],

                          ),

                          IconButton(

                            onPressed: () => Navigator.pop(context),

                            icon: const Icon(Icons.close, color: Colors.white38),

                          ),

                        ],

                      ),

                      const SizedBox(height: 32),

                      Container(

                        padding: const EdgeInsets.all(20),

                        decoration: BoxDecoration(

                          color: Colors.white.withOpacity(0.01),

                          border: Border.all(color: Colors.white.withOpacity(0.05)),

                          borderRadius: BorderRadius.circular(16),

                        ),

                        child: Row(

                          children: [

                            Container(

                              padding: const EdgeInsets.all(10),

                              decoration: BoxDecoration(

                                color: const Color(0xFFC5A059).withOpacity(0.1),

                                shape: BoxShape.circle,

                              ),

                              child: const Icon(Icons.calendar_today, color: Color(0xFFC5A059), size: 18),

                            ),

                            const SizedBox(width: 16),

                            Column(

                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [

                                Text("Selected Date / Availability:", style: GoogleFonts.notoSans(color: Colors.white38, fontSize: 11)),

                                Text(

                                  "15 February 2026", // Mocked date as per screenshot

                                  style: GoogleFonts.notoSans(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),

                                ),

                              ],

                            ),

                          ],

                        ),

                      ),

                      const SizedBox(height: 32),

                      _dialogLabel("Select Technicians to Assign (Single click to select/deselect)"),

                      const SizedBox(height: 16),

                      Container(

                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(

                          color: Colors.white.withOpacity(0.01),

                          border: Border.all(color: Colors.white.withOpacity(0.05)),

                          borderRadius: BorderRadius.circular(20),

                        ),

                        child: Wrap(

                          spacing: 12,

                          runSpacing: 12,

                          children: [

                            _buildTechSelectionCard("Wichai", "ELECTRICAL", "assets/wichai_electric.jpg", Colors.green, isSelected: selectedTechs.contains("Wichai"), isActive: true, onTap: () {

                              setDialogState(() {

                                if (selectedTechs.contains("Wichai")) {

                                  selectedTechs.remove("Wichai");

                                } else {

                                  selectedTechs.add("Wichai");

                                }

                              });

                            }),

                            _buildTechSelectionCard("Kong", "PLUMBING", "assets/kong_plumbing.jpg", Colors.orange, isSelected: selectedTechs.contains("Kong"), isActive: false, onTap: () {

                              setDialogState(() {

                                if (selectedTechs.contains("Kong")) {

                                  selectedTechs.remove("Kong");

                                } else {

                                  selectedTechs.add("Kong");

                                }

                              });

                            }),

                            _buildTechSelectionCard("Keng", "MASONRY", "assets/jack_senior.jpg", Colors.green, isSelected: selectedTechs.contains("Keng"), isActive: true, onTap: () {

                              setDialogState(() {

                                if (selectedTechs.contains("Keng")) {

                                  selectedTechs.remove("Keng");

                                } else {

                                  selectedTechs.add("Keng");

                                }

                              });

                            }),

                            _buildTechSelectionCard("Jib", "AIR CONDITIONING", "assets/jib_air.jpg", Colors.green, isSelected: selectedTechs.contains("Jib"), isActive: true, onTap: () {

                              setDialogState(() {

                                if (selectedTechs.contains("Jib")) {

                                  selectedTechs.remove("Jib");

                                } else {

                                  selectedTechs.add("Jib");

                                }

                              });

                            }),

                            _buildTechSelectionCard("Grace", "PAINTING", "assets/grace_paint.jpg", Colors.green, isSelected: selectedTechs.contains("Grace"), isActive: true, onTap: () {

                              setDialogState(() {

                                if (selectedTechs.contains("Grace")) {

                                  selectedTechs.remove("Grace");

                                } else {

                                  selectedTechs.add("Grace");

                                }

                              });

                            }),

                            _buildTechSelectionCard("Pee", "SYSTEMS", "assets/prism_it.jpg", Colors.green, isSelected: selectedTechs.contains("Pee"), isActive: false, onTap: () {

                              setDialogState(() {

                                if (selectedTechs.contains("Pee")) {

                                  selectedTechs.remove("Pee");

                                } else {

                                  selectedTechs.add("Pee");

                                }

                              });

                            }),

                            _buildTechSelectionCard("Serm", "MAINTENANCE", "assets/coupe_maint.jpg", Colors.green, isSelected: selectedTechs.contains("Serm"), isActive: true, onTap: () {

                              setDialogState(() {

                                if (selectedTechs.contains("Serm")) {

                                  selectedTechs.remove("Serm");

                                } else {

                                  selectedTechs.add("Serm");

                                }

                              });

                            }),

                          ],

                        ),

                      ),

                      if (selectedTechs.isNotEmpty) ...[

                        const SizedBox(height: 32),

                        _dialogLabel("Availability for selected technicians:"),

                        const SizedBox(height: 16),

                        ...selectedTechs.map((tech) {

                          String role = "AIR CONDITIONING";
                          if (tech == "Wichai") role = "ELECTRICAL";
                          if (tech == "Kong") role = "PLUMBING";
                          if (tech == "Keng") role = "MASONRY";
                          if (tech == "Grace") role = "PAINTING";
                          if (tech == "Pee") role = "SYSTEMS";
                          if (tech == "Serm") role = "MAINTENANCE";

                          return Padding(

                            padding: const EdgeInsets.only(bottom: 24),

                            child: _buildTechScheduleCalendar(tech, role, setDialogState, selectedTechs),

                          );

                        }),

                      ],

                      const SizedBox(height: 40),

                      Row(

                        children: [

                          Expanded(

                            child: TextButton(

                              onPressed: () => Navigator.pop(context),

                              style: TextButton.styleFrom(

                                backgroundColor: Colors.white.withOpacity(0.05),

                                padding: const EdgeInsets.symmetric(vertical: 18),

                                shape: RoundedRectangleBorder(

                                  borderRadius: BorderRadius.circular(12),

                                  side: const BorderSide(color: Colors.white10),

                                ),

                              ),

                              child: Text(

                                "CANCEL",

                                style: GoogleFonts.notoSans(

                                  color: Colors.white38,

                                  fontSize: 12,

                                  fontWeight: FontWeight.bold,

                                  letterSpacing: 1,

                                ),

                              ),

                            ),

                          ),

                          const SizedBox(width: 16),

                          Expanded(

                            child: ElevatedButton(

                              onPressed: () => Navigator.pop(context),

                              style: ElevatedButton.styleFrom(

                                backgroundColor: const Color(0xFFC5A059),

                                foregroundColor: Colors.black,

                                padding: const EdgeInsets.symmetric(vertical: 18),

                                elevation: 0,

                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

                              ),

                              child: Text(

                                "CONFIRM ASSIGNMENT",

                                style: GoogleFonts.notoSans(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1),

                              ),

                            ),

                          ),

                        ],

                      ),

                    ],

                  ),

                ),

              ),

            );

          },

        );

      },

    );

  }

  void _showAddJointTaskDialog(BuildContext context) {
    String selectedArea = "Select Area";
    List<String> selectedTechs = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: const Color(0xFF0D0D0D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: const Color(0xFFC5A059).withOpacity(0.2)),
              ),
              child: Container(
                width: 600,
                padding: const EdgeInsets.all(32),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "JOINT SERVICES: NEW ENTRY",
                                style: GoogleFonts.notoSans(
                                  color: const Color(0xFFC5A059),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Text(
                                "New Service Request",
                                style: GoogleFonts.notoSans(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: Colors.white38),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _dialogLabel("Problem Description / Subject"),
                      _dialogTextField("e.g. Broken tap, leaking pipe..."),
                      const SizedBox(height: 24),
                      _dialogLabel("Select Area"),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          border: Border.all(color: Colors.white10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: DropdownButtonHideUnderline(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                hoverColor: Colors.white.withOpacity(0.05),
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedArea,
                                dropdownColor: const Color(0xFF151515),
                                items: [
                                  "Select Area",
                                  "Club House",
                                  "Garden / Park",
                                  "Parking Lot",
                                  "Public Areas"
                                ].map((area) {
                                  return DropdownMenuItem(
                                    value: area,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(area, style: GoogleFonts.notoSans(color: Colors.white, fontSize: 13)),
                                    ),
                                  );
                                }).toList(),
                                selectedItemBuilder: (BuildContext context) {
                                  return [
                                    "Select Area",
                                    "Club House",
                                    "Garden / Park",
                                    "Parking Lot",
                                    "Public Areas"
                                  ].map((area) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        area,
                                        style: GoogleFonts.notoSans(color: Colors.white, fontSize: 13),
                                      ),
                                    );
                                  }).toList();
                                },
                                onChanged: (v) {
                                  if (v != null) {
                                    setDialogState(() => selectedArea = v);
                                  }
                                },
                                icon: const Padding(
                                  padding: EdgeInsets.only(right: 16),
                                  child: Icon(Icons.keyboard_arrow_down, color: Color(0xFFC5A059)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _dialogLabel("Additional Details"),
                      _dialogTextField("", maxLines: 3),
                      const SizedBox(height: 32),
                      _dialogLabel("Assign Technicians (Click to select/deselect)"),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.01),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildTechSelectionCard("Jib", "AIR CONDITIONING", "assets/jib_air.jpg", Colors.green, isSelected: selectedTechs.contains("Jib"), isActive: true, onTap: () {
                              setDialogState(() {
                                if (selectedTechs.contains("Jib")) {
                                  selectedTechs.remove("Jib");
                                } else {
                                  selectedTechs.add("Jib");
                                }
                              });
                            }),
                            _buildTechSelectionCard("Wichai", "ELECTRICAL", "assets/wichai_electric.jpg", Colors.green, isSelected: selectedTechs.contains("Wichai"), isActive: true, onTap: () {
                              setDialogState(() {
                                if (selectedTechs.contains("Wichai")) {
                                  selectedTechs.remove("Wichai");
                                } else {
                                  selectedTechs.add("Wichai");
                                }
                              });
                            }),
                            _buildTechSelectionCard("Kong", "PLUMBING", "assets/kong_plumbing.jpg", Colors.orange, isSelected: selectedTechs.contains("Kong"), isActive: false, onTap: () {
                              setDialogState(() {
                                if (selectedTechs.contains("Kong")) {
                                  selectedTechs.remove("Kong");
                                } else {
                                  selectedTechs.add("Kong");
                                }
                              });
                            }),
                            _buildTechSelectionCard("Keng", "MASONRY", "assets/jack_senior.jpg", Colors.green, isSelected: selectedTechs.contains("Keng"), isActive: true, onTap: () {
                              setDialogState(() {
                                if (selectedTechs.contains("Keng")) {
                                  selectedTechs.remove("Keng");
                                } else {
                                  selectedTechs.add("Keng");
                                }
                              });
                            }),
                            _buildTechSelectionCard("Grace", "PAINTING", "assets/grace_paint.jpg", Colors.green, isSelected: selectedTechs.contains("Grace"), isActive: true, onTap: () {
                              setDialogState(() {
                                if (selectedTechs.contains("Grace")) {
                                  selectedTechs.remove("Grace");
                                } else {
                                  selectedTechs.add("Grace");
                                }
                              });
                            }),
                            _buildTechSelectionCard("Pee", "SYSTEMS", "assets/prism_it.jpg", Colors.green, isSelected: selectedTechs.contains("Pee"), isActive: false, onTap: () {
                              setDialogState(() {
                                if (selectedTechs.contains("Pee")) {
                                  selectedTechs.remove("Pee");
                                } else {
                                  selectedTechs.add("Pee");
                                }
                              });
                            }),
                            _buildTechSelectionCard("Serm", "MAINTENANCE", "assets/coupe_maint.jpg", Colors.green, isSelected: selectedTechs.contains("Serm"), isActive: true, onTap: () {
                              setDialogState(() {
                                if (selectedTechs.contains("Serm")) {
                                  selectedTechs.remove("Serm");
                                } else {
                                  selectedTechs.add("Serm");
                                }
                              });
                            }),
                          ],
                        ),
                      ),
                      if (selectedTechs.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        ...selectedTechs.map((tech) {
                          String role = "AIR CONDITIONING";
                          if (tech == "Wichai") role = "ELECTRICAL";
                          if (tech == "Kong") role = "PLUMBING";
                          if (tech == "Keng") role = "MASONRY";
                          if (tech == "Grace") role = "PAINTING";
                          if (tech == "Pee") role = "SYSTEMS";
                          if (tech == "Serm") role = "MAINTENANCE";
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: _buildTechScheduleCalendar(tech, role, setDialogState, selectedTechs),
                          );
                        }),
                      ],
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.05),
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(color: Colors.white10),
                                ),
                              ),
                              child: Text(
                                "CANCEL",
                                style: GoogleFonts.notoSans(
                                  color: Colors.white38,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFC5A059),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 8,
                                shadowColor: const Color(0xFFC5A059).withOpacity(0.3),
                              ),
                              child: Text(
                                "CREATE TASK",
                                style: GoogleFonts.notoSans(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _dialogLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(

        text,

        style: GoogleFonts.notoSans(

          color: const Color(0xFFC5A059),

          fontSize: 11,

          fontWeight: FontWeight.w900,

          letterSpacing: 1,

        ),

      ),

    );

  }

  Widget _dialogTextField(String hint, {int maxLines = 1}) {

    return TextField(

      maxLines: maxLines,

      style: GoogleFonts.notoSans(color: Colors.white, fontSize: 14),

      decoration: InputDecoration(

        hintText: hint,

        hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),

        filled: true,

        fillColor: Colors.white.withOpacity(0.03),

        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

        border: OutlineInputBorder(

          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(color: Colors.white10),

        ),

        enabledBorder: OutlineInputBorder(

          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(color: Colors.white10),

        ),

        focusedBorder: OutlineInputBorder(

          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(color: Color(0xFFC5A059), width: 1.5),

        ),

      ),

    );

  }

  Widget _buildTechScheduleCalendar(String name, String role, StateSetter setDialogState, List<String> selectedTechs, {bool showDelete = true}) {

    // Unique Randomization for each tech

    final int seed = name.hashCode;

    return Container(

      padding: const EdgeInsets.all(28),

      decoration: BoxDecoration(

        color: const Color(0xFF151515), // Dark charcoal to match dashboard

        borderRadius: BorderRadius.circular(30),

        border: Border.all(color: const Color(0xFFC5A059).withOpacity(0.1)),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withOpacity(0.3),

            blurRadius: 20,

            offset: const Offset(0, 10),

          ),

        ],

      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Expanded(

                child: Row(

                  children: [

                    Container(

                      width: 12,

                      height: 12,

                      decoration: const BoxDecoration(

                        color: Color(0xFFC5A059),

                        shape: BoxShape.circle,

                      ),

                    ),

                    const SizedBox(width: 12),

                    Expanded(

                      child: Text(

                        "Schedule: $name ($role)",

                        style: GoogleFonts.notoSans(

                          color: const Color(0xFFC5A059),

                          fontSize: 15,

                          fontWeight: FontWeight.w900,

                        ),

                        overflow: TextOverflow.ellipsis,

                      ),

                    ),

                  ],

                ),

              ),

              if (showDelete)

                IconButton(

                  onPressed: () {

                    setDialogState(() => selectedTechs.remove(name));

                  },

                  icon: Icon(Icons.delete_outline, color: Colors.white.withOpacity(0.3), size: 24),

                  style: IconButton.styleFrom(

                    backgroundColor: Colors.white.withOpacity(0.05),

                    padding: const EdgeInsets.all(8),

                  ),

                ),

            ],

          ),

          const SizedBox(height: 20),

          Center(

            child: Text(

              "February 2026",

              style: GoogleFonts.notoSans(

                color: Colors.white,

                fontSize: 16,

                fontWeight: FontWeight.w900,

              ),

            ),

          ),

          const SizedBox(height: 20),

          // Day Labels

          Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"].map((day) {

              return Expanded(

                child: Center(

                  child: Text(

                    day,

                    style: GoogleFonts.notoSans(

                      color: const Color(0xFFB2BEC3),

                      fontSize: 12,

                      fontWeight: FontWeight.w600,

                    ),

                  ),

                ),

              );

            }).toList(),

          ),

          const SizedBox(height: 12),

          // Calendar Grid (February 2026 starts on Sunday)
          SizedBox(
            height: 250, // Fixed height to prevent layout calculation heavy loops
            child: GridView.builder(
              shrinkWrap: false, // Better performance with fixed height container

            physics: const NeverScrollableScrollPhysics(),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(

              crossAxisCount: 7,

              mainAxisSpacing: 10,

              crossAxisSpacing: 10,

              childAspectRatio: 1.1,

            ),

            itemCount: 28,

            itemBuilder: (context, index) {

              int day = index + 1;

              // Technician-specific busy days (for "not synchronized" feel)

              bool isBusy = false;

              bool doubleDot = false;

              // Create a deterministic "pseudo-random" feel based on technician name

              final int seed = name.hashCode;

              final List<int> busyDays;

              if (name == "Wichai") {
                busyDays = [12, 13, 18, 25];
              } else if (name == "Kong") {
                busyDays = [5, 11, 12, 14, 15, 22];
                doubleDot = (day == 12 || day == 15);
              } else if (name == "Keng") {
                busyDays = [3, 9, 20, 21];
              } else if (name == "Jib") {
                busyDays = [8, 16, 21, 28];
              } else if (name == "Grace") {
                busyDays = [4, 10, 17, 24];
              } else if (name == "Pee") {
                busyDays = [6, 14, 19, 27];
              } else if (name == "Serm") {
                busyDays = [2, 7, 15, 23];
                doubleDot = (day == 7 || day == 23);
              } else {

                // Fallback randomization

                busyDays = [(seed % 28) + 1, ((seed * 3) % 28) + 1, ((seed * 7) % 28) + 1];

              }

              isBusy = busyDays.contains(day);

              bool isSelectedDate = (day == 14); // Primary task date across all

              return Container(

                decoration: BoxDecoration(

                  color: isSelectedDate 

                      ? const Color(0xFFC5A059).withOpacity(0.15)

                      : (isBusy ? const Color(0xFFFF5252).withOpacity(0.05) : Colors.white.withOpacity(0.02)),

                  borderRadius: BorderRadius.circular(12),

                  border: Border.all(

                    color: isSelectedDate 

                      ? const Color(0xFFC5A059)

                      : (isBusy ? const Color(0xFFFF5252).withOpacity(0.2) : Colors.transparent),

                    width: isSelectedDate ? 1.5 : 1,

                  ),

                ),

                child: Stack(

                  alignment: Alignment.center,

                  children: [

                    Text(

                      "$day",

                      style: GoogleFonts.notoSans(

                        color: isBusy 

                            ? const Color(0xFFFF5252).withOpacity(0.8) 

                            : (isSelectedDate ? const Color(0xFFC5A059) : Colors.white),

                        fontSize: 14,

                        fontWeight: FontWeight.w800,

                      ),

                    ),

                    if (isBusy)

                      Positioned(

                        bottom: 6,

                        child: Row(

                          mainAxisSize: MainAxisSize.min,

                          children: [

                            Container(

                              width: 4,

                              height: 4,

                              decoration: BoxDecoration(

                                color: const Color(0xFFFF5252), 

                                shape: BoxShape.circle,

                                boxShadow: [

                                  BoxShadow(

                                    color: const Color(0xFFFF5252).withOpacity(0.5),

                                    blurRadius: 4,

                                    spreadRadius: 1,

                                  ),

                                ],

                              ),

                            ),

                            if (doubleDot) ...[

                              const SizedBox(width: 3),

                              Container(

                                width: 4,

                                height: 4,

                                decoration: BoxDecoration(

                                  color: const Color(0xFFFF5252), 

                                  shape: BoxShape.circle,

                                  boxShadow: [

                                    BoxShadow(

                                      color: const Color(0xFFFF5252).withOpacity(0.5),

                                      blurRadius: 4,

                                      spreadRadius: 1,

                                    ),

                                  ],

                                ),

                              ),

                            ],

                          ],

                        ),

                      ),

                  ],

                ),

              );

            },
          ),
        ),
        const SizedBox(height: 16),

          // Legend

          Row(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              _buildCalendarLegend(const Color(0xFFFF5252), "Busy"),

              const SizedBox(width: 16),

              _buildCalendarLegend(Colors.white, "Available"),

              const SizedBox(width: 16),

              _buildCalendarLegend(const Color(0xFFC5A059), "Selected"),

            ],

          ),

        ],

      ),

    );

  }

  Widget _buildCalendarLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: retroAmber.withOpacity(0.3)),
          ),
        ),
        const SizedBox(width: 8),
        _terminalText(label, fontSize: 10),
      ],
    );
  }

  Widget _buildTechSelectionCard(String name, String status, String image, Color statusColor, {required bool isSelected, required bool isActive, required VoidCallback onTap}) {
    final Color neonGreen = const Color(0xFF00FF9F);
    // Offline banner should ALWAYS be muted gray, regardless of hover
    final Color bannerColor = isActive ? neonGreen : const Color(0xFF212121).withOpacity(0.8);
    
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setCardState) {
        // Visual interaction allowed for everyone, but colors vary
        final bool showVisualInteraction = isHovered || isSelected;

        return MouseRegion(
          onEnter: (_) => setCardState(() => isHovered = true),
          onExit: (_) => setCardState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: showVisualInteraction ? 1.08 : 1.0,
            child: GestureDetector(
              onTap: onTap, 
              child: Container(
                width: 140,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    color: showVisualInteraction 
                        ? (isActive ? neonGreen : Colors.white30) 
                        : (isActive ? neonGreen.withOpacity(0.5) : Colors.white10),
                    width: showVisualInteraction ? 2.5 : 1.5,
                  ),
                  boxShadow: (showVisualInteraction) ? [
                    BoxShadow(
                      color: (isActive ? neonGreen : Colors.white).withOpacity(showVisualInteraction ? (isActive ? 0.4 : 0.1) : 0.05),
                      blurRadius: showVisualInteraction ? 15 : 10,
                      spreadRadius: showVisualInteraction ? 2 : 0,
                    )
                  ] : null,
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        // Banner color NEVER turns green if offline even on hover/selection
                        color: showVisualInteraction && isActive ? neonGreen : bannerColor,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            isActive ? "ACTIVE" : "OFFLINE",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.shareTechMono(
                              color: (showVisualInteraction && isActive) ? Colors.black : Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              right: 8,
                              child: Icon(Icons.check_circle, color: isActive ? Colors.black : Colors.white, size: 14),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ColorFiltered(
                        colorFilter: isActive
                            ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                            : const ColorFilter.matrix([
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0,      0,      0,      1, 0,
                              ]),
                        child: Opacity(
                          opacity: isActive ? 1.0 : (showVisualInteraction ? 0.6 : 0.4),
                          child: Image.asset(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.black,
                      child: Text(
                        name.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.shareTechMono(
                          color: isActive ? (showVisualInteraction ? Colors.white : Colors.white70) : (showVisualInteraction ? Colors.white60 : Colors.white30),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Modern Service Request Helpers (Image 2 Style) ---

  Widget _buildMetricCard({required String label, required Widget child, required IconData icon, required Color color}) {
    return Expanded(
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05), // Increased opacity for readability without blur
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: color.withOpacity(0.25), // Themed Frame border
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 15,
              spreadRadius: 2,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: GoogleFonts.notoSans(
                    color: color.withOpacity(0.7), // Colored label
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                Icon(icon, color: color.withOpacity(0.8), size: 18),
              ],
            ),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsView() {
    return Container(
      color: const Color(0xFF0A0A0A),
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER SECTION ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _terminalText("SYS.SYSTEM // ANALYTICS CONTROL", fontSize: 10, color: const Color(0xFFC5A059).withOpacity(0.5), letterSpacing: 2),
                  const SizedBox(height: 12),
                  Text(
                    "Command Center",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFFC5A059).withOpacity(0.15), Colors.transparent],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFC5A059).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_graph_rounded, color: Color(0xFFC5A059), size: 18),
                    const SizedBox(width: 12),
                    Text("LIVE ENGINE / ACTIVE", style: GoogleFonts.shareTechMono(color: const Color(0xFFC5A059), fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),

          // --- MASTER HUD: REQUEST LIFECYCLE ---
          Row(
            children: [
              _buildMiniSummaryStat("GLOBAL VOLUME", "4,281", Icons.analytics_rounded, const Color(0xFFC5A059)),
              const SizedBox(width: 20),
              _buildMiniSummaryStat("ACTIVE WORKLOAD", "154", Icons.pending_actions_rounded, const Color(0xFF00FF9F)),
              const SizedBox(width: 20),
              _buildMiniSummaryStat("TOTAL RESOLVED", "3,912", Icons.task_alt_rounded, const Color(0xFF6366F1)),
            ],
          ),
          const SizedBox(height: 40),

          // --- DIVERSE ANALYTIC GRID ---
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 28,
              mainAxisSpacing: 28,
              childAspectRatio: 1.8,
              children: [
                // 1. LINEAR PERFORMANCE
                _buildStatModule(
                  title: "SUCCESS CONTRACT RATE",
                  subtitle: "PLATFORM EFFICIENCY: 94.2%",
                  icon: Icons.track_changes_rounded,
                  color: const Color(0xFF00FF9F),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("94.2%", style: GoogleFonts.outfit(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: 0.942,
                          backgroundColor: Colors.white.withOpacity(0.05),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00FF9F)),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. DONUT CHART (Service Breakdown)
                _buildStatDonutChart(
                  title: "SERVICE CATEGORY LOAD",
                  subtitle: "RESOURCE DISTRIBUTION %",
                  categories: {
                    "LEGAL": 40,
                    "MAINTENANCE": 35,
                    "SECURITY": 25,
                  },
                  baseColor: const Color(0xFFC5A059),
                ),

                // 3. LINE TREND (Visitor Traffic)
                _buildStatLineChart(
                  title: "VISITOR ACCESS TREND",
                  subtitle: "REAL-TIME TRAFFIC FLOW",
                  values: [20, 50, 45, 90, 70, 85, 100],
                  color: const Color(0xFFF72585),
                ),

                // 4. CIRCULAR INDEX
                _buildStatModule(
                  title: "VILLAGE STABILITY",
                  subtitle: "SECURE STATUS // 95%",
                  icon: Icons.shield_rounded,
                  color: const Color(0xFF6366F1),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 70, height: 70,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: 0.95,
                              strokeWidth: 6,
                              backgroundColor: Colors.white.withOpacity(0.05),
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                            ),
                            Text("95%", style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Text("SAFE ZONE", style: GoogleFonts.outfit(color: const Color(0xFF6366F1), fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),

                // 5. BAR TREND (Response)
                _buildStatChartCard(
                  title: "RESPONSE EFFICIENCY",
                  subtitle: "WEEKLY TEAM PERFORMANCE",
                  values: [55, 70, 65, 85, 80, 95, 90],
                  color: const Color(0xFF00FF9F),
                ),

                // 6. MONTHLY COMPARISON (This vs Last)
                _buildStatCompareChart(
                  title: "PERFORMANCE DELTA",
                  subtitle: "ACTUAL VS PREVIOUS PERIOD",
                  thisMonth: [80, 95, 70, 85, 90],
                  lastMonth: [70, 80, 75, 60, 85],
                  color: const Color(0xFFC5A059),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatModule({required String title, required String subtitle, required IconData icon, required Color color, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.01),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.03),
            blurRadius: 30,
            spreadRadius: -10,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F0F).withOpacity(0.95),
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.12),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _terminalText(title, fontSize: 13, fontWeight: FontWeight.w900, color: color.withOpacity(0.9), letterSpacing: 1.2),
                    const SizedBox(height: 6),
                    _terminalText(subtitle, fontSize: 10, color: Colors.white38, fontWeight: FontWeight.bold),
                  ],
                ),
                Icon(icon, color: color.withOpacity(0.8), size: 20),
              ],
            ),
            const Spacer(),
            child,
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _terminalText("ANALYTIC_NODE_0", fontSize: 9, color: Colors.white12),
                _terminalText("SYNC // ENCRYPTED", fontSize: 9, color: color.withOpacity(0.3), fontWeight: FontWeight.bold),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniSummaryStat(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _terminalText(label, fontSize: 9, color: Colors.white38, fontWeight: FontWeight.bold),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.shareTechMono(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChartCard({required String title, required String subtitle, required List<double> values, required Color color}) {
    return _buildStatModule(
      title: title,
      subtitle: subtitle,
      icon: Icons.bar_chart_rounded,
      color: color,
      child: SizedBox(
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: values.asMap().entries.map((entry) {
            final int idx = entry.key;
            final double v = entry.value;
            final double maxValue = values.reduce(max);
            final double normalizedHeight = (v / maxValue) * 70;
            final bool isLast = idx == values.length - 1;

            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: normalizedHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color.withOpacity(isLast ? 0.8 : 0.4),
                      color.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6), bottom: Radius.circular(2)),
                  boxShadow: isLast ? [
                    BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, spreadRadius: -2),
                  ] : [],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatDonutChart({required String title, required String subtitle, required Map<String, double> categories, required Color baseColor}) {
    return _buildStatModule(
      title: title,
      subtitle: subtitle,
      icon: Icons.pie_chart_rounded,
      color: baseColor,
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 0.7, // Visual placeholder for the main sector
                  strokeWidth: 10,
                  backgroundColor: Colors.white.withOpacity(0.05),
                  valueColor: AlwaysStoppedAnimation<Color>(baseColor),
                ),
                CircularProgressIndicator(
                  value: 0.4, // Second sector
                  strokeWidth: 10,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(baseColor.withOpacity(0.3)),
                ),
                Text(
                  "${categories.values.reduce((a, b) => a + b).toInt()}%",
                  style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: categories.entries.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: baseColor.withOpacity(0.8), shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _terminalText(e.key, fontSize: 10, color: Colors.white70),
                    ),
                    _terminalText("${e.value.toInt()}%", fontSize: 10, color: Colors.white38),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatLineChart({required String title, required String subtitle, required List<double> values, required Color color}) {
    return _buildStatModule(
      title: title,
      subtitle: subtitle,
      icon: Icons.show_chart_rounded,
      color: color,
      child: SizedBox(
        height: 80,
        child: Stack(
          children: [
            // Simplified "Line" using points and connecting lines (Container based for simplicity)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: values.map((v) {
                final double maxValue = values.reduce(max);
                final double normalizedHeight = (v / maxValue) * 60;
                return Container(
                  width: 8,
                  height: normalizedHeight,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }).toList(),
            ),
            // Custom Paint for a proper smooth line would be better, but this fits the "Cyber" style
            Positioned.fill(
              child: Opacity(
                opacity: 0.5,
                child: CustomPaint(
                  painter: _LineChartPainter(values: values, color: color),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCompareChart({required String title, required String subtitle, required List<double> thisMonth, required List<double> lastMonth, required Color color}) {
    return _buildStatModule(
      title: title,
      subtitle: subtitle,
      icon: Icons.compare_arrows_rounded,
      color: color,
      child: SizedBox(
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(thisMonth.length, (i) {
            final double v1 = thisMonth[i];
            final double v2 = lastMonth[i];
            final double maxV = [...thisMonth, ...lastMonth].reduce(max);
            
            return Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      height: (v1 / maxV) * 75,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 8)],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      height: (v2 / maxV) * 75,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildModernTab(String label, String count, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFC5A059) : Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? const Color(0xFFC5A059).withOpacity(0.5) : Colors.white.withOpacity(0.05),
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.notoSans(
                color: isActive ? Colors.black : Colors.white38,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isActive ? Colors.black.withOpacity(0.1) : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                count,
                style: GoogleFonts.shareTechMono(
                  color: isActive ? Colors.black : Colors.white24,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          _tableHeaderCell("# ID", flex: 1),
          _tableHeaderCell("Issue / Technical Detail", flex: 4),
          _tableHeaderCell("Unit / House", flex: 2),
          _tableHeaderCell("Requester", flex: 2),
          _tableHeaderCell("Date Reported", flex: 2),
          _tableHeaderCell("Status", flex: 2),
        ],
      ),
    );
  }

  Widget _tableHeaderCell(String label, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.shareTechMono(
          color: Colors.white24,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildModernTableRow(Map<String, dynamic> task) {
    final String status = task['status'] as String;
    
    // Exact colors from Juristic V5.0 Reference
    Color statusColor;
    Color statusBg;
    if (status == 'DONE') {
      statusColor = const Color(0xFF00FF9F);
      statusBg = const Color(0xFF00FF9F).withOpacity(0.08);
    } else if (status == 'WORKING') {
      statusColor = const Color(0xFFFFB000); // Retro Amber
      statusBg = const Color(0xFFFFB000).withOpacity(0.08);
    } else if (status == 'DENIED') {
      statusColor = const Color(0xFFFF4D4D);
      statusBg = const Color(0xFFFF4D4D).withOpacity(0.08);
    } else {
      // PENDING
      statusColor = const Color(0xFFFF4D4D).withOpacity(0.9);
      statusBg = const Color(0xFFFF4D4D).withOpacity(0.05);
    }
    
    return InkWell(
      onTap: () => _showTaskControlCenter(context, task),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.01),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.02)),
        ),
        child: Row(
          children: [
            // ID Column
            Expanded(
              flex: 1,
              child: Text(
                "#${task['id'] ?? (1000 + _random.nextInt(8999))}",
                style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 13, letterSpacing: 0.5),
              ),
            ),
            // Issue / Technical Detail
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC5A059).withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(task['icon'] as IconData, color: const Color(0xFFC5A059), size: 16),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    task['title'] as String,
                    style: GoogleFonts.notoSans(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // House
            Expanded(
              flex: 2,
              child: Text(
                task['house'] as String,
                style: GoogleFonts.notoSans(color: Colors.white70, fontSize: 13),
              ),
            ),
            // Requester
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white.withOpacity(0.05),
                    child: Text(
                      (task['requester'] as String)[0],
                      style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    task['requester'] as String,
                    style: GoogleFonts.notoSans(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            // Date
            Expanded(
              flex: 2,
              child: Text(
                task['date'] as String,
                style: GoogleFonts.notoSans(color: Colors.white38, fontSize: 12),
              ),
            ),
            // Status Button
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withOpacity(0.2)),
                ),
                child: Center(
                  child: Text(
                    status,
                    style: GoogleFonts.shareTechMono(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
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

// --- Hover Expanding Sidebar ---
class _HoverSidebar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final VoidCallback onLogout;

  const _HoverSidebar({
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.onLogout,
  });

  @override
  State<_HoverSidebar> createState() => _HoverSidebarState();
}

class _HoverSidebarState extends State<_HoverSidebar> with SingleTickerProviderStateMixin {
  late AnimationController _ac;
  late Animation<double> _width;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _width = Tween<double>(begin: 80, end: 260).animate(CurvedAnimation(parent: _ac, curve: Curves.easeInOutCubic));
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ac, curve: const Interval(0.4, 1.0, curve: Curves.easeOut)));
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _ac.forward(),
      onExit: (_) => _ac.reverse(),
      child: AnimatedBuilder(
        animation: _ac,
        builder: (context, child) {
          final double currentWidth = _width.value;
          final double expansion = _ac.value;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: currentWidth,
            height: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D0D),
              border: Border(right: BorderSide(color: Colors.white.withOpacity(0.04))),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(4, 0)),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 40),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Center(
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFC5A059).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(child: Icon(Icons.security_rounded, color: Color(0xFFC5A059))),
                        ),
                      ),
                    ),
                    ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: expansion,
                        child: SizedBox(
                          width: 180,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "FCM PLATFORM",
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFFC5A059),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ),
                              Text(
                                "ENTERPRISE QUALITY MANAGEMENT",
                                style: GoogleFonts.notoSans(
                                  color: Colors.white60,
                                  fontSize: 7,
                                  letterSpacing: 0.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
                const SizedBox(height: 60),
                _navItem(0, Icons.dashboard_rounded, "OVERVIEW", expansion),
                _navItem(1, Icons.assignment_rounded, "REQUESTS", expansion),
                _navItem(2, Icons.engineering_rounded, "STAFF", expansion),
                _navItem(4, Icons.person_rounded, "ACCOUNT", expansion),
                _navItem(5, Icons.analytics_rounded, "ANALYTICS", expansion),
                _navItem(3, Icons.settings_rounded, "SETTINGS", expansion),
                const Spacer(),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _logoutBtn(expansion),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label, double expansion) {
    bool isSelected = widget.selectedIndex == index;
    return InkWell(
      onTap: () => widget.onIndexChanged(index),
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC5A059).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: [
              SizedBox(
                width: 80 - 16,
                child: Center(
                  child: Icon(icon, color: isSelected ? const Color(0xFFC5A059) : Colors.white24, size: 20),
                ),
              ),
              ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: expansion,
                  child: SizedBox(
                    width: 160,
                    child: Text(
                      label,
                      style: GoogleFonts.notoSans(
                        color: isSelected ? Colors.white : Colors.white24,
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoutBtn(double expansion) {
    return InkWell(
      onTap: widget.onLogout,
      child: Container(
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            children: [
              SizedBox(
                width: 80 - 16,
                child: const Center(
                  child: Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                ),
              ),
              ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: expansion,
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      "LOGOUT",
                      style: GoogleFonts.shareTechMono(
                        color: Colors.redAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final Color color;

  _LineChartPainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final path = Path();
    final double stepX = size.width / (values.length - 1);
    final double maxValue = values.reduce(max);

    for (int i = 0; i < values.length; i++) {
      final double x = i * stepX;
      final double y = size.height - (values[i] / maxValue) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
    
    // Fill under path
    final fillPath = Path();
    fillPath.moveTo(0, size.height);
    for (int i = 0; i < values.length; i++) {
      final double x = i * stepX;
      final double y = size.height - (values[i] / maxValue) * size.height;
      fillPath.lineTo(x, y);
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();
      
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.2), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class RadarChartPainter extends CustomPainter {
  final Map<String, double> stats;
  final Color color;

  RadarChartPainter({required this.stats, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = min(centerX, centerY) * 0.8;
    final angleStep = (2 * pi) / 5;

    final axisPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final List<Offset> points = [];
    final keys = ['Technical', 'Speed', 'Reliability', 'Force', 'Versatility'];

    // Draw background grid (Pentagons)
    for (var i = 1; i <= 4; i++) {
      final polyPath = Path();
      final currentRadius = radius * (i / 4);
      for (var j = 0; j < 5; j++) {
        final angle = j * angleStep - pi / 2;
        final x = centerX + currentRadius * cos(angle);
        final y = centerY + currentRadius * sin(angle);
        if (j == 0) polyPath.moveTo(x, y);
        else polyPath.lineTo(x, y);
      }
      polyPath.close();
      canvas.drawPath(polyPath, axisPaint);
    }

    // Draw axes
    for (var j = 0; j < 5; j++) {
      final angle = j * angleStep - pi / 2;
      canvas.drawLine(Offset(centerX, centerY), Offset(centerX + radius * cos(angle), centerY + radius * sin(angle)), axisPaint);
    }

    // Draw stat polygon
    final statPath = Path();
    for (var j = 0; j < 5; j++) {
      final angle = j * angleStep - pi / 2;
      final val = stats[keys[j]] ?? 0.5;
      final x = centerX + radius * val * cos(angle);
      final y = centerY + radius * val * sin(angle);
      points.add(Offset(x, y));
      if (j == 0) statPath.moveTo(x, y);
      else statPath.lineTo(x, y);
    }
    statPath.close();

    canvas.drawPath(statPath, fillPaint);
    canvas.drawPath(statPath, borderPaint);

    // Draw points
    for (var point in points) {
      canvas.drawCircle(point, 3, Paint()..color = color);
      canvas.drawCircle(point, 6, Paint()..color = color.withOpacity(0.2));
    }
  }

  @override
  bool shouldRepaint(covariant RadarChartPainter oldDelegate) {
    return oldDelegate.stats != stats || oldDelegate.color != color;
  }
}
