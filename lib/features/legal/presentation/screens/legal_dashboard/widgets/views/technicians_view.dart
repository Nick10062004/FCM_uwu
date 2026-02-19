import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fcm_app/features/legal/presentation/screens/legal_dashboard/widgets/shared/dashboard_ui_utils.dart';
import 'package:fcm_app/features/legal/presentation/screens/legal_dashboard/widgets/shared/dashboard_painters.dart';
import 'package:fcm_app/features/legal/presentation/screens/legal_dashboard/widgets/shared/personnel_dossier_overlay.dart';
import 'package:fcm_app/features/legal/presentation/screens/legal_dashboard/widgets/shared/dashboard_theme.dart';

class TechniciansView extends StatelessWidget {
  final List<Map<String, dynamic>> technicians;

  const TechniciansView({
    super.key,
    required this.technicians,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: DashboardTheme.isDarkMode,
      builder: (context, isDark, child) {
        return Container(
          color: DashboardTheme.background,
          padding: const EdgeInsets.fromLTRB(28, 90, 28, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              terminalText("SYS.ADMIN // PERSONNEL REGISTRY", fontSize: 10, color: DashboardTheme.primary.withOpacity(0.5), letterSpacing: 1.5),
              const SizedBox(height: 12),
              Text(
                "Technician Team List",
                style: GoogleFonts.notoSans(color: DashboardTheme.textMain, fontSize: 32, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 40),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: DashboardTheme.surfaceSecondary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: DashboardTheme.border),
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
                  separatorBuilder: (_, __) => Divider(color: DashboardTheme.border, height: 1),
                  itemBuilder: (context, index) => _buildStaffRow(context, technicians[index]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _staffHeaderCell(String label, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: GoogleFonts.notoSans(color: DashboardTheme.textPale, fontSize: 13, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildStaffRow(BuildContext context, Map<String, dynamic> tech) {
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
              color: isHovered ? DashboardTheme.primary.withOpacity(0.05) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Opacity(
              opacity: isActive ? 1.0 : 0.6,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.centerLeft,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: DashboardTheme.primary.withOpacity(0.1),
                        backgroundImage: AssetImage(tech['image'] as String),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: InkWell(
                      onTap: () => _showTechnicianDossier(context, tech),
                      child: Text(
                        tech['name'] as String,
                        style: GoogleFonts.notoSans(
                          color: DashboardTheme.textMain,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          decoration: isHovered && isActive ? TextDecoration.underline : TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      tech['phone'] as String,
                      style: GoogleFonts.notoSans(color: DashboardTheme.textSecondary, fontSize: 13),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      tech['email'] as String,
                      style: GoogleFonts.notoSans(color: DashboardTheme.textPale, fontSize: 13),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isActive ? DashboardTheme.success.withOpacity(0.1) : DashboardTheme.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isActive ? DashboardTheme.success.withOpacity(0.2) : DashboardTheme.error.withOpacity(0.2)),
                          ),
                          child: Text(
                            isActive ? "Active" : "Inactive",
                            style: GoogleFonts.notoSans(
                              color: isActive ? DashboardTheme.success : DashboardTheme.error,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Text(
                          tech['role'] as String,
                          style: GoogleFonts.notoSans(
                            color: DashboardTheme.textSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Icon(Icons.star_rounded, color: DashboardTheme.accentAmber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "${tech['rating']}",
                          style: GoogleFonts.shareTechMono(color: DashboardTheme.textSecondary, fontSize: 14, fontWeight: FontWeight.bold),
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


  void _showTechnicianDossier(BuildContext context, Map<String, dynamic> tech) {
    showDialog(
      context: context,
      builder: (context) => PersonnelDossierOverlay(
        technician: tech,
        onDismiss: () => Navigator.pop(context),
      ),
    );
  }
}
