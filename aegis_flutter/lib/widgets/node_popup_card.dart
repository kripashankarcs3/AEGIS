import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/aegis_colors.dart';
import '../providers/survivor_provider.dart';

class NodePopupCard extends ConsumerWidget {
  final String nodeId;
  final VoidCallback onOpenChat;
  final VoidCallback? onSendSos;

  const NodePopupCard({super.key, required this.nodeId, required this.onOpenChat, this.onSendSos});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final survivors = ref.watch(survivorProvider);
    final node = survivors[nodeId];

    final status = node?.status ?? 'unknown';
    final isOnline = status == 'safe' || status == 'have_resources';
    final statusColor = isOnline ? AegisColors.neonGreen : AegisColors.textMuted;
    final hopsText = isOnline ? '1 hop away' : 'Offline';
    final lastSeen = isOnline ? 'Just now' : '2 hours ago';
    final signal = isOnline ? 3 : 0;
    final battery = isOnline ? '64%' : '12%';
    final batteryColor = isOnline ? AegisColors.neonGreen : AegisColors.sosRed;
    final safeStatus = isOnline ? 'Safe' : 'Unknown';
    final safeColor = isOnline ? AegisColors.neonGreen : AegisColors.textMuted;
    final location = (node?.lat != null && node?.lng != null)
        ? '${node!.lat!.toStringAsFixed(4)}° ${node.lat! >= 0 ? "N" : "S"}, ${node.lng!.toStringAsFixed(4)}° ${node.lng! >= 0 ? "E" : "W"}'
        : 'Unknown';
    final publicKey = nodeId.toLowerCase().padRight(64, '0');

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF141428), Color(0xFF0E0E1E)]), borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28))),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(child: Container(width: 44, height: 5, decoration: BoxDecoration(color: AegisColors.textDim, borderRadius: BorderRadius.circular(3)))),
        SizedBox(height: 20),
        Center(child: Column(children: [
          Container(width: 64, height: 64, decoration: BoxDecoration(gradient: LinearGradient(colors: [AegisColors.violet.withOpacity(0.2), AegisColors.violet.withOpacity(0.05)]), shape: BoxShape.circle, border: Border.all(color: AegisColors.violet.withOpacity(0.2), width: 1.5)), child: Center(child: Icon(Icons.person_rounded, color: AegisColors.violet, size: 32))),
          SizedBox(height: 14),
          Text(nodeId, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.3)),
          SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: statusColor.withOpacity(0.2), width: 0.5)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
              SizedBox(width: 6),
              Text("$status  •  $hopsText", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor)),
            ]),
          ),
        ])),
        SizedBox(height: 28),
        Container(
          decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(16), border: Border.all(color: AegisColors.border1.withOpacity(0.4), width: 0.5)),
          child: Column(children: [
            _row(Icons.access_time_rounded, 'Last Seen', value: lastSeen),
            _divider(),
            _row(Icons.wifi_rounded, 'Signal Strength', widget: _bars(signal)),
            _divider(),
            _row(Icons.battery_charging_full_rounded, 'Battery', value: battery, valueColor: batteryColor),
            _divider(),
            _row(Icons.verified_user_outlined, 'Status', value: safeStatus, valueColor: safeColor),
            _divider(),
            _row(Icons.location_on_outlined, 'Location', value: location, small: true),
            _divider(),
            _row(Icons.vpn_key_outlined, 'Public Key', widget: _keyRow(publicKey)),
          ]),
        ),
        SizedBox(height: 24),
        GestureDetector(
          onTap: onOpenChat,
          child: Container(width: double.infinity, height: 50, decoration: BoxDecoration(gradient: AegisColors.purpleGradient, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: AegisColors.violet.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))]),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.chat_bubble_outline_rounded, color: Colors.white.withOpacity(0.9), size: 18),
              SizedBox(width: 10),
              Text('OPEN CHAT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 0.3)),
            ])),
        ),
        SizedBox(height: 12),
        GestureDetector(
          onTap: onSendSos ?? () {},
          child: Container(width: double.infinity, height: 50, decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(14), border: Border.all(color: AegisColors.sosRed.withOpacity(0.4), width: 1)),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.notifications_active_outlined, color: AegisColors.sosRed.withOpacity(0.9), size: 18),
              SizedBox(width: 10),
              Text('SEND SOS', style: TextStyle(color: AegisColors.sosRed.withOpacity(0.9), fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 0.3)),
            ])),
        ),
      ]),
    );
  }

  Widget _row(IconData icon, String label, {String? value, Color? valueColor, Widget? widget, bool small = false}) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: AegisColors.textSecondary, size: 17),
        SizedBox(width: 12),
        Text(label, style: TextStyle(color: AegisColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
      ]),
      widget ?? Text(value ?? '', style: TextStyle(color: valueColor ?? Colors.white, fontSize: small ? 12 : 13, fontWeight: FontWeight.w700)),
    ]));
  }

  Widget _bars(int count) {
    return Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: List.generate(4, (i) => Container(width: 4, height: 8.0 + (i * 5.0), margin: const EdgeInsets.only(left: 3), decoration: BoxDecoration(color: i < count ? AegisColors.violet : AegisColors.textDim, borderRadius: BorderRadius.circular(1)))));
  }

  Widget _keyRow(String key) {
    final t = key.length <= 16 ? key : "${key.substring(0, 6)}...${key.substring(key.length - 8)}";
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text(t, style: TextStyle(color: AegisColors.textSecondary, fontSize: 12, fontFamily: 'monospace')),
      SizedBox(width: 8),
      Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: AegisColors.border1.withOpacity(0.5), borderRadius: BorderRadius.circular(4)), child: Icon(Icons.copy_rounded, color: AegisColors.textSecondary, size: 12)),
    ]);
  }

  Widget _divider() {
    return Container(margin: const EdgeInsets.symmetric(horizontal: 16), height: 0.5, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.transparent, AegisColors.border1.withOpacity(0.4), Colors.transparent])));
  }
}
