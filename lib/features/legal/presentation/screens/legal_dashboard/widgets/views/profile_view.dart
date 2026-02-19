import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fcm_app/features/legal/presentation/screens/legal_dashboard/widgets/shared/dashboard_theme.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DashboardTheme.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(40, 100, 40, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Account",
              style: GoogleFonts.notoSans(
                color: DashboardTheme.textMain,
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
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: DashboardTheme.primary.withOpacity(0.3), width: 3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile_placeholder_2.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: DashboardTheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: DashboardTheme.primary.withOpacity(0.5)),
                    ),
                    child: Icon(Icons.edit_rounded, color: DashboardTheme.primary.withOpacity(0.6), size: 18),
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
                        color: DashboardTheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: DashboardTheme.border),
                      ),
                      child: Text(
                        "Admin",
                        style: GoogleFonts.notoSans(color: DashboardTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Admin Zeta",
                      style: GoogleFonts.notoSans(
                        color: DashboardTheme.textMain,
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
                  child: _profileInputField(context, "Name", "Admin Zeta"),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _profileInputField(context, "Email", "admin@gmail.com"),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _profileInputField(context, "Phone", "+66 88 777 9999"),
            const SizedBox(height: 32),

            // Action Cards: Change Password & Transfer Ownership
            Row(
              children: [
                Expanded(
                  child: _profileActionCard(
                    context,
                    "Change password",
                    Icons.lock_outline_rounded,
                    onTap: () => _showEditProfileDialog(context, "Password", ""),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _profileActionCard(
                    context,
                    "Transfer ownership",
                    Icons.person_add_alt_1_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Danger Zone: Delete Account
            _profileActionCard(
              context,
              "Delete account",
              null,
              content: Text(
                "Contact our support team to process the deletion of your account.",
                style: GoogleFonts.notoSans(color: DashboardTheme.textPale, fontSize: 12),
              ),
              isDanger: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileInputField(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.notoSans(color: DashboardTheme.textMain, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: DashboardTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: DashboardTheme.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.notoSans(color: DashboardTheme.textSecondary, fontSize: 14),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: InkWell(
                  onTap: () => _showEditProfileDialog(context, label, value),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(Icons.edit_rounded, color: DashboardTheme.primary.withOpacity(0.6), size: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _profileActionCard(BuildContext context, String title, IconData? icon, {Widget? content, bool isDanger = false, VoidCallback? onTap}) {
    return _HoverActionCard(
      title: title,
      icon: icon,
      content: content,
      isDanger: isDanger,
      onTap: onTap,
    );
  }

  void _showEditProfileDialog(BuildContext context, String label, String currentValue) {
    final TextEditingController controller = TextEditingController(text: label == "Password" ? "" : currentValue);
    final bool isPassword = label == "Password";

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: DashboardTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: DashboardTheme.border),
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
                    color: DashboardTheme.textMain,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  isPassword ? "New $label" : label,
                  style: GoogleFonts.notoSans(color: DashboardTheme.primary, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  obscureText: isPassword,
                  style: TextStyle(color: DashboardTheme.textMain, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: "Enter your $label...",
                    hintStyle: TextStyle(color: DashboardTheme.textPale),
                    filled: true,
                    fillColor: DashboardTheme.surfaceSecondary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: DashboardTheme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: DashboardTheme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: DashboardTheme.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("CANCEL", style: GoogleFonts.notoSans(color: DashboardTheme.textPale)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DashboardTheme.primary,
                          foregroundColor: Colors.white,
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
}

class _HoverActionCard extends StatefulWidget {
  final String title;
  final IconData? icon;
  final Widget? content;
  final bool isDanger;
  final VoidCallback? onTap;

  const _HoverActionCard({
    required this.title,
    this.icon,
    this.content,
    this.isDanger = false,
    this.onTap,
  });

  @override
  State<_HoverActionCard> createState() => _HoverActionCardState();
}

class _HoverActionCardState extends State<_HoverActionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(24),
        mouseCursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: widget.isDanger 
                ? DashboardTheme.error.withOpacity(_isHovered ? 0.08 : 0.05)
                : DashboardTheme.surface.withOpacity(_isHovered ? 1.0 : 0.8),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: widget.isDanger 
                  ? DashboardTheme.error.withOpacity(_isHovered ? 0.3 : 0.15)
                  : DashboardTheme.border.withOpacity(_isHovered ? 1.0 : 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.icon != null)
                Container(
                  width: 44,
                  height: 44,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: DashboardTheme.background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(widget.icon, color: widget.isDanger ? DashboardTheme.error : DashboardTheme.textSecondary, size: 20),
                ),
              Text(
                widget.title,
                style: GoogleFonts.notoSans(
                  color: widget.isDanger ? DashboardTheme.error : DashboardTheme.textMain,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (widget.content != null) ...[
                const SizedBox(height: 8),
                widget.content!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
