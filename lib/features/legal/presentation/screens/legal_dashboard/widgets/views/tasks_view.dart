import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fcm_app/features/legal/presentation/screens/legal_dashboard/widgets/data/dashboard_data.dart';
import 'package:fcm_app/features/legal/presentation/screens/legal_dashboard/widgets/shared/dashboard_stats_widgets.dart';
import 'package:fcm_app/features/legal/presentation/screens/legal_dashboard/widgets/shared/dashboard_ui_utils.dart';
import 'package:fcm_app/features/legal/presentation/screens/legal_dashboard/widgets/shared/dashboard_theme.dart';
import 'package:fcm_app/features/legal/presentation/widgets/technician_card.dart';
import 'package:fcm_app/features/legal/presentation/screens/legal_dashboard/widgets/shared/personnel_dossier_overlay.dart';
import 'package:fcm_app/features/legal/presentation/screens/legal_dashboard/widgets/shared/task_assignment_overlay.dart';
import 'dart:async';


class TasksView extends StatefulWidget {
  final List<Map<String, dynamic>> technicians;
  final Function(int) onIndexChanged;

  const TasksView({
    super.key,
    required this.technicians,
    required this.onIndexChanged,
  });

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  String _taskFilter = "ALL";
  Map<String, dynamic>? _selectedTask;
  Map<String, dynamic>? _selectedTech;
  List<String> _draftStaffNames = [];
  
  late Timer _urgentTimer;
  int _urgentIndex = 0;

  @override
  void initState() {
    super.initState();
    _urgentTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _urgentIndex++;
        });
      }
    });
  }

  @override
  void dispose() {
    _urgentTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allTasks = DashboardData.tasks;

    final int totalCount = allTasks.length;
    final int urgentCount = allTasks.where((t) => t['status'] == "URGENT").length;
    final int pendingCount = allTasks.where((t) => t['status'] == "PENDING").length;
    final int workingCount = allTasks.where((t) => t['status'] == "WORKING").length;
    final int doneCount = allTasks.where((t) => t['status'] == "DONE").length;
    final int deniedCount = allTasks.where((t) => t['status'] == "DENIED").length;

    const int totalHouses = 120;
    final activeIssueHouses = allTasks
        .where((t) => t['status'] != "DONE")
        .map((t) => t['house'] as String)
        .toSet()
        .length;
    final double healthScore = ((totalHouses - activeIssueHouses) / totalHouses) * 100;

    final urgentTasks = allTasks.where((t) => t['status'] == "URGENT").toList();
    final criticalTask = urgentTasks.isNotEmpty 
        ? urgentTasks[_urgentIndex % urgentTasks.length]
        : allTasks.firstWhere(
            (t) => t['status'] == "PENDING" && (t['icon'] == Icons.bolt || t['icon'] == Icons.water_drop),
            orElse: () => allTasks.firstWhere((t) => t['status'] != "DONE", orElse: () => allTasks[0]),
          );

    final filteredTasks = _taskFilter == "ALL" 
        ? allTasks 
        : allTasks.where((t) => t['status'] == _taskFilter).toList();

    return Container(
      color: DashboardTheme.background,
      child: Stack(
        children: [
          Column(
            children: [
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
                        terminalText("SYS.ADMIN // SERVICE REQUEST AUDIT", fontSize: 10, color: DashboardTheme.primary.withOpacity(0.5), letterSpacing: 1.5),
                        const SizedBox(height: 12),
                        Text(
                          "Service Requests",
                          style: GoogleFonts.notoSans(
                            color: DashboardTheme.textMain,
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
                            color: DashboardTheme.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: DashboardTheme.border),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: TextField(
                            style: GoogleFonts.notoSans(color: DashboardTheme.textMain, fontSize: 13),
                            cursorColor: DashboardTheme.primary,
                            decoration: InputDecoration(
                              hintText: "Search requests, ID or unit...",
                              hintStyle: GoogleFonts.notoSans(color: DashboardTheme.textPale),
                              prefixIcon: Icon(Icons.search_rounded, color: DashboardTheme.textPale, size: 20),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 11),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  children: [
                    MetricCard(
                      label: "Success Rate",
                      icon: Icons.track_changes_rounded,
                      color: DashboardTheme.success,
                      onTap: () {
                        final allTasks = DashboardData.tasks;
                        final doneCount = allTasks.where((t) => t['status'] == "DONE").length;
                        final totalHistorical = 4281;
                        final resolvedHistorical = 4127;
                        final globalVolumeTotal = totalHistorical + allTasks.length;
                        final resolvedTotal = resolvedHistorical + doneCount;
                        final successRate = (resolvedTotal / globalVolumeTotal);

                        showDashboardOverlay(
                          context: context,
                          title: "SUCCESS RATE",
                          subtitle: "LIFETIME RESOLUTION DELTA",
                          icon: Icons.track_changes_rounded,
                          color: DashboardTheme.primary,
                          content: DashboardStatsWidgets.buildSuccessExpanded(context, successRate),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("94.2%", style: GoogleFonts.notoSans(color: DashboardTheme.textMain, fontSize: 24, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: 0.942,
                              backgroundColor: DashboardTheme.border,
                              valueColor: AlwaysStoppedAnimation<Color>(DashboardTheme.success),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    MetricCard(
                      label: "Village Health",
                      icon: Icons.shield_rounded,
                      color: DashboardTheme.primary,
                      onTap: () {
                        final allTasks = DashboardData.tasks;
                        final urgentCount = allTasks.where((t) => t['status'] == "URGENT").length;
                        final pendingCount = allTasks.where((t) => t['status'] == "PENDING").length;
                        final workingCount = allTasks.where((t) => t['status'] == "WORKING").length;
                        final healthScore = (100 - (urgentCount * 5 + pendingCount * 2 + workingCount * 1)).clamp(0, 100).toDouble();

                        showDashboardOverlay(
                          context: context,
                          title: "VILLAGE HEALTH",
                          subtitle: "STRUCTURAL & SYSTEM INTEGRITY",
                          icon: Icons.shield_rounded,
                          color: DashboardTheme.primary,
                          content: DashboardStatsWidgets.buildHealthExpanded(context, healthScore, urgentCount, pendingCount),
                        );
                      },
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
                                  backgroundColor: DashboardTheme.border,
                                  valueColor: AlwaysStoppedAnimation<Color>(DashboardTheme.primary),
                                ),
                                Text("${healthScore.toInt()}%", style: GoogleFonts.shareTechMono(color: DashboardTheme.textMain, fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text("Safe Zone", style: GoogleFonts.notoSans(color: DashboardTheme.primary.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    MetricCard(
                      label: "Critical Focus",
                      icon: Icons.notification_important_rounded,
                      color: DashboardTheme.error,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Container(
                          key: ValueKey<String>("${criticalTask['id']}"),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: DashboardTheme.error.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: DashboardTheme.error.withOpacity(0.1)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: DashboardTheme.error, size: 18),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("RESIDENT ${criticalTask['house']}", style: GoogleFonts.shareTechMono(color: DashboardTheme.textMain, fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text(criticalTask['title'] as String, style: GoogleFonts.notoSans(color: DashboardTheme.error.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    MetricCard(
                      label: "User Ratings",
                      icon: Icons.star_rate_rounded,
                      color: DashboardTheme.accentAmber,
                      onTap: () => showDashboardOverlay(
                        context: context,
                        title: "USER SATISFACTION",
                        subtitle: "RESIDENT FEEDBACK AVG",
                        icon: Icons.star_rounded,
                        color: DashboardTheme.accentAmber,
                        content: DashboardStatsWidgets.buildRatingExpanded(context, DashboardData.calculatedAvgRating),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              final currentRating = DashboardData.calculatedAvgRating;
                              return Icon(
                                index < currentRating.floor() ? Icons.star_rounded : (index < currentRating ? Icons.star_half_rounded : Icons.star_outline_rounded),
                                color: DashboardTheme.accentAmber,
                                size: 20,
                              );
                            }),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${DashboardData.calculatedAvgRating.toStringAsFixed(1)} / 5.0", 
                            style: GoogleFonts.notoSans(color: DashboardTheme.textMain, fontSize: 18, fontWeight: FontWeight.w800)
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => widget.onIndexChanged(5),
                        borderRadius: BorderRadius.circular(20),
                        hoverColor: DashboardTheme.primary.withOpacity(0.04),
                        child: Ink(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: DashboardTheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: DashboardTheme.border),
                            boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_forward_rounded, color: DashboardTheme.primary),
                              const SizedBox(height: 8),
                              terminalText("FULL\nSTATS", fontSize: 10, fontWeight: FontWeight.bold, color: DashboardTheme.primary),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: DashboardTheme.surface,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(32)),
                border: Border(
                  top: BorderSide(color: DashboardTheme.border),
                  right: BorderSide(color: DashboardTheme.border),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 40,
                    offset: const Offset(0, -10),
                  )
                ],
              ),
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: DashboardTheme.background,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: DashboardTheme.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildModernTab("All", "$totalCount", _taskFilter == "ALL", () => setState(() => _taskFilter = "ALL")),
                            _buildModernTab("Urgent", "$urgentCount", _taskFilter == "URGENT", () => setState(() => _taskFilter = "URGENT")),
                            _buildModernTab("Pending", "$pendingCount", _taskFilter == "PENDING", () => setState(() => _taskFilter = "PENDING")),
                            _buildModernTab("Working", "$workingCount", _taskFilter == "WORKING", () => setState(() => _taskFilter = "WORKING")),
                            _buildModernTab("Completed", "$doneCount", _taskFilter == "DONE", () => setState(() => _taskFilter = "DONE")),
                            _buildModernTab("Denied", "$deniedCount", _taskFilter == "DENIED", () => setState(() => _taskFilter = "DENIED")),
                          ],
                        ),
                      ),
                      ],
                    ),
                  const SizedBox(height: 40),
                  _buildTableHeader(),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: filteredTasks.length,
                      separatorBuilder: (_, __) => Divider(color: DashboardTheme.border, height: 1), 
                      itemBuilder: (context, index) => _buildModernTableRow(filteredTasks[index]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
          
      // --- SHARED OVERLAYS (DRAGGED FROM OVERVIEW) ---
          
          // 1. PERSONNEL DOSSIER
          if (_selectedTech != null)
            Positioned.fill(
              child: PersonnelDossierOverlay(
                technician: _selectedTech!,
                onDismiss: () => setState(() => _selectedTech = null),
              ),
            ),

          // 2. TASK ASSIGNMENT HUD
          if (_selectedTask != null)
            Positioned.fill(
              child: TaskAssignmentOverlay(
                task: _selectedTask!,
                draftStaffNames: _draftStaffNames,
                onDismiss: () => setState(() {
                  _selectedTask = null;
                  _draftStaffNames = [];
                }),
                onConfirm: () {
                  if (_draftStaffNames.isNotEmpty) {
                    _selectedTask!['staffNames'] = List<String>.from(_draftStaffNames);
                  }
                  setState(() {
                    _selectedTask = null;
                    _draftStaffNames = [];
                  });
                },
                onAbort: () => setState(() {
                  _selectedTask = null;
                  _draftStaffNames = [];
                }),
              ),
            ),

          // 3. TECHNICIAN ROW (BOTTOM DOCK)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _selectedTask != null || _selectedTech != null ? 1.0 : 0.0,
              child: IgnorePointer(
                ignoring: _selectedTask == null && _selectedTech == null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 210,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: DashboardData.technicians.map((tech) {
                            return TechnicianCard(
                              name: tech['name'],
                              status: tech['isActive'] ? "ACTIVE" : "INACTIVE",
                              statusColor: tech['isActive'] ? DashboardTheme.success : DashboardTheme.accentAmber,
                              isActive: tech['isActive'],
                              imagePath: tech['image'],
                              roleIcon: tech['icon'],
                              role: tech['role'],
                              onTap: () {
                                if (_selectedTask != null) {
                                  if (tech['isActive']) {
                                    setState(() {
                                      if (_draftStaffNames.contains(tech['name'])) {
                                        _draftStaffNames.remove(tech['name']);
                                      } else {
                                        _draftStaffNames.add(tech['name']);
                                      }
                                    });
                                  }
                                } else {
                                  setState(() => _selectedTech = tech);
                                }
                              },
                            );
                          }).toList(),
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
    );
  }

  Widget _buildModernTab(String label, String count, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? DashboardTheme.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isActive ? DashboardTheme.primary.withOpacity(0.3) : Colors.transparent),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.notoSans(
                color: isActive ? DashboardTheme.primary : DashboardTheme.textPale,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isActive ? DashboardTheme.primary.withOpacity(0.1) : DashboardTheme.border,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                count,
                style: GoogleFonts.shareTechMono(
                  color: isActive ? DashboardTheme.primary : DashboardTheme.textPale,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: BoxDecoration(
        color: DashboardTheme.surfaceSecondary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DashboardTheme.border),
      ),
      child: Row(
        children: [
          _tableHeaderCell("ID", flex: 2),
          _tableHeaderCell("TITLE", flex: 5),
          _tableHeaderCell("REQUESTED BY", flex: 3),
          _tableHeaderCell("UNIT / LOC", flex: 3),
          _tableHeaderCell("ASSIGNED TO", flex: 3),
          _tableHeaderCell("STATUS", flex: 2),
        ],
      ),
    );
  }

  Widget _tableHeaderCell(String label, {int flex = 1, Alignment alignment = Alignment.centerLeft}) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignment,
        child: terminalText(label, fontSize: 10, color: DashboardTheme.textPale, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildModernTableRow(Map<String, dynamic> task) {
    final status = task['status'] as String;
     Color statusColor = DashboardTheme.accentAmber;
    if (status == "URGENT") statusColor = DashboardTheme.error;
    if (status == "PENDING") statusColor = DashboardTheme.warning;
    if (status == "WORKING") statusColor = DashboardTheme.success;
    if (status == "DONE") statusColor = const Color(0xFF6366F1);
    if (status == "DENIED") statusColor = DashboardTheme.error;

    final bool isInteractive = status == "PENDING" || status == "URGENT";

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isInteractive ? () {
          setState(() {
            _selectedTask = task;
            _draftStaffNames = List<String>.from(task['staffNames'] ?? []);
          });
        } : null,
        mouseCursor: isInteractive ? SystemMouseCursors.click : SystemMouseCursors.basic,
        hoverColor: statusColor.withOpacity(0.04),
        highlightColor: statusColor.withOpacity(0.08),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Row(
            children: [
              // ID
              Expanded(
                flex: 2,
                child: terminalText(task['id'] as String, fontSize: 11, color: DashboardTheme.textSecondary, fontWeight: FontWeight.bold),
              ),
              // Title & Report
              Expanded(
                flex: 5,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (task['color'] as Color).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(task['icon'] as IconData, color: task['color'] as Color, size: 18),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task['title'] as String,
                            style: GoogleFonts.notoSans(color: DashboardTheme.textMain, fontSize: 13, fontWeight: FontWeight.w700, height: 1.4),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            (task['report'] as String?) ?? "",
                            style: GoogleFonts.notoSans(color: DashboardTheme.textPale, fontSize: 10, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Requested By
              Expanded(
                flex: 3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 8,
                      backgroundImage: task['requesterImage'] != null ? AssetImage(task['requesterImage']) : null,
                      backgroundColor: DashboardTheme.border,
                      child: task['requesterImage'] == null ? Icon(Icons.person, size: 9, color: DashboardTheme.textPale) : null,
                    ),
                    const SizedBox(width: 8),
                    terminalText(task['requesterAccount'] ?? "@unknown", fontSize: 11, color: DashboardTheme.textSecondary),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(task['house'] as String, style: GoogleFonts.shareTechMono(color: DashboardTheme.textSecondary, fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  (task['staffNames'] != null && (task['staffNames'] as List).isNotEmpty)
                      ? (task['staffNames'] as List).join(", ")
                      : (task['staff'] ?? "UNASSIGNED"),
                  style: GoogleFonts.shareTechMono(
                    color: (task['staffNames'] != null && (task['staffNames'] as List).isNotEmpty) || task['staff'] != null 
                        ? DashboardTheme.textSecondary 
                        : DashboardTheme.textPale, 
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: statusColor.withOpacity(0.2)),
                      ),
                      child: Text(
                        status,
                        style: GoogleFonts.shareTechMono(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
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
