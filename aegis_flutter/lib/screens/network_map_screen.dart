import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'node_details_screen.dart';
import 'identity_screen.dart';

class MapMarkerNode {
  final String label;
  final Color color;
  final double dx; // -1.0 to 1.0
  final double dy; // -1.0 to 1.0
  final bool isUser;
  final IconData icon;

  const MapMarkerNode({
    required this.label,
    required this.color,
    required this.dx,
    required this.dy,
    this.isUser = false,
    required this.icon,
  });
}

class SurvivorMapPainter extends CustomPainter {
  final List<MapMarkerNode> nodes;

  SurvivorMapPainter({required this.nodes});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 2 * 0.88;

    // 1. Draw circular concentric radar rings (faint green-ish/cyan)
    final ringPaint = Paint()
      ..color = const Color(0xFF1E293B).withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final List<double> radii = [
      maxRadius * 0.35,
      maxRadius * 0.68,
      maxRadius,
    ];

    for (int i = 0; i < radii.length; i++) {
      canvas.drawCircle(center, radii[i], ringPaint);
    }

    // 2. Faint grid division lines
    final axisPaint = Paint()
      ..color = const Color(0xFF1E293B).withOpacity(0.3)
      ..strokeWidth = 0.8;
    
    canvas.drawLine(Offset(center.dx - maxRadius, center.dy), Offset(center.dx + maxRadius, center.dy), axisPaint);
    canvas.drawLine(Offset(center.dx, center.dy - maxRadius), Offset(center.dx, center.dy + maxRadius), axisPaint);
    
    // 3. Faint dotted connection lines from center
    final userNode = nodes.firstWhere((n) => n.isUser);
    final userPos = Offset(center.dx + userNode.dx * maxRadius, center.dy + userNode.dy * maxRadius);

    for (var outerNode in nodes) {
      if (outerNode.isUser) continue;
      final pos = Offset(center.dx + outerNode.dx * maxRadius, center.dy + outerNode.dy * maxRadius);
      
      final linePaint = Paint()
        ..color = outerNode.color.withOpacity(0.2)
        ..strokeWidth = 1.0;

      _drawDashedLine(canvas, userPos, pos, linePaint);
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

class NetworkMapScreen extends StatefulWidget {
  const NetworkMapScreen({super.key});

  @override
  State<NetworkMapScreen> createState() => _NetworkMapScreenState();
}

class _NetworkMapScreenState extends State<NetworkMapScreen> {
  final List<MapMarkerNode> _markers = const [
    MapMarkerNode(label: 'YOU', color: AegisColors.primaryBlue, dx: 0.0, dy: 0.0, isUser: true, icon: Icons.person_rounded),
    MapMarkerNode(label: 'Shelter 1', color: AegisColors.busyPurple, dx: 0.05, dy: 0.65, icon: Icons.roofing_rounded),
    MapMarkerNode(label: 'Danger 1', color: AegisColors.sosRed, dx: -0.15, dy: -0.62, icon: Icons.warning_amber_rounded),
    MapMarkerNode(label: 'Medical 1', color: AegisColors.primaryBlue, dx: -0.45, dy: 0.28, icon: Icons.local_hospital_rounded),
    MapMarkerNode(label: 'Safe Zone 1', color: AegisColors.activeGreen, dx: -0.58, dy: -0.22, icon: Icons.shield_outlined),
    MapMarkerNode(label: 'Shelter 2', color: AegisColors.warningOrange, dx: 0.6, dy: 0.2, icon: Icons.roofing_rounded),
    MapMarkerNode(label: 'Safe Zone 2', color: AegisColors.activeGreen, dx: 0.48, dy: -0.48, icon: Icons.shield_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Header Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22.0),
                          onPressed: () {},
                        ),
                        const Text(
                          'Survivor Map',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search_rounded, color: Colors.white, size: 22.0),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.tune_rounded, color: Colors.white, size: 22.0),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),

                // 2. Status pills filter tags list
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatusLegend(AegisColors.activeGreen, 'Safe Zone'),
                      _buildStatusLegend(AegisColors.sosRed, 'Danger'),
                      _buildStatusLegend(AegisColors.busyPurple, 'Shelter'),
                      _buildStatusLegend(AegisColors.primaryBlue, 'Medical'),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),

                // 3. Map Canvas Graphics with overlays
                AspectRatio(
                  aspectRatio: 1.05,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF090D16),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: AegisColors.border, width: 1.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
                        final maxRadius = min(constraints.maxWidth, constraints.maxHeight) / 2 * 0.88;

                        return Stack(
                          children: [
                            // Connections lines background drawing
                            Positioned.fill(
                              child: CustomPaint(
                                painter: SurvivorMapPainter(nodes: _markers),
                              ),
                            ),

                            // Overlay the Map nodes (small colored points with user tag in center)
                            ..._markers.map((node) {
                              final double nodeX = center.dx + node.dx * maxRadius;
                              final double nodeY = center.dy + node.dy * maxRadius;

                              final double pointSize = node.isUser ? 36.0 : 28.0;

                              return Positioned(
                                left: nodeX - pointSize / 2,
                                top: nodeY - pointSize / 2,
                                child: GestureDetector(
                                  onTap: () {
                                    if (node.isUser) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const IdentityScreen(),
                                        ),
                                      );
                                    } else {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const NodeDetailsScreen(nodeId: 'SIG-8AF3'),
                                        ),
                                      );
                                    }
                                  },
                                  child: node.isUser
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: pointSize,
                                              height: pointSize,
                                              decoration: BoxDecoration(
                                                color: node.color,
                                                shape: BoxShape.circle,
                                                border: Border.all(color: Colors.white, width: 2.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: node.color.withOpacity(0.5),
                                                    blurRadius: 10,
                                                  ),
                                                ],
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.person_rounded,
                                                  color: Colors.white,
                                                  size: 18.0,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4.0),
                                            const Text(
                                              'YOU',
                                              style: TextStyle(
                                                fontSize: 9.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          width: pointSize,
                                          height: pointSize,
                                          decoration: BoxDecoration(
                                            color: node.color,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: const Color(0xFF090D16), width: 1.5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: node.color.withOpacity(0.4),
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Icon(
                                              node.icon,
                                              color: Colors.white,
                                              size: 14.0,
                                            ),
                                          ),
                                        ),
                                ),
                              );
                            }),

                            // Right controls overlay
                            Positioned(
                              right: 12.0,
                              bottom: 24.0,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildMapControlBtn(Icons.gps_fixed_rounded),
                                  const SizedBox(height: 8.0),
                                  _buildMapControlBtn(Icons.add_rounded),
                                  const SizedBox(height: 8.0),
                                  _buildMapControlBtn(Icons.remove_rounded),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // 4. Bottom Info Card Details
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AegisColors.cardBackground,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AegisColors.border, width: 1.0),
                  ),
                  child: Row(
                    children: [
                      // Safe Zone shield logo icon
                      Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color: AegisColors.greenLightBg,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.shield_outlined,
                            color: AegisColors.activeGreen,
                            size: 20.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14.0),
                      // Details Column info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Safe Zone',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: AegisColors.activeGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 3.0),
                            Text(
                              'Lake View Park',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 3.0),
                            Text(
                              '12 km away • 15 people',
                              style: TextStyle(
                                fontSize: 11.0,
                                color: AegisColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: AegisColors.textSecondary,
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMapControlBtn(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(color: const Color(0xFF1F2937), width: 1.0),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 16.0,
          color: AegisColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildStatusLegend(Color color, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: color.withOpacity(0.3), width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.0,
            height: 6.0,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
