import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TechnicianCard extends StatelessWidget {
  final String name;
  final String status;
  final String? imagePath;
  final Color statusColor;
  final bool isActive;

  const TechnicianCard({
    super.key,
    required this.name,
    required this.status,
    this.imagePath,
    required this.statusColor,
    this.isActive = false,
  });

  static const Color goldAccent = Color(0xFFFFD700);
  static const Color goldDim = Color(0xFFC5A059);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 135,
      margin: const EdgeInsets.symmetric(horizontal: 16), // Increased gap further to fill the sides perfectly
      decoration: BoxDecoration(
        color: isActive ? statusColor.withOpacity(0.1) : const Color(0xFF131313),
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isActive ? statusColor.withOpacity(0.15) : const Color(0xFF1A1A1A),
            isActive ? statusColor.withOpacity(0.05) : const Color(0xFF0F0F0F),
          ],
        ),
        border: Border.all(
          color: isActive ? statusColor : Colors.white12,
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: statusColor.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ]
            : [
                const BoxShadow(
                  color: Colors.black54,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                )
              ],
      ),
      child: Opacity(
        opacity: isActive ? 1.0 : 0.6,
        child: Column(
          children: [
            // Status Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              width: double.infinity,
              color: isActive ? statusColor.withOpacity(0.3) : statusColor.withOpacity(0.1),
              child: Text(
                status.toUpperCase(),
                style: GoogleFonts.notoSans(
                  color: isActive ? Colors.white : statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w900, 
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            // Avatar Area
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isActive ? statusColor.withOpacity(0.5) : Colors.white10,
                  ),
                  image: DecorationImage(
                    image: imagePath != null
                        ? AssetImage(imagePath!) as ImageProvider
                        : const NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=tech'),
                    fit: BoxFit.cover,
                    colorFilter: isActive
                        ? null
                        : const ColorFilter.mode(Colors.black38, BlendMode.darken),
                  ),
                ),
              ),
            ),
            // Name Area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                color: Colors.transparent, // Transparent background
              ),
              child: Text(
                name.toUpperCase(),
                style: GoogleFonts.notoSans(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
