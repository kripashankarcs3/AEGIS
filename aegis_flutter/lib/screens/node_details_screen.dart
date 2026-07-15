import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'chat_conversation_screen.dart';

class NodeDetailsScreen extends StatelessWidget {
  final String nodeId;
  const NodeDetailsScreen({super.key, required this.nodeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF090D16),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Node Details',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Profile card header
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AegisColors.cardBackground,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: AegisColors.border, width: 1.0),
                ),
                child: Row(
                  children: [
                    // Shield avatar
                    Container(
                      width: 52.0,
                      height: 52.0,
                      decoration: BoxDecoration(
                        color: AegisColors.busyPurple.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: AegisColors.busyPurple.withOpacity(0.3), width: 1.0),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.shield_outlined,
                          color: AegisColors.busyPurple,
                          size: 26.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    // ID & status details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                nodeId,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              // Online Badge status
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF042F1A).withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 4.0,
                                      height: 4.0,
                                      decoration: const BoxDecoration(
                                        color: AegisColors.activeGreen,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4.0),
                                    const Text(
                                      'Online',
                                      style: TextStyle(
                                        color: AegisColors.activeGreen,
                                        fontSize: 9.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              const Text(
                                '2 hops away',
                                style: TextStyle(
                                  color: AegisColors.textSecondary,
                                  fontSize: 11.5,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              // Trusted badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: AegisColors.busyPurple.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: const Text(
                                  'Trusted',
                                  style: TextStyle(
                                    color: AegisColors.busyPurple,
                                    fontSize: 9.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),

              // 2. Metrics Statistics Card List
              Container(
                decoration: BoxDecoration(
                  color: AegisColors.cardBackground,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: AegisColors.border, width: 1.0),
                ),
                child: Column(
                  children: [
                    _buildStatRow(
                      icon: Icons.wifi_tethering_rounded,
                      label: 'Signal Strength',
                      valueWidget: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Strong',
                            style: TextStyle(color: AegisColors.activeGreen, fontWeight: FontWeight.bold, fontSize: 13.0),
                          ),
                          SizedBox(width: 6.0),
                          Icon(Icons.signal_cellular_alt_rounded, color: AegisColors.activeGreen, size: 16.0),
                        ],
                      ),
                    ),
                    _buildInnerDivider(),
                    _buildStatRow(
                      icon: Icons.av_timer_rounded,
                      label: 'Latency',
                      valueText: '42 ms',
                    ),
                    _buildInnerDivider(),
                    _buildStatRow(
                      icon: Icons.history_rounded,
                      label: 'Last Seen',
                      valueText: 'Just now',
                    ),
                    _buildInnerDivider(),
                    _buildStatRow(
                      icon: Icons.battery_charging_full_rounded,
                      label: 'Battery',
                      valueWidget: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            '78%',
                            style: TextStyle(color: Colors.white, fontSize: 13.0),
                          ),
                          SizedBox(width: 6.0),
                          Icon(Icons.battery_std_rounded, color: AegisColors.activeGreen, size: 16.0),
                        ],
                      ),
                    ),
                    _buildInnerDivider(),
                    _buildStatRow(
                      icon: Icons.verified_user_outlined,
                      label: 'Trust Score',
                      valueWidget: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            '92%',
                            style: TextStyle(color: Colors.white, fontSize: 13.0),
                          ),
                          SizedBox(width: 6.0),
                          Icon(Icons.verified_rounded, color: AegisColors.activeGreen, size: 16.0),
                        ],
                      ),
                    ),
                    _buildInnerDivider(),
                    _buildStatRow(
                      icon: Icons.calendar_today_rounded,
                      label: 'First Seen',
                      valueText: '12 May 2024',
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // 3. Actions Button Container
              Row(
                children: [
                  // Start Chat
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatConversationScreen(nodeId: nodeId),
                          ),
                        );
                      },
                      child: Container(
                        height: 42.0,
                        decoration: BoxDecoration(
                          color: AegisColors.purpleLightBg.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(6.0),
                          border: Border.all(color: AegisColors.busyPurple, width: 1.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 16.0),
                            SizedBox(width: 8.0),
                            Text(
                              'Start Chat',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  // Share Location
                  Expanded(
                    child: Container(
                      height: 42.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF042F1A).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(color: AegisColors.activeGreen.withOpacity(0.5), width: 1.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.share_location_rounded, color: AegisColors.activeGreen, size: 16.0),
                          SizedBox(width: 8.0),
                          Text(
                            'Share Location',
                            style: TextStyle(color: AegisColors.activeGreen, fontWeight: FontWeight.bold, fontSize: 13.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              // View on Map
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  // Switches tab to map in MainShell
                },
                child: Container(
                  width: double.infinity,
                  height: 42.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: AegisColors.border, width: 1.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.map_outlined, color: Colors.white, size: 16.0),
                      SizedBox(width: 8.0),
                      Text(
                        'View on Map',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    String? valueText,
    Widget? valueWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 11.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AegisColors.textSecondary, size: 18.0),
              const SizedBox(width: 10.0),
              Text(
                label,
                style: const TextStyle(
                  color: AegisColors.textSecondary,
                  fontSize: 13.0,
                ),
              ),
            ],
          ),
          if (valueWidget != null) valueWidget,
          if (valueText != null)
            Text(
              valueText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInnerDivider() {
    return const Divider(
      color: Color(0xFF1E293B),
      height: 1.0,
      thickness: 0.5,
    );
  }
}
