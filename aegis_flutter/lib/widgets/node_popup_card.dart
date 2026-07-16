import 'package:flutter/material.dart';

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

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE5E7EB);
  static const _violet = Color(0xFF7C3AED);
  static const _red = Color(0xFFFF3B30);
  static const _green = Color(0xFF22C55E);

  Map<String, dynamic> _data(String id) {
    if (id == 'SIG-4D2F') {
      return {
        'status': 'Offline',
        'statusColor': _muted,
        'hops': 'Offline',
        'lastSeen': '2 hours ago',
        'signal': 0,
        'battery': '12%',
        'batteryColor': _red,
        'safeStatus': 'Unknown',
        'safeColor': _muted,
        'location': 'Unknown',
        'publicKey':
            '4d2f9c2d8b6e4f1a9c2d8b6e4f1a9c2d8b6e4f1a9c2d8b6e4f1a9c2d8b6e4f1a',
      };
    }
    return {
      'status': 'Online',
      'statusColor': _green,
      'hops': '1 hop away',
      'lastSeen': 'Just now',
      'signal': 3,
      'battery': '64%',
      'batteryColor': _green,
      'safeStatus': 'Safe',
      'safeColor': _green,
      'location': '28.6139° N, 77.2090° E',
      'publicKey':
          '7f3a9c2d8b6e4f1a9c2d8b6e4f1a9c2d8b6e4f1a9c2d8b6e4f1a9c2d8b6e4f1a',
    };
  }

  @override
  Widget build(BuildContext context) {
    final d = _data(nodeId);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: _line,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFA855F7), Color(0xFF7C3AED)],
                      ),
                    ),
                    child: const Icon(Icons.person_rounded,
                        color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 12),
                  Text(nodeId,
                      style: const TextStyle(
                          color: _ink,
                          fontSize: 18,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (d['statusColor'] as Color).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                          color: (d['statusColor'] as Color).withOpacity(0.18)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                                color: d['statusColor'] as Color,
                                shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Text('${d['status']} • ${d['hops']}',
                            style: TextStyle(
                                color: d['statusColor'] as Color,
                                fontSize: 12,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _line),
              ),
              child: Column(
                children: [
                  _row(Icons.access_time_rounded, 'Last Seen',
                      value: d['lastSeen'] as String),
                  const Divider(height: 1, thickness: 1, color: _line),
                  _row(Icons.wifi_rounded, 'Signal Strength',
                      widget: _bars(d['signal'] as int)),
                  const Divider(height: 1, thickness: 1, color: _line),
                  _row(Icons.battery_charging_full_rounded, 'Battery',
                      value: d['battery'] as String,
                      valueColor: d['batteryColor'] as Color),
                  const Divider(height: 1, thickness: 1, color: _line),
                  _row(Icons.verified_user_outlined, 'Status',
                      value: d['safeStatus'] as String,
                      valueColor: d['safeColor'] as Color),
                  const Divider(height: 1, thickness: 1, color: _line),
                  _row(Icons.location_on_outlined, 'Location',
                      value: d['location'] as String, small: true),
                  const Divider(height: 1, thickness: 1, color: _line),
                  _row(Icons.vpn_key_outlined, 'Public Key',
                      widget: _keyRow(d['publicKey'] as String)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5F3FF),
                        foregroundColor: _violet,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        side: const BorderSide(color: Color(0xFFEDE9FE)),
                      ),
                      onPressed: onOpenChat,
                      icon: const Icon(Icons.chat_bubble_outline_rounded,
                          size: 18),
                      label: const Text('OPEN CHAT',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: onSendSos ?? () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _red,
                        side: const BorderSide(color: Color(0xFFFECACA)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.notifications_active_outlined,
                          size: 18),
                      label: const Text('SEND SOS',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, String label,
      {String? value, Color? valueColor, Widget? widget, bool small = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: _muted, size: 17),
              const SizedBox(width: 10),
              Text(label,
                  style: const TextStyle(
                      color: _muted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          widget ??
              Text(value ?? '',
                  style: TextStyle(
                      color: valueColor ?? _ink,
                      fontSize: small ? 12 : 13,
                      fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _bars(int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(
        4,
        (i) => Container(
          width: 4,
          height: 8.0 + (i * 5.0),
          margin: const EdgeInsets.only(left: 3),
          decoration: BoxDecoration(
            color: i < count ? _violet : const Color(0xFFD1D5DB),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
      ),
    );
  }

  Widget _keyRow(String key) {
    final t = key.length <= 16
        ? key
        : '${key.substring(0, 6)}...${key.substring(key.length - 8)}';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(t,
            style: const TextStyle(
                color: _muted, fontSize: 12, fontFamily: 'monospace')),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(4)),
          child: const Icon(Icons.copy_rounded, color: _muted, size: 12),
        ),
      ],
    );
  }
}
