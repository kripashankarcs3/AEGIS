import 'dart:math';
import 'package:flutter/material.dart';
import '../models/survivor_node.dart';
import '../constants/aegis_colors.dart';

class RadarBackgroundPainter extends CustomPainter {
  final List<SurvivorNode> nodes;

  RadarBackgroundPainter({required this.nodes});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 2 * 0.88;
    
    // 1. Draw live radar sector gradient sweep
    final sweepPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF10B981).withOpacity(0.01),
          const Color(0xFF10B981).withOpacity(0.18),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius))
      ..style = PaintingStyle.fill;
    
    // Draw an arc sector
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: maxRadius),
      -pi / 4, // Start angle (approx 315 deg)
      pi / 3,  // Sweep angle (60 deg)
      true,
      sweepPaint,
    );

    // 2. Draw Concentric circles (Dashed Greenish/Cyan)
    final ringPaint = Paint()
      ..color = const Color(0xFF14B8A6).withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final List<double> radii = [
      maxRadius * 0.35,
      maxRadius * 0.68,
      maxRadius,
    ];

    for (int i = 0; i < radii.length; i++) {
      _drawDashedCircle(canvas, center, radii[i], ringPaint);
    }

    // 3. Draw grid axes (very faint lines)
    final axisPaint = Paint()
      ..color = const Color(0xFF1E293B).withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    canvas.drawLine(Offset(center.dx - maxRadius, center.dy), Offset(center.dx + maxRadius, center.dy), axisPaint);
    canvas.drawLine(Offset(center.dx, center.dy - maxRadius), Offset(center.dx, center.dy + maxRadius), axisPaint);
    
    canvas.drawLine(
      Offset(center.dx - maxRadius * 0.707, center.dy - maxRadius * 0.707),
      Offset(center.dx + maxRadius * 0.707, center.dy + maxRadius * 0.707),
      axisPaint,
    );
    canvas.drawLine(
      Offset(center.dx - maxRadius * 0.707, center.dy + maxRadius * 0.707),
      Offset(center.dx + maxRadius * 0.707, center.dy - maxRadius * 0.707),
      axisPaint,
    );

    // 4. Draw node connection lines
    for (var node in nodes) {
      if (node.isUser) continue;
      
      final nodeOffset = Offset(
        center.dx + node.dx * maxRadius,
        center.dy + node.dy * maxRadius,
      );

      final linePaint = Paint()
        ..color = (node.status == NodeStatus.offline)
            ? const Color(0xFF334155).withOpacity(0.4)
            : node.color.withOpacity(0.3)
        ..strokeWidth = 1.2;

      if (node.status == NodeStatus.offline) {
        _drawDashedLine(canvas, center, nodeOffset, linePaint);
      } else {
        canvas.drawLine(center, nodeOffset, linePaint);
      }
    }
  }

  void _drawDashedCircle(Canvas canvas, Offset center, double radius, Paint paint) {
    const int dashCount = 70;
    final double sweepAngle = 2 * pi / dashCount;
    for (int i = 0; i < dashCount; i++) {
      if (i % 2 == 0) {
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          i * sweepAngle,
          sweepAngle,
          false,
          paint,
        );
      }
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    final double dx = p2.dx - p1.dx;
    final double dy = p2.dy - p1.dy;
    final double distance = sqrt(dx * dx + dy * dy);
    const double dashLength = 4.0;
    const double spaceLength = 4.0;
    final int count = (distance / (dashLength + spaceLength)).floor();

    for (int i = 0; i < count; i++) {
      final double startFraction = (i * (dashLength + spaceLength)) / distance;
      final double endFraction = (startFraction + dashLength / distance).clamp(0.0, 1.0);
      canvas.drawLine(
        Offset(p1.dx + dx * startFraction, p1.dy + dy * startFraction),
        Offset(p1.dx + dx * endFraction, p1.dy + dy * endFraction),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RadarVisualization extends StatelessWidget {
  final List<SurvivorNode> nodes;
  final VoidCallback? onLocateTap;

  const RadarVisualization({
    super.key,
    required this.nodes,
    this.onLocateTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.15,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
          final maxRadius = min(constraints.maxWidth, constraints.maxHeight) / 2 * 0.88;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Radar background painter
              Positioned.fill(
                child: CustomPaint(
                  painter: RadarBackgroundPainter(nodes: nodes),
                ),
              ),

              // Overlay the Nodes (No text labels except "YOU" under center user node)
              ...nodes.map((node) {
                final double nodeX = center.dx + node.dx * maxRadius;
                final double nodeY = center.dy + node.dy * maxRadius;
                
                final double avatarSize = node.isUser ? 36.0 : 28.0;
                
                return Positioned(
                  left: nodeX - avatarSize / 2,
                  top: nodeY - avatarSize / 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Node Avatar Circle
                      Container(
                        width: avatarSize,
                        height: avatarSize,
                        decoration: BoxDecoration(
                          color: node.isUser ? AegisColors.primaryBlue : node.color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: node.isUser ? Colors.white : const Color(0xFF1E293B),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: node.color.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            node.isUser ? Icons.person_rounded : Icons.sensors_rounded,
                            color: Colors.white,
                            size: node.isUser ? 20.0 : 14.0,
                          ),
                        ),
                      ),
                      
                      // Labeled "YOU" if center node
                      if (node.isUser) ...[
                        const SizedBox(height: 4.0),
                        const Material(
                          color: Colors.transparent,
                          child: Text(
                            'YOU',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),

              // Control target/aim icon on the bottom right of the radar
              Positioned(
                right: 12.0,
                bottom: 24.0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF1F2937), width: 1.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: onLocateTap,
                    customBorder: const CircleBorder(),
                    child: const Center(
                      child: Icon(
                        Icons.gps_fixed_rounded,
                        size: 16.0,
                        color: AegisColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
