import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/technician_card.dart';
import '../widgets/village_map_widget.dart';

class LegalDashboardScreen extends StatefulWidget {
  const LegalDashboardScreen({super.key});
  @override
  State<LegalDashboardScreen> createState() => _LegalDashboardScreenState();
}

class _LegalDashboardScreenState extends State<LegalDashboardScreen> {
  int _selectedIndex = 0;
  final Random _random = Random();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Full-screen map content (no sidebar in the Row)
          Positioned.fill(
            child: Stack(
              fit: StackFit.expand,
              children: [
                const Positioned.fill(child: VillageMapWidget()),
                // Gradient overlays
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 160,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xCC000000), Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 160,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Color(0xCC000000), Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                ),
                // HUD Layer
                SafeArea(
                  child: Stack(
                    children: [
                      Positioned(
                          top: 0,
                          left: 80,
                          right: 0,
                          bottom: 0,
                          child: _buildCurrentView()),
                      Positioned(
                          top: 0, left: 80, right: 0, child: _buildHeader()),
                      if (_selectedIndex == 0)
                        Positioned(
                          top: 80,
                          left: 80,
                          right: 0,
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 800),
                              child: _buildStatsGrid(),
                            ),
                          ),
                        ),
                      if (_selectedIndex == 0) _buildBottomPanel(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Sidebar — own StatefulWidget, hover doesn't rebuild the map
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            child: _HoverSidebar(
              selectedIndex: _selectedIndex,
              onIndexChanged: (index) => setState(() => _selectedIndex = index),
              onLogout: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentView() {
    if (_selectedIndex == 0)
      return const SizedBox.shrink(); // Map is always visible behind

    return Container(
      color: const Color(0xFF0A0A0A), // Opaque background for other views
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
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 100, 24),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D0D).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 3, height: 14, color: const Color(0xFFC5A059)),
                const SizedBox(width: 10),
                Text(
                  "��า�ที��ำลั���ิ�ัติห��าที�",
                  style: GoogleFonts.notoSans(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTechnicianBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(
          child: _GlassStatCard(
            label: "ทั��หมด",
            value: "42",
            icon: Icons.analytics_outlined,
            accentColor: const Color(0xFFC5A059),
            onTap: () {
              setState(() {
                _taskFilter = "ALL";
                _selectedIndex = 1;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _GlassStatCard(
            label: "รออ�ุมัติ",
            value: "8",
            icon: Icons.pending_actions,
            accentColor: const Color(0xFFFFD700),
            onTap: () {
              setState(() {
                _taskFilter = "PENDING";
                _selectedIndex = 1;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _GlassStatCard(
            label: "�ำลั�ดำเ�ิ��าร",
            value: "15",
            icon: Icons.engineering_outlined,
            accentColor: const Color(0xFF00FF9F),
            onTap: () {
              setState(() {
                _taskFilter = "WORKING";
                _selectedIndex = 1;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _GlassStatCard(
            label: "ช่างเสริม",
            value: "19",
            icon: Icons.check_circle_outline,
            accentColor: Colors.white,
            onTap: () {
              setState(() {
                _taskFilter = "DONE";
                _selectedIndex = 1;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivities() {
    final activities = [
      {
        "title": "������อมหลั��า",
        "subtitle": "��า� 123/45 | 10 �าทีที��ล�ว",
        "color": const Color(0xFFC5A059)
      },
      {
        "title": "ช่างวิชัย",
        "subtitle": "��า� 102/12 | 1 �ม. ที��ล�ว",
        "color": const Color(0xFF00FF9F)
      },
      {
        "title": "ช่างเสริม",
        "subtitle": "��า� 105/9 | 2 �ม. ที��ล�ว",
        "color": Colors.white38
      },
      {
        "title": "������อมอ�า�ล�า�ห��า",
        "subtitle": "��า� 110/3 | 4 �ม. ที��ล�ว",
        "color": const Color(0xFFC5A059)
      },
    ];
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.04)),
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
                "�ิ��รรมล�าสุด",
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
                          color: (item['color'] as Color).withValues(alpha: 0.4),
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
                        Text(item['title'] as String,
                            style: GoogleFonts.notoSans(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(item['subtitle'] as String,
                            style: GoogleFonts.notoSans(
                                color: Colors.white30, fontSize: 10)),
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
                color: Colors.white.withValues(alpha: 0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Center(
                child: Text(
                  "ดู�ระวัติทั��หมด ��",
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
      {
        "status": "PENDING",
        "title": "ท�อ��ำระเ�ีย�อุดตั�",
        "house": "123/45",
        "requester": "�ุณสม�าย",
        "date": "11 �.�. 2569",
        "icon": Icons.water_drop
      },
      {
        "status": "PENDING",
        "title": "�ลั������ั��วม�หม�",
        "house": "105/9",
        "requester": "�ุณว�ิดา",
        "date": "11 �.�. 2569",
        "icon": Icons.bolt
      },
      {
        "status": "WORKING",
        "title": "หลอด��ทา�เดิ��าด",
        "house": "102/12",
        "requester": "�ุณวิ�ิตร",
        "date": "10 �.�. 2569",
        "icon": Icons.lightbulb
      },
      {
        "status": "DONE",
        "title": "��อ���ำห�อ���ำรั�ว",
        "house": "105/9",
        "requester": "�ุณวิภา",
        "date": "10 �.�. 2569",
        "icon": Icons.water_drop
      },
      {
        "status": "WORKING",
        "title": "เ�รื�อ�ทำ��ำอุ���ม�ร�อ�",
        "house": "110/3",
        "requester": "�ุณเ���า",
        "date": "09 �.�. 2569",
        "icon": Icons.thermostat
      },
      {
        "status": "WORKING",
        "title": "ท�อ��ำทิ��รั�ว�ต��ิ���",
        "house": "108/2",
        "requester": "�ุณอมรเท�",
        "date": "11 �.�. 2569",
        "icon": Icons.water_drop
      },
    ];
    final filteredTasks = _taskFilter == "ALL"
        ? allTasks
        : allTasks.where((t) => t['status'] == _taskFilter).toList();
    return Container(
      color: const Color(0xFF0D0D0D),
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ตรว�สอ��ละอ�ุมัติราย�าร������อม�า�ลู���า�ทั��หมด",
                    style: GoogleFonts.notoSans(
                        color: Colors.white38, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "�ัด�ารราย�าร������อม",
                    style: GoogleFonts.notoSans(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              // Search Bar
              Container(
                width: 320,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: "���หา��า�เล�ที� หรือหัว��อ...",
                    hintStyle: const TextStyle(color: Colors.white24),
                    icon: const Icon(Icons.search,
                        color: Color(0xFFC5A059), size: 18),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Filtering Tabs with Counts and Action Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFilterTabs(),
              ElevatedButton.icon(
                onPressed: () => _showAddJointTaskDialog(context),
                icon: const Icon(Icons.add, size: 16),
                label: Text("�า�ส�ว��ลา�",
                    style: GoogleFonts.notoSans(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC5A059),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                return _taskListItem(filteredTasks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskListItem(Map<String, dynamic> task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFC5A059).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(task['icon'] as IconData,
                color: const Color(0xFFC5A059), size: 24),
          ),
          const SizedBox(width: 20),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task['title'] as String,
                    style: GoogleFonts.notoSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  "��า�เล�ที� ${task['house']} | �����ดย ${task['requester']} | ${task['date']}",
                  style:
                      GoogleFonts.notoSans(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
          // Actions based on status
          _buildTaskActions(task),
        ],
      ),
    );
  }

  Widget _buildTaskActions(Map<String, dynamic> task) {
    final String status = task['status'] as String;
    if (status == "PENDING") {
      return Row(
        children: [
          TextButton(
            onPressed: () => _showRejectTaskDialog(context, task),
            child: Text("ช่างเสริม",
                style: GoogleFonts.notoSans(
                    color: const Color(0xFFFF4D4D),
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => _showApproveAssignDialog(context, task),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC5A059),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Text("อ�ุมัติ & มอ�หมาย",
                style: GoogleFonts.notoSans(
                    fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      );
    } else if (status == "WORKING") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("ช่างวิชัย",
              style: GoogleFonts.notoSans(color: Colors.white38, fontSize: 11)),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Text("ดู�วาม�ื�ห��า",
                style: GoogleFonts.notoSans(color: Colors.white, fontSize: 11)),
          ),
        ],
      );
    } else {
      // DONE
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF00FF9F).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("ช่างเสริม",
                style: GoogleFonts.notoSans(
                    color: const Color(0xFF00FF9F),
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.star, color: Color(0xFFFFD700), size: 14),
              Icon(Icons.star, color: Color(0xFFFFD700), size: 14),
              Icon(Icons.star, color: Color(0xFFFFD700), size: 14),
              Icon(Icons.star, color: Color(0xFFFFD700), size: 14),
              Icon(Icons.star, color: Color(0xFFFFD700), size: 14),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildFilterTabs() {
    final filters = [
      {"label": "ทั��หมด", "count": 6, "id": "ALL"},
      {"label": "รออ�ุมัติ", "count": 2, "id": "PENDING"},
      {"label": "�ำลั�ดำเ�ิ��าร", "count": 3, "id": "WORKING"},
      {"label": "ช่างเสริม", "count": 1, "id": "DONE"},
    ];

    return Row(
      children: filters.map((f) {
        final bool isActive = _taskFilter == f['id'];
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: InkWell(
            onTap: () => setState(() => _taskFilter = f['id'] as String),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${f['label']} (${f['count']})"ช่างวิชัย"MANAGEMENT: STAFF REGISTRY",
            style: GoogleFonts.notoSans(
                color: const Color(0xFFC5A059),
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5),
          ),
          Text(
            "ราย�ื�อทีม��า�เท��ิ�",
            style: GoogleFonts.notoSans(
                color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.3,
              ),
              itemCount: technicians.length,
              itemBuilder: (context, index) {
                final tech = technicians[index];
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151515),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFC5A059).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: AssetImage(tech['image']!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tech['name']!,
                                  style: GoogleFonts.notoSans(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Text(tech['id']!,
                                  style: GoogleFonts.notoSans(
                                      color: Colors.white24, fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        tech['role']!,
                        style: GoogleFonts.notoSans(
                            color: const Color(0xFFC5A059),
                            fontSize: 10,
                            fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              _techStat("JOBS", "12"),
                              const SizedBox(width: 24),
                              _techStat("RATING", "4.8"),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => _showIndividualScheduleDialog(
                                context, tech['name']!, tech['role']!),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFC5A059).withValues(alpha: 0.1),
                              foregroundColor: const Color(0xFFC5A059),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: const Color(0xFFC5A059)
                                        .withValues(alpha: 0.3)),
                              ),
                            ),
                            child: Text(
                              "ดูตารา��า�",
                              style: GoogleFonts.notoSans(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _techStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.notoSans(
                color: Colors.white24,
                fontSize: 8,
                fontWeight: FontWeight.w900)),
        Text(value,
            style: GoogleFonts.notoSans(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildProfileView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "MANAGEMENT: PROFILE SETTINGS",
            style: GoogleFonts.notoSans(
                color: const Color(0xFFC5A059),
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5),
          ),
          Text(
            "��ร��ล��ิติ�ร",
            style: GoogleFonts.notoSans(
                color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
          ),
          Text(
            "�ัด�าร��อมูลส�ว�ตัว�อ��ู�ดู�ล��ร��าร",
            style: GoogleFonts.notoSans(color: Colors.white38, fontSize: 14),
          ),
          const SizedBox(height: 40),
          Center(
            child: Container(
              width: 700,
              padding: const EdgeInsets.all(48),
              decoration: BoxDecoration(
                color: const Color(0xFF151515),
                borderRadius: BorderRadius.circular(24),
                border:
                    Border.all(color: const Color(0xFFC5A059).withValues(alpha: 0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar Section
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xFFC5A059).withValues(alpha: 0.5),
                          width: 2),
                      color: const Color(0xFF0D0D0D),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF151515),
                        image: const DecorationImage(
                          image: AssetImage(
                              'assets/prism_it.jpg'), // Mocked profile pic
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Admin Zeta",
                    style: GoogleFonts.notoSans(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    "�ู��ัด�าร��ร��าร�ิติ�ุ��ล (Juristic Person)",
                    style: GoogleFonts.notoSans(
                      color: const Color(0xFFC5A059),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Info Rows
                  _profileInfoRow("�ื�อ-�ามส�ุล", "Admin Zeta"),
                  _profileInfoRow("ตำ�ห���", "�ู��ัด�าร�ิติ�ุ��ล"),
                  _profileInfoRow("เ�อร��ทรศั�ท�", "080-000-0000",
                      actionText: "�����",
                      onTap: () => _showEditProfileDialog(
                          context, "เ�อร��ทรศั�ท�", "080-000-0000")),
                  _profileInfoRow("อีเมล", "admin@gmail.com",
                      actionText: "�����",
                      onTap: () => _showEditProfileDialog(
                          context, "อีเมล", "admin@gmail.com")),
                  _profileInfoRow("รหัส��า�", "********",
                      actionText: "เ�ลี�ย�รหัส",
                      onTap: () =>
                          _showEditProfileDialog(context, "รหัส��า�", "")),

                  const SizedBox(height: 48),

                  // Logout Button
                  InkWell(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4D4D).withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFFFF4D4D).withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.logout_rounded,
                              color: Color(0xFFFF4D4D), size: 18),
                          const SizedBox(width: 12),
                          Text(
                            "ออ��า�ระ�� (Admin)",
                            style: GoogleFonts.notoSans(
                              color: const Color(0xFFFF4D4D),
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
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

  void _showEditProfileDialog(
      BuildContext context, String label, String currentValue) {
    final TextEditingController controller =
        TextEditingController(text: label == "รหัส��า�" ? "" : currentValue);
    final bool isPassword = label == "รหัส��า�";
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF0D0D0D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: const Color(0xFFC5A059).withValues(alpha: 0.2)),
          ),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPassword ? "เ�ลี�ย�รหัส��า�" : "�����$label",
                  style: GoogleFonts.notoSans(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 24),
                _dialogLabel(isPassword ? "��อมูลเดิม: $label" : label),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  obscureText: isPassword,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "�รุณาระ�ุ$label�หม�...",
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.15)),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.02),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.white.withValues(alpha: 0.1)),
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
                        child: Text("ย�เลิ�",
                            style: GoogleFonts.notoSans(color: Colors.white38)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC5A059),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text("�ั�ทึ���อมูล",
                            style: GoogleFonts.notoSans(
                                fontWeight: FontWeight.bold)),
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

  Widget _profileInfoRow(String label, String value,
      {String? actionText, VoidCallback? onTap}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
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
                      color: const Color(
                          0xFF5991C5), // Blue link color from screenshot
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
            style: GoogleFonts.notoSans(
                color: const Color(0xFFC5A059),
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5),
          ),
          Text(
            "ตั����าระ���ัด�าร",
            style: GoogleFonts.notoSans(
                color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 32),
          _settingsRow(
              "DARK MODE", "เ�ิด����า��หมดมืด (ระ����ะ�ำ)", true),
          _settingsRow(
              "PUSH NOTIFICATIONS",
              "รัารเตือเมือมีวามืหาาอม",
              true),
          _settingsRow("AUTO-ASSIGN",
              "มอหมายาหอัตมัติเมือาวา", false),
          _settingsRow("LANGUAGE", "ภาษาไทย (THAI)", false),
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
                    _dialogLabel("ช่างเสริม"),
                    const SizedBox(height: 12),
                    TextField(
                      controller: reasonController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText:
                            "ระ�ุเหตุ�ลเ�ื�อ�ห�ลู���า�ทรา� . . .",
                        hintStyle:
                            TextStyle(color: Colors.white.withValues(alpha: 0.15)),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.02),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              const BorderSide(color: Color(0xFFFF4D4D)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _dialogLabel("เลือ��า��ม����:"),
                    const SizedBox(height: 12),
                    _rejectTemplateButton(
                      Icon(Icons.close_rounded,
                          color: Colors.red.withValues(alpha: 0.8), size: 18),
                      "�อ��วามรั��ิด�อ���ร��าร",
                      () => setDialogState(() => reasonController.text =
                          "�า��ี�อยู��อ�เห�ือ�อ�เ�ต�วามรั��ิด�อ��อ���ร��าร"),
                    ),
                    const SizedBox(height: 12),
                    _rejectTemplateButton(
                      Icon(Icons.warning_amber_rounded,
                          color: Colors.orange.withValues(alpha: 0.8), size: 18),
                      "อุ��รณ���ติ/����า��ิด�ระเภท",
                      () => setDialogState(() => reasonController.text =
                          "�า��ารตรว�สอ�เ�ื�อ�ต�� อุ��รณ�ยั�ทำ�า���ติ หรืออา�มี�าร����า��ิด�ระเภท"),
                    ),
                    const SizedBox(height: 12),
                    _rejectTemplateButton(
                      Icon(Icons.edit_note_rounded,
                          color: Colors.blue.withValues(alpha: 0.8), size: 18),
                      "��อมูล�ม��ัดเ��",
                      () => setDialogState(() => reasonController.text =
                          "��อมูล�าร������อม�ม�เ�ีย��อ �รุณาระ�ุรายละเอียดหรือ���รู�ภา�เ�ิ�มเติม"),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withValues(alpha: 0.05),
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.white10),
                              ),
                            ),
                            child: Text(
                              "ย�เลิ�",
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
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              "ช่างเสริม",
                              style: GoogleFonts.notoSans(
                                  fontSize: 14, fontWeight: FontWeight.w900),
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
          color: Colors.white.withValues(alpha: 0.04),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
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

  void _showIndividualScheduleDialog(
      BuildContext context, String name, String role) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: const Color(0xFF0D0D0D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side:
                    BorderSide(color: const Color(0xFFC5A059).withValues(alpha: 0.2)),
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
                              "ตรว�สอ�ตารา��า�",
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
                    _buildTechScheduleCalendar(
                        name, role, setDialogState, [name],
                        showDelete: false),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFC5A059),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          "CLOSE / �ิด",
                          style: GoogleFonts.notoSans(
                              fontWeight: FontWeight.w900, letterSpacing: 1),
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

  void _showApproveAssignDialog(
      BuildContext context, Map<String, dynamic> task) {
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
                side:
                    BorderSide(color: const Color(0xFFC5A059).withValues(alpha: 0.2)),
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
                                "มอ�หมาย�า���า�",
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
                            icon:
                                const Icon(Icons.close, color: Colors.white38),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.01),
                          border:
                              Border.all(color: Colors.white.withValues(alpha: 0.05)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC5A059).withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.calendar_today,
                                  color: Color(0xFFC5A059), size: 18),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("วั�ที�ลู���า�สะดว�:",
                                    style: GoogleFonts.notoSans(
                                        color: Colors.white38, fontSize: 11)),
                                Text(
                                  "15 �ุมภา�ั��� 2569", // Mocked date as per screenshot
                                  style: GoogleFonts.notoSans(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      _dialogLabel(
                          "เลือ���า�ที��ะมอ�หมาย (�ลิ�ที��าร�ดเ�ื�อเลือ�)"),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.01),
                          border:
                              Border.all(color: Colors.white.withValues(alpha: 0.05)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildTechSelectionCard(
                                "ช่างวิชัย",
                                "ระ������า",
                                "assets/wichai_electric.jpg",
                                Colors.green,
                                selectedTechs.contains("ช่างวิชัย"), () {
                              setDialogState(() {
                                if (selectedTechs.contains("ช่างวิชัย")) {
                                  selectedTechs.remove("ช่างวิชัย");
                                } else {
                                  selectedTechs.add("ช่างวิชัย");
                                }
                              });
                            }),
                            _buildTechSelectionCard(
                                "��า���อ�",
                                "ระ���ระ�า",
                                "assets/kong_plumbing.jpg",
                                Colors.orange,
                                selectedTechs.contains("��า���อ�"), () {
                              setDialogState(() {
                                if (selectedTechs.contains("��า���อ�")) {
                                  selectedTechs.remove("��า���อ�");
                                } else {
                                  selectedTechs.add("��า���อ�");
                                }
                              });
                            }),
                            _buildTechSelectionCard(
                                "��า�����",
                                "�า���ร�สร�า�",
                                "assets/jack_senior.jpg",
                                Colors.green,
                                selectedTechs.contains("��า�����"), () {
                              setDialogState(() {
                                if (selectedTechs.contains("��า�����")) {
                                  selectedTechs.remove("��า�����");
                                } else {
                                  selectedTechs.add("��า�����");
                                }
                              });
                            }),
                            _buildTechSelectionCard(
                                "��า��ิ��",
                                "ระบบแอร์",
                                "assets/jib_air.jpg",
                                Colors.green,
                                selectedTechs.contains("��า��ิ��"), () {
                              setDialogState(() {
                                if (selectedTechs.contains("��า��ิ��")) {
                                  selectedTechs.remove("��า��ิ��");
                                } else {
                                  selectedTechs.add("��า��ิ��");
                                }
                              });
                            }),
                            _buildTechSelectionCard(
                                "��า�เ�ร�",
                                "�า�สี / ต��ต��",
                                "assets/grace_paint.jpg",
                                Colors.green,
                                selectedTechs.contains("��า�เ�ร�"), () {
                              setDialogState(() {
                                if (selectedTechs.contains("��า�เ�ร�")) {
                                  selectedTechs.remove("��า�เ�ร�");
                                } else {
                                  selectedTechs.add("��า�เ�ร�");
                                }
                              });
                            }),
                            _buildTechSelectionCard(
                                "��า��ี",
                                "ระบบ IT",
                                "assets/prism_it.jpg",
                                Colors.green,
                                selectedTechs.contains("��า��ี"), () {
                              setDialogState(() {
                                if (selectedTechs.contains("��า��ี")) {
                                  selectedTechs.remove("��า��ี");
                                } else {
                                  selectedTechs.add("��า��ี");
                                }
                              });
                            }),
                            _buildTechSelectionCard(
                                "ช่างเสริม",
                                "ซ่อมบำรุ",
                                "assets/coupe_maint.jpg",
                                Colors.green,
                                selectedTechs.contains("ช่างเสริม"), () {
                              setDialogState(() {
                                if (selectedTechs.contains("ช่างเสริม")) {
                                  selectedTechs.remove("ช่างเสริม");
                                } else {
                                  selectedTechs.add("ช่างเสริม");
                                }
                              });
                            }),
                          ],
                        ),
                      ),
                      if (selectedTechs.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        _dialogLabel(
                            "ตรว�สอ��วาม�ร�อม�อ���า�ที�เลือ�:"),
                        const SizedBox(height: 16),
                        ...selectedTechs.map((tech) {
                          String role = "ระบบแอร์";
                          if (tech == "ช่างวิชัย") role = "ระบบไฟฟ้า";
                          if (tech == "ช่างก้อง") role = "ระบบประปา";
                          if (tech == "ช่างเก่ง") role = "งานโครงสร้าง";
                          if (tech == "ช่างจิ๊บ") role = "ระบบแอร์";
                          if (tech == "ช่างเกรซ") role = "งานสี / ตกแต่ง";
                          if (tech == "ช่างพี") role = "ระบบ IT";
                          if (tech == "ช่างเสริม") role = "ซ่อมบำรุง";
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: _buildTechScheduleCalendar(
                                tech, role, setDialogState, selectedTechs),
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
                                backgroundColor: Colors.white.withValues(alpha: 0.05),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(color: Colors.white10),
                                ),
                              ),
                              child: Text(
                                "CANCEL / ย�เลิ�",
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                "CONFIRM ASSIGNMENT",
                                style: GoogleFonts.notoSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1),
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
    String selectedArea = "สว�สา�ารณะ";
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
                side:
                    BorderSide(color: const Color(0xFFC5A059).withValues(alpha: 0.2)),
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
                                "เ�ิ�ม�า���อมส�ว��ลา�",
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
                            icon:
                                const Icon(Icons.close, color: Colors.white38),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _dialogLabel("�ื�อราย�าร / สิ��ที�ต�อ���อม"),
                      _dialogTextField(
                          "เ��� ��อม��ส�าม, ล�า�สระว�าย��ำ"),
                      const SizedBox(height: 24),
                      _dialogLabel("�ื��ที�ส�ว��ลา�"),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.03),
                          border: Border.all(color: Colors.white10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: DropdownButtonHideUnderline(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                hoverColor: Colors.white.withValues(alpha: 0.05),
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedArea,
                                dropdownColor: const Color(0xFF151515),
                                items: [
                                  "สว�สา�ารณะ",
                                  "ส�มสร / ยิม",
                                  "สระว�าย��ำ",
                                  "��อมยาม / ทา�เ��า",
                                  "����าส�ว��ลา�"
                                ].map((area) {
                                  return DropdownMenuItem(
                                    value: area,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Text(area,
                                          style: GoogleFonts.notoSans(
                                              color: Colors.white,
                                              fontSize: 13)),
                                    ),
                                  );
                                }).toList(),
                                selectedItemBuilder: (BuildContext context) {
                                  return [
                                    "สว�สา�ารณะ",
                                    "ส�มสร / ยิม",
                                    "สระว�าย��ำ",
                                    "��อมยาม / ทา�เ��า",
                                    "����าส�ว��ลา�"
                                  ].map((area) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        area,
                                        style: GoogleFonts.notoSans(
                                            color: Colors.white, fontSize: 13),
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
                                  child: Icon(Icons.keyboard_arrow_down,
                                      color: Color(0xFFC5A059)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _dialogLabel("รายละเอียดเ�ิ�มเติม"),
                      _dialogTextField("", maxLines: 3),
                      const SizedBox(height: 32),
                      _dialogLabel(
                          "เลือ���า��ละตรว�สอ�ตารา��า� (�ลิ�ที��าร�ดเ�ื�อเลือ�)"),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.01),
                          border:
                              Border.all(color: Colors.white.withValues(alpha: 0.05)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildTechSelectionCard(
                                "��า��ิ��",
                                "ระบบแอร์",
                                "assets/jib_air.jpg",
                                Colors.green,
                                selectedTechs.contains("��า��ิ��"), () {
                              setDialogState(() {
                                if (selectedTechs.contains("��า��ิ��")) {
                                  selectedTechs.remove("��า��ิ��");
                                } else {
                                  selectedTechs.add("��า��ิ��");
                                }
                              });
                            }),
                            _buildTechSelectionCard(
                                "ช่างวิชัย",
                                "ระ������า",
                                "assets/wichai_electric.jpg",
                                Colors.green,
                                selectedTechs.contains("ช่างวิชัย"), () {
                              setDialogState(() {
                                if (selectedTechs.contains("ช่างวิชัย")) {
                                  selectedTechs.remove("ช่างวิชัย");
                                } else {
                                  selectedTechs.add("ช่างวิชัย");
                                }
                              });
                            }),
                            _buildTechSelectionCard(
                                "��า���อ�",
                                "ระ���ระ�า",
                                "assets/kong_plumbing.jpg",
                                Colors.orange,
                                selectedTechs.contains("��า���อ�"), () {
                              setDialogState(() {
                                if (selectedTechs.contains("��า���อ�")) {
                                  selectedTechs.remove("��า���อ�");
                                } else {
                                  selectedTechs.add("��า���อ�");
                                }
                              });
                            }),
                            _buildTechSelectionCard(
                                "��า�����",
                                "�า���ร�สร�า�",
                                "assets/jack_senior.jpg",
                                Colors.green,
                                selectedTechs.contains("��า�����"), () {
                              setDialogState(() {
                                if (selectedTechs.contains("��า�����")) {
                                  selectedTechs.remove("��า�����");
                                } else {
                                  selectedTechs.add("��า�����");
                                }
                              });
                            }),
                            _buildTechSelectionCard(
                                "��า�เ�ร�",
                                "�า�สี / ต��ต��",
                                "assets/grace_paint.jpg",
                                Colors.green,
                                selectedTechs.contains("��า�เ�ร�"), () {
                              setDialogState(() {
                                if (selectedTechs.contains("��า�เ�ร�")) {
                                  selectedTechs.remove("��า�เ�ร�");
                                } else {
                                  selectedTechs.add("��า�เ�ร�");
                                }
                              });
                            }),
                            _buildTechSelectionCard(
                                "��า��ี",
                                "ระบบ IT",
                                "assets/prism_it.jpg",
                                Colors.green,
                                selectedTechs.contains("��า��ี"), () {
                              setDialogState(() {
                                if (selectedTechs.contains("��า��ี")) {
                                  selectedTechs.remove("��า��ี");
                                } else {
                                  selectedTechs.add("��า��ี");
                                }
                              });
                            }),
                            _buildTechSelectionCard(
                                "ช่างเสริม",
                                "ซ่อมบำรุ",
                                "assets/coupe_maint.jpg",
                                Colors.green,
                                selectedTechs.contains("ช่างเสริม"), () {
                              setDialogState(() {
                                if (selectedTechs.contains("ช่างเสริม")) {
                                  selectedTechs.remove("ช่างเสริม");
                                } else {
                                  selectedTechs.add("ช่างเสริม");
                                }
                              });
                            }),
                          ],
                        ),
                      ),
                      if (selectedTechs.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        ...selectedTechs.map((tech) {
                          String role = "ระบบแอร์";
                          if (tech == "ช่างวิชัย") role = "ระบบไฟฟ้า";
                          if (tech == "ช่างก้อง") role = "ระบบประปา";
                          if (tech == "ช่างเก่ง") role = "งานโครงสร้าง";
                          if (tech == "ช่างจิ๊บ") role = "ระบบแอร์";
                          if (tech == "ช่างเกรซ") role = "งานสี / ตกแต่ง";
                          if (tech == "ช่างพี") role = "ระบบ IT";
                          if (tech == "ช่างเสริม") role = "ซ่อมบำรุง";
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: _buildTechScheduleCalendar(
                                tech, role, setDialogState, selectedTechs),
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
                                backgroundColor: Colors.white.withValues(alpha: 0.05),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(color: Colors.white10),
                                ),
                              ),
                              child: Text(
                                "CANCEL / ย�เลิ�",
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 8,
                                shadowColor:
                                    const Color(0xFFC5A059).withValues(alpha: 0.3),
                              ),
                              child: Text(
                                "CREATE TASK / สร�า�ราย�าร",
                                style: GoogleFonts.notoSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
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
        fillColor: Colors.white.withValues(alpha: 0.03),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

  Widget _buildTechScheduleCalendar(String name, String role,
      StateSetter setDialogState, List<String> selectedTechs,
      {bool showDelete = true}) {
    // Unique Randomization for each tech
    final int seed = name.hashCode;
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF151515), // Dark charcoal to match dashboard
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFC5A059).withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
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
                        "ตารา��า�: $name ($role)",
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
                  icon: Icon(Icons.delete_outline,
                      color: Colors.white.withValues(alpha: 0.3), size: 24),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                    padding: const EdgeInsets.all(8),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              "�ุมภา�ั��� 2569",
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
            children: ["อา", "�", "อ", "�", "�ฤ", "ศ", "ส"].map((day) {
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
          GridView.builder(
            shrinkWrap: true,
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

              if (name == "ช่างวิชัย") {
                busyDays = [12, 13, 18, 25];
              } else if (name == "ช่างก้อง") {
                busyDays = [5, 11, 12, 14, 15, 22];
                doubleDot = (day == 12 || day == 15);
              } else if (name == "ช่างเก่ง") {
                busyDays = [3, 9, 20, 21];
              } else if (name == "ช่างจิ๊บ") {
                busyDays = [8, 16, 21, 28];
              } else if (name == "ช่างเกรซ") {
                busyDays = [4, 10, 17, 24];
              } else if (name == "ช่างพี") {
                busyDays = [6, 14, 19, 27];
              } else if (name == "ช่างเสริม") {
                busyDays = [2, 7, 15, 23];
                doubleDot = (day == 7 || day == 23);
              } else {
                // Fallback randomization
                busyDays = [
                  (seed % 28) + 1,
                  ((seed * 3) % 28) + 1,
                  ((seed * 7) % 28) + 1
                ];
              }

              isBusy = busyDays.contains(day);
              bool isSelectedDate = (day == 14); // Primary task date across all

              return Container(
                decoration: BoxDecoration(
                  color: isSelectedDate
                      ? const Color(0xFFC5A059).withValues(alpha: 0.15)
                      : (isBusy
                          ? const Color(0xFFFF5252).withValues(alpha: 0.05)
                          : Colors.white.withValues(alpha: 0.02)),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelectedDate
                        ? const Color(0xFFC5A059)
                        : (isBusy
                            ? const Color(0xFFFF5252).withValues(alpha: 0.2)
                            : Colors.transparent),
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
                            ? const Color(0xFFFF5252).withValues(alpha: 0.8)
                            : (isSelectedDate
                                ? const Color(0xFFC5A059)
                                : Colors.white),
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
                                    color: const Color(0xFFFF5252)
                                        .withValues(alpha: 0.5),
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
                                      color: const Color(0xFFFF5252)
                                          .withValues(alpha: 0.5),
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
          const SizedBox(height: 16),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCalendarLegend(const Color(0xFFFF5252), "มี�า�"),
              const SizedBox(width: 16),
              _buildCalendarLegend(Colors.white, "ว�า�"),
              const SizedBox(width: 16),
              _buildCalendarLegend(const Color(0xFFC5A059), "วั��ัด/เลือ�"),
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
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.notoSans(
              color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTechSelectionCard(String name, String role, String image,
      Color statusColor, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 105,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFC5A059).withValues(alpha: 0.1)
              : const Color(0xFF151515),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFC5A059)
                : Colors.white.withValues(alpha: 0.05),
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC5A059).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: const Color(0xFFC5A059).withValues(alpha: 0.2)),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: isSelected
                              ? const Color(0xFF1A1A1A)
                              : const Color(0xFF151515),
                          width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: GoogleFonts.notoSans(
                color: isSelected ? const Color(0xFFC5A059) : Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              role,
              style: GoogleFonts.notoSans(
                color: isSelected
                    ? const Color(0xFFC5A059).withValues(alpha: 0.7)
                    : Colors.white38,
                fontSize: 8,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassStatCard extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;
  const _GlassStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });
  @override
  State<_GlassStatCard> createState() => _GlassStatCardState();
}

class _GlassStatCardState extends State<_GlassStatCard> {
  bool _isHovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color:
                _isHovering ? const Color(0xFF151515) : const Color(0xFF0D0D0D),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovering
                  ? widget.accentColor.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.06),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color:
                      widget.accentColor.withValues(alpha: _isHovering ? 0.15 : 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.accentColor.withValues(alpha: _isHovering ? 1 : 0.7),
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.label,
                      style: GoogleFonts.notoSans(
                        color: Colors.white38,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      widget.value,
                      style: GoogleFonts.notoSans(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
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

// ─── Extracted Sidebar Widget ─────────────────────────────────────────
// Has its own State so hover setState only rebuilds the sidebar,
// NOT the heavy VillageMapWidget or HUD layers.
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

class _HoverSidebarState extends State<_HoverSidebar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ac;
  late final Animation<double> _width;
  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;
  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      duration: const Duration(milliseconds: 280),
      vsync: this,
    );
    _width = Tween<double>(begin: 80, end: 260).animate(
      CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic),
    );
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _ac,
        curve: const Interval(0.35, 1.0, curve: Curves.easeIn),
      ),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(-0.2, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _ac,
        curve: const Interval(0.25, 1.0, curve: Curves.easeOutCubic),
      ),
    );
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
          return Container(
            width: _width.value,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D0D),
              border: Border(
                right: BorderSide(
                  color: const Color(0xFFC5A059).withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5 * _ac.value),
                  blurRadius: 24 * _ac.value,
                  offset: Offset(4 * _ac.value, 0),
                ),
              ],
            ),
            child: child,
          );
        },
        child: OverflowBox(
          maxWidth: 260,
          minWidth: 260,
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 260,
            child: Column(
              children: [
                const SizedBox(height: 24),
                // ── Logo ──
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC5A059).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.shield_rounded,
                            color: Color(0xFFC5A059), size: 24),
                      ),
                      const SizedBox(width: 12),
                      SlideTransition(
                        position: _textSlide,
                        child: FadeTransition(
                          opacity: _textOpacity,
                          child: Column(
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
                                '�к��Ѵ��çҹ�������ا�ç���',
                                style: GoogleFonts.notoSans(
                                  color: const Color(0xFFC5A059),
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // ── Section: ������เมนูหลัก ──
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textOpacity,
                    child: _sectionLabel('������เมนูหลัก'),
                  ),
                ),
                _navItem(Icons.grid_view_rounded, 'ภาพรวม����', 0),
                _navItem(Icons.assignment_outlined, '�Ѵ��çҹ����', 1),
                _navItem(Icons.people_outline, '��ª��ͪ�ҧ', 2),
                const SizedBox(height: 20),
                // ── Section: �к��͹��� ──
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textOpacity,
                    child: _sectionLabel('�к��͹���'),
                  ),
                ),
                _navItem(Icons.person_outline, '�����', 4),
                _navItem(Icons.settings_outlined, '��การตั้งค่า��', 3),
                const Spacer(),
                // ── Logout ──
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: InkWell(
                    onTap: widget.onLogout,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF4D4D).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.logout_rounded,
                              color: Color(0xFFFF4D4D), size: 20),
                          const SizedBox(width: 12),
                          SlideTransition(
                            position: _textSlide,
                            child: FadeTransition(
                              opacity: _textOpacity,
                              child: Text(
                                '�͡�ҡ�к�',
                                style: GoogleFonts.notoSans(
                                  color: const Color(0xFFFF4D4D),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String title, int index) {
    final bool isActive = widget.selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: () => widget.onIndexChanged(index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFFC5A059).withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isActive
                ? Border.all(color: const Color(0xFFC5A059).withValues(alpha: 0.3))
                : null,
          ),
          child: Row(
            children: [
              Icon(icon,
                  color: isActive ? const Color(0xFFC5A059) : Colors.white54,
                  size: 20),
              const SizedBox(width: 12),
              SlideTransition(
                position: _textSlide,
                child: FadeTransition(
                  opacity: _textOpacity,
                  child: Text(
                    title,
                    style: GoogleFonts.notoSans(
                      color: isActive ? Colors.white : Colors.white54,
                      fontSize: 14,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
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

  Widget _sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 24, 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.notoSans(
            color: const Color(0xFFC5A059).withValues(alpha: 0.5),
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
