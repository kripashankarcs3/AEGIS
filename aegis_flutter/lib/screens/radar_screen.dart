import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import '../models/survivor_node.dart';
import '../widgets/radar_painter.dart';
import '../widgets/mesh_stats_bar.dart';
import 'identity_screen.dart';
import 'notifications_screen.dart';
import 'node_details_screen.dart';
import 'settings_screen.dart';
import 'sos_incoming_overlay.dart';

class RadarScreen extends StatefulWidget {
  const RadarScreen({super.key});

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> {
  bool _isEmptyRadar = false;

  final List<SurvivorNode> _nodes = const [
    SurvivorNode(id: 'SIG-7F3A', hops: 0, status: NodeStatus.online, isUser: true, dx: 0.0, dy: 0.0),
    SurvivorNode(id: 'SIG-8AF3', hops: 2, status: NodeStatus.online, dx: 0.0, dy: -0.65),
    SurvivorNode(id: 'SIG-C4E1', hops: 1, status: NodeStatus.online, dx: -0.65, dy: -0.22),
    SurvivorNode(id: 'SIG-B2C1', hops: 2, status: NodeStatus.relay, dx: 0.55, dy: -0.30),
    SurvivorNode(id: 'SIG-9E10', hops: 3, status: NodeStatus.busy, dx: 0.45, dy: 0.55),
    SurvivorNode(id: 'SIG-1D9A', hops: 0, status: NodeStatus.sos, dx: -0.55, dy: 0.58),
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
                        const Icon(
                          Icons.shield_outlined,
                          color: Colors.white,
                          size: 26.0,
                        ),
                        const SizedBox(width: 8.0),
                        const Text(
                          'AEGIS',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // WiFi/Signal Toggle Button
                        IconButton(
                          icon: Icon(
                            _isEmptyRadar ? Icons.wifi_off_rounded : Icons.wifi_rounded,
                            color: _isEmptyRadar ? AegisColors.sosRed : AegisColors.activeGreen,
                            size: 22.0,
                          ),
                          onPressed: () {
                            setState(() {
                              _isEmptyRadar = !_isEmptyRadar;
                            });
                          },
                        ),
                        const SizedBox(width: 8.0),
                        // Notification icon with red badge dot
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const NotificationsScreen(),
                              ),
                            );
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const Icon(
                                Icons.notifications_none_outlined,
                                color: Colors.white,
                                size: 22.0,
                              ),
                              Positioned(
                                right: 1.0,
                                top: 1.0,
                                child: Container(
                                  width: 7.0,
                                  height: 7.0,
                                  decoration: const BoxDecoration(
                                    color: AegisColors.sosRed,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        // User Avatar
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const IdentityScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: 28.0,
                            height: 28.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AegisColors.border, width: 1.0),
                              color: Colors.purple.shade700,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person_rounded,
                                size: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                // 2. Sub-bar Status Badges
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Mesh Active Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: AegisColors.greenLightBg,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.0,
                            height: 6.0,
                            decoration: const BoxDecoration(
                              color: AegisColors.activeGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          const Text(
                            'Mesh Active',
                            style: TextStyle(
                              color: AegisColors.activeGreen,
                              fontSize: 10.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 8 Nodes Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: AegisColors.purpleLightBg,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Text(
                        _isEmptyRadar ? '0 Nodes' : '8 Nodes',
                        style: const TextStyle(
                          color: AegisColors.busyPurple,
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),

                // Live Mesh Radar Label
                const Center(
                  child: Text(
                    'LIVE MESH RADAR',
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF14B8A6),
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 4.0),

                // 3. Central Radar Graphic
                RadarVisualization(
                  nodes: _isEmptyRadar ? _nodes.where((n) => n.isUser).toList() : _nodes,
                  onLocateTap: () {},
                  onNodeTap: (node) {
                    if (node.id == 'SIG-1D9A') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SosIncomingOverlayScreen(),
                        ),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NodeDetailsScreen(nodeId: node.id),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16.0),

                if (_isEmptyRadar) ...[
                  // 4. "0 nodes detected" and subtitle warnings
                  const Center(
                    child: Text(
                      '0 nodes detected',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Make sure other AEGIS devices are on the same WiFi network.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AegisColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),

                  // Legend Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLegendItem(AegisColors.activeGreen, 'Strong'),
                      _buildLegendItem(AegisColors.warningOrange, 'Medium'),
                      _buildLegendItem(AegisColors.sosRed, 'Weak'),
                      _buildLegendItem(const Color(0xFF64748B), 'Offline'),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                ] else ...[
                  // 4. Network Overview Section
                  const MeshStatsBar(),
                  const SizedBox(height: 24.0),

                  // 5. Recent Activity Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'RECENT ACTIVITY',
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'View all',
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                            color: AegisColors.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),

                  // 6. Recent Activity Log List
                  _buildActivityLog(
                    color: AegisColors.activeGreen,
                    text: 'SIG-8AF3 joined the network',
                    time: '2m ago',
                  ),
                  const SizedBox(height: 8.0),
                  _buildActivityLog(
                    color: AegisColors.primaryBlue,
                    text: 'Packet relayed to SIG-B2C1',
                    time: '3m ago',
                  ),
                  const SizedBox(height: 8.0),
                  _buildActivityLog(
                    color: AegisColors.sosRed,
                    text: 'SOS from SIG-1D9A received',
                    time: '5m ago',
                  ),
                  const SizedBox(height: 8.0),
                  _buildActivityLog(
                    color: AegisColors.textMuted,
                    text: 'Resource from SIG-C4E1 relayed',
                    time: '7m ago',
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7.0,
          height: 7.0,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6.0),
        Text(
          text,
          style: const TextStyle(
            color: AegisColors.textSecondary,
            fontSize: 11.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityLog({
    required Color color,
    required String text,
    required String time,
  }) {
    return Row(
      children: [
        // Activity Dot
        Container(
          width: 6.0,
          height: 6.0,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10.0),
        // Event Text
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12.0,
              color: AegisColors.textSecondary,
            ),
          ),
        ),
        // Time Ago
        Text(
          time,
          style: const TextStyle(
            fontSize: 11.0,
            color: AegisColors.textMuted,
          ),
        ),
      ],
    );
  }
}
