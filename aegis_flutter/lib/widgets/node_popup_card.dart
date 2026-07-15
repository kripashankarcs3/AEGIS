import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';

class NodePopupCard extends StatelessWidget {
  final String nodeId;
  final VoidCallback onOpenChat;
  final VoidCallback? onSendSos;

  const NodePopupCard({
    super.key,
    required this.nodeId,
    required this.onOpenChat,
    this.onSendSos,
  });

  Map<String, dynamic> _getNodeData(String id) {
    if (id == 'SIG-4D2F') {
      return {
        'status': 'Offline',
        'statusColor': const Color(0xFF64748B),
        'hops': 'Offline',
        'lastSeen': '2 hours ago',
        'signal': 0,
        'battery': '12%',
        'batteryColor': const Color(0xFFEF4444),
        'safeStatus': 'Unknown',
        'safeColor': const Color(0xFF9CA3AF),
        'location': 'Unknown',
        'publicKey': '4d2f9c2d8b6e4f1a9c2d8b6e4f1a9c2d8b6e4f1a9c2d8b6e4f1a9c2d8b6e4f1a',
      };
    }
    
    // Default mock data matching mockup 29 (SIG-4EBD)
    return {
      'status': 'Online',
      'statusColor': AegisColors.activeGreen,
      'hops': '1 hop away',
      'lastSeen': 'Just now',
      'signal': 3,
      'battery': '64%',
      'batteryColor': AegisColors.activeGreen,
      'safeStatus': 'Safe',
      'safeColor': AegisColors.activeGreen,
      'location': '28.6139° N, 77.2090° E',
      'publicKey': '7f3a9c2d8b6e4f1a9c2d8b6e4f1a9c2d8b6e4f1a9c2d8b6e4f1a9c2d8b6e4f1a',
    };
  }

  @override
  Widget build(BuildContext context) {
    final data = _getNodeData(nodeId);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Color(0xFF0F131A), // Card background
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle & Close button row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 24.0), // spacer to balance close button
              Container(
                width: 38.0,
                height: 4.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF374151),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1F2937),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded, color: Colors.white, size: 16.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // User profile section
          Center(
            child: Column(
              children: [
                // Avatar
                Container(
                  width: 56.0,
                  height: 56.0,
                  decoration: BoxDecoration(
                    color: AegisColors.busyPurple.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AegisColors.busyPurple.withOpacity(0.3),
                      width: 1.0,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_rounded,
                      color: AegisColors.busyPurple,
                      size: 28.0,
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  nodeId,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.0,
                      height: 6.0,
                      decoration: BoxDecoration(
                        color: data['statusColor'] as Color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      "${data['status']}  •  ${data['hops']}",
                      style: const TextStyle(
                        fontSize: 11.0,
                        color: AegisColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),

          // Info tiles card container
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF161A22),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: AegisColors.border, width: 1.0),
            ),
            child: Column(
              children: [
                // Last seen
                _buildInfoRow(
                  icon: Icons.access_time_rounded,
                  label: 'Last Seen',
                  valueWidget: Text(
                    data['lastSeen'] as String,
                    style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildDivider(),

                // Signal strength
                _buildInfoRow(
                  icon: Icons.wifi_rounded,
                  label: 'Signal Strength',
                  valueWidget: _buildSignalBars(data['signal'] as int),
                ),
                _buildDivider(),

                // Battery Status (Critical request!)
                _buildInfoRow(
                  icon: Icons.battery_charging_full_rounded,
                  label: 'Battery',
                  valueWidget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data['battery'] as String,
                        style: TextStyle(
                          color: data['batteryColor'] as Color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      Icon(
                        Icons.battery_std_rounded,
                        color: data['batteryColor'] as Color,
                        size: 14.0,
                      ),
                    ],
                  ),
                ),
                _buildDivider(),

                // Status
                _buildInfoRow(
                  icon: Icons.verified_user_outlined,
                  label: 'Status',
                  valueWidget: Text(
                    data['safeStatus'] as String,
                    style: TextStyle(
                      color: data['safeColor'] as Color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                    ),
                  ),
                ),
                _buildDivider(),

                // Location
                _buildInfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Location',
                  valueWidget: Text(
                    data['location'] as String,
                    style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildDivider(),

                // Public key
                _buildInfoRow(
                  icon: Icons.vpn_key_outlined,
                  label: 'Public Key',
                  valueWidget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _truncatePublicKey(data['publicKey'] as String),
                        style: const TextStyle(color: AegisColors.textSecondary, fontSize: 12.0, fontFamily: 'monospace'),
                      ),
                      const SizedBox(width: 6.0),
                      const Icon(Icons.copy_rounded, color: AegisColors.textSecondary, size: 14.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),

          // Bottom Action Buttons
          GestureDetector(
            onTap: onOpenChat,
            child: Container(
              width: double.infinity,
              height: 44.0,
              decoration: BoxDecoration(
                color: AegisColors.busyPurple,
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [
                  BoxShadow(
                    color: AegisColors.busyPurple.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.chat_bubble_outline_rounded, color: Colors.white, size: 16.0),
                  SizedBox(width: 8.0),
                  Text(
                    'OPEN CHAT',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          GestureDetector(
            onTap: onSendSos ?? () {},
            child: Container(
              width: double.infinity,
              height: 44.0,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: AegisColors.sosRed,
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.notifications_active_outlined, color: AegisColors.sosRed, size: 16.0),
                  SizedBox(width: 8.0),
                  Text(
                    'SEND SOS',
                    style: TextStyle(
                      color: AegisColors.sosRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required Widget valueWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 11.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AegisColors.textSecondary, size: 16.0),
              const SizedBox(width: 10.0),
              Text(
                label,
                style: const TextStyle(color: AegisColors.textSecondary, fontSize: 12.5),
              ),
            ],
          ),
          valueWidget,
        ],
      ),
    );
  }

  Widget _buildSignalBars(int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(4, (index) {
        final bool isFilled = index < count;
        final double barHeight = 6.0 + (index * 4.0);
        return Container(
          width: 3.0,
          height: barHeight,
          margin: const EdgeInsets.only(left: 2.0),
          decoration: BoxDecoration(
            color: isFilled ? AegisColors.busyPurple : const Color(0xFF374151),
            borderRadius: BorderRadius.circular(1.0),
          ),
        );
      }),
    );
  }

  String _truncatePublicKey(String key) {
    if (key.length <= 16) return key;
    return "${key.substring(0, 6)}...${key.substring(key.length - 8)}";
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFF1E293B),
      height: 1.0,
      thickness: 0.5,
    );
  }
}
