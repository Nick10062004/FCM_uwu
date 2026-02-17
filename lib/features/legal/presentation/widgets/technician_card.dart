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

  @override
  Widget build(BuildContext context) {
    final Color currentColor = isActive ? const Color(0xFF00FF9F) : const Color(0xFFC5A059); // Gold for Offline Standby
    final String currentStatus = isActive ? "ACTIVE" : "OFFLINE";

    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isActive ? currentColor.withOpacity(0.3) : currentColor.withOpacity(0.12),
          width: 0.8,
        ),
        boxShadow: isActive ? [
          BoxShadow(
            color: currentColor.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ] : [],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status Header with Gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  isActive ? currentColor.withOpacity(0.9) : currentColor.withOpacity(0.15),
                  isActive ? currentColor.withOpacity(0.6) : currentColor.withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
            ),
            child: Text(
              currentStatus,
              style: GoogleFonts.notoSans(
                color: isActive ? Colors.black : currentColor.withOpacity(0.6),
                fontSize: 8,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Portrait Section
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF050505),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: ClipRect(
                    child: imagePath != null
                        ? Image.asset(
                            imagePath!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildPlaceholder(),
                            color: isActive ? null : Colors.black.withOpacity(0.4),
                            colorBlendMode: isActive ? null : BlendMode.darken,
                          )
                        : _buildPlaceholder(),
                  ),
                ),
              ),
              // HUD Brackets (Corner Brackets)
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: CustomPaint(
                    painter: _HUDBracketPainter(color: isActive ? currentColor.withOpacity(0.6) : Colors.white10),
                  ),
                ),
              ),
              // Grid Overlay
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _GridPainter(opacity: isActive ? 0.08 : 0.03),
                  ),
                ),
              ),
              // Scanline / Glitch effect
              if (isActive)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.02),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Footer Section (Name)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Column(
              children: [
                Text(
                  name.toUpperCase(),
                  style: GoogleFonts.notoSans(
                    color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Container(
                  height: 1,
                  width: 20,
                  color: isActive ? currentColor.withOpacity(0.5) : Colors.white.withOpacity(0.05),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFF1A1A1A),
      child: const Icon(Icons.person, color: Colors.white12, size: 32),
    );
  }
}

class _HUDBracketPainter extends CustomPainter {
  final Color color;
  _HUDBracketPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const cornerLength = 8.0;

    // Top Left
    canvas.drawPath(Path()
      ..moveTo(0, cornerLength)
      ..lineTo(0, 0)
      ..lineTo(cornerLength, 0), paint);

    // Top Right
    canvas.drawPath(Path()
      ..moveTo(size.width - cornerLength, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, cornerLength), paint);

    // Bottom Left
    canvas.drawPath(Path()
      ..moveTo(0, size.height - cornerLength)
      ..lineTo(0, size.height)
      ..lineTo(cornerLength, size.height), paint);

    // Bottom Right
    canvas.drawPath(Path()
      ..moveTo(size.width - cornerLength, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _GridPainter extends CustomPainter {
  final double opacity;
  _GridPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..strokeWidth = 0.5;

    const gap = 6.0;
    for (double i = 0; i <= size.width; i += gap) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i <= size.height; i += gap) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
