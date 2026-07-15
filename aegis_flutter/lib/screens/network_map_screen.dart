import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';

class MapNode {
  final String label;
  final Color color;
  final double dx; // -1.0 to 1.0
  final double dy; // -1.0 to 1.0
  final bool isUser;

  const MapNode({
    required this.label,
    required this.color,
    required this.dx,
    required this.dy,
    this.isUser = false,
  });
}

class MapMeshPainter extends CustomPainter {
  final List<MapNode> nodes;

  MapMeshPainter({required this.nodes});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 2 * 0.9;

    // 1. Draw Grid Lines (faint blue/grey lines)
    final gridPaint = Paint()
      ..color = const Color(0xFF1E293B).withOpacity(0.5)
      ..strokeWidth = 0.5;

    const int gridSegments = 8;
    for (int i = 1; i < gridSegments; i++) {
      final double x = size.width / gridSegments * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      
      final double y = size.height / gridSegments * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 2. Draw outer boundary mesh ring connections
    final ringPaint = Paint()
      ..color = const Color(0xFF14B8A6).withOpacity(0.2)
      ..strokeWidth = 1.0;

    // Find and sort outer nodes by angle to draw ring connections
    final outerNodes = nodes.where((n) => !n.isUser).toList();
    outerNodes.sort((a, b) => atan2(a.dy, a.dx).compareTo(atan2(b.dy, b.dx)));

    for (int i = 0; i < outerNodes.length; i++) {
      final nodeA = outerNodes[i];
      final nodeB = outerNodes[(i + 1) % outerNodes.length];

      final posA = Offset(center.dx + nodeA.dx * maxRadius, center.dy + nodeA.dy * maxRadius);
      final posB = Offset(center.dx + nodeB.dx * maxRadius, center.dy + nodeB.dy * maxRadius);

      canvas.drawLine(posA, posB, ringPaint);
    }

    // 3. Draw radial connections from center node to outer nodes
    final userNode = nodes.firstWhere((n) => n.isUser);
    final userPos = Offset(center.dx + userNode.dx * maxRadius, center.dy + userNode.dy * maxRadius);

    for (var outerNode in outerNodes) {
      final pos = Offset(center.dx + outerNode.dx * maxRadius, center.dy + outerNode.dy * maxRadius);
      
      final radialPaint = Paint()
        ..color = outerNode.color.withOpacity(0.3)
        ..strokeWidth = 1.2;

      canvas.drawLine(userPos, pos, radialPaint);
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
  final List<MapNode> _mapNodes = const [
    MapNode(label: 'YOU', color: AegisColors.primaryBlue, dx: 0.0, dy: 0.0, isUser: true),
    MapNode(label: 'N1', color: AegisColors.activeGreen, dx: -0.45, dy: -0.6),
    MapNode(label: 'N2', color: AegisColors.activeGreen, dx: 0.05, dy: -0.65),
    MapNode(label: 'N3', color: AegisColors.warningOrange, dx: 0.45, dy: -0.45),
    MapNode(label: 'N4', color: AegisColors.busyPurple, dx: 0.65, dy: -0.15),
    MapNode(label: 'N5', color: AegisColors.inactiveGrey, dx: 0.60, dy: 0.28),
    MapNode(label: 'N6', color: AegisColors.busyPurple, dx: 0.45, dy: 0.58),
    MapNode(label: 'N7', color: AegisColors.inactiveGrey, dx: 0.0, dy: 0.70),
    MapNode(label: 'N8', color: AegisColors.sosRed, dx: -0.45, dy: 0.52),
    MapNode(label: 'N9', color: AegisColors.activeGreen, dx: -0.65, dy: 0.18),
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
                          'NETWORK MAP',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.tune_rounded, color: Colors.white, size: 22.0),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),

                // 2. Map Canvas (aspectRatio 1.15)
                AspectRatio(
                  aspectRatio: 1.1,
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
                        final maxRadius = min(constraints.maxWidth, constraints.maxHeight) / 2 * 0.9;

                        return Stack(
                          children: [
                            // Connections lines background drawing
                            Positioned.fill(
                              child: CustomPaint(
                                painter: MapMeshPainter(nodes: _mapNodes),
                              ),
                            ),

                            // Overlay the Map nodes (small colored points with user tag in center)
                            ..._mapNodes.map((node) {
                              final double nodeX = center.dx + node.dx * maxRadius;
                              final double nodeY = center.dy + node.dy * maxRadius;

                              final double pointSize = node.isUser ? 36.0 : 12.0;

                              return Positioned(
                                left: nodeX - pointSize / 2,
                                top: nodeY - pointSize / 2,
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

                // 3. Status Indicators row
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatusLegend(AegisColors.activeGreen, 'Online'),
                      _buildStatusLegend(AegisColors.warningOrange, 'Relay'),
                      _buildStatusLegend(AegisColors.busyPurple, 'Busy'),
                      _buildStatusLegend(AegisColors.inactiveGrey, 'Offline'),
                      _buildStatusLegend(AegisColors.sosRed, 'SOS'),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),

                // 4. Grid Stats Card below map
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: AegisColors.cardBackground,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AegisColors.border, width: 1.0),
                  ),
                  child: Row(
                    children: [
                      _buildGridStatCol('Network Reach', '340m', null),
                      _buildDivider(),
                      _buildGridStatCol('Avg Latency', '42ms', null),
                      _buildDivider(),
                      _buildGridStatCol('Network Health', '94%', 'Good'),
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
    return Row(
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
        const SizedBox(width: 4.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.0,
            color: AegisColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildGridStatCol(String label, String value, String? healthText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 9.0,
                color: AegisColors.textMuted,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3.0),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            if (healthText != null) ...[
              Text(
                healthText,
                style: const TextStyle(
                  fontSize: 9.0,
                  color: AegisColors.activeGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const SizedBox(
      height: 32.0,
      child: VerticalDivider(
        color: AegisColors.border,
        width: 1.0,
        thickness: 1.0,
      ),
    );
  }
}
