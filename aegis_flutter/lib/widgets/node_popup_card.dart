import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/aegis_colors.dart';
import '../providers/survivor_provider.dart';

class NodePopupCard extends ConsumerWidget {
  final String nodeId;
  final VoidCallback onOpenChat;

  const NodePopupCard(
      {super.key,
      required this.nodeId,
      required this.onOpenChat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final survivors = ref.watch(survivorProvider);
    final node = survivors[nodeId];

    final status = node?.status ?? 'unknown';
    final isOnline = status == 'safe' || status == 'have_resources';
    final statusColor =
        isOnline ? AegisColors.neonGreen : AegisColors.textMuted;

    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final diffSec = node != null ? (nowMs - node.lastSeen) ~/ 1000 : 0;
    final lastSeenStr = node == null
        ? 'Unknown'
        : diffSec < 10
            ? 'Just now'
            : diffSec < 60
                ? '${diffSec}s ago'
                : diffSec < 3600
                    ? '${diffSec ~/ 60}m ago'
                    : '${diffSec ~/ 3600}h ago';

    final signal = node?.signalStrength ?? 0;
    final battery = node?.hasBattery == true ? '${node!.batteryLevel}%' : '--';
    final batteryColor = node?.hasBattery == true
        ? (node!.batteryLevel > 20 ? AegisColors.neonGreen : AegisColors.sosRed)
        : AegisColors.textMuted;
    final safeStatus = isOnline ? 'Safe' : 'Unknown';
    final safeColor = isOnline ? AegisColors.neonGreen : AegisColors.textMuted;
    final lat = node?.lat;
    final lng = node?.lng;
    final hasLocation =
        lat != null && lng != null && !(lat == 0.0 && lng == 0.0);
    final location = hasLocation
        ? '${lat.abs().toStringAsFixed(4)}° ${lat >= 0 ? "N" : "S"}, ${lng.abs().toStringAsFixed(4)}° ${lng >= 0 ? "E" : "W"}'
        : 'Unavailable';

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF141428), Color(0xFF0E0E1E)]),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28), topRight: Radius.circular(28))),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                        color: AegisColors.textDim,
                        borderRadius: BorderRadius.circular(3)))),
            SizedBox(height: 20),
            Center(
                child: Column(children: [
              Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        AegisColors.violet.withValues(alpha: 0.2),
                        AegisColors.violet.withValues(alpha: 0.05)
                      ]),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AegisColors.violet.withValues(alpha: 0.2),
                          width: 1.5)),
                  child: Center(
                      child: Icon(Icons.person_rounded,
                          color: AegisColors.violet, size: 32))),
              SizedBox(height: 14),
              Text(nodeId,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.3)),
              SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: statusColor.withValues(alpha: 0.2), width: 0.5)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                          color: statusColor, shape: BoxShape.circle)),
                  SizedBox(width: 6),
                  Text("$status  •  ${isOnline ? '${5 - (node?.signalStrength ?? 1)} hop(s) away' : 'Offline'}",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor)),
                ]),
              ),
            ])),
            SizedBox(height: 28),
            Container(
              decoration: BoxDecoration(
                  color: AegisColors.surface2,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AegisColors.border1.withValues(alpha: 0.4), width: 0.5)),
              child: Column(children: [
                _row(Icons.access_time_rounded, 'Last Seen',
                    value: lastSeenStr),
                _divider(),
                _row(Icons.wifi_rounded, 'Signal Strength',
                    widget: _bars(signal)),
                _divider(),
                _row(Icons.battery_charging_full_rounded, 'Battery',
                    value: battery, valueColor: batteryColor),
                _divider(),
                _row(Icons.verified_user_outlined, 'Status',
                    value: safeStatus, valueColor: safeColor),
                _divider(),
                _row(Icons.location_on_outlined, 'Location',
                    value: location, small: true),
                _divider(),
                _row(Icons.phone_android_rounded, 'Device',
                    value: node?.deviceName.isNotEmpty == true
                        ? node!.deviceName
                        : 'Unknown'),
                _divider(),
                _row(Icons.info_outline_rounded, 'Platform',
                    value: node?.platform.isNotEmpty == true
                        ? node!.platform
                        : 'Unknown'),
              ]),
            ),
            SizedBox(height: 24),
            GestureDetector(
              onTap: onOpenChat,
              child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      gradient: AegisColors.purpleGradient,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: AegisColors.violet.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6))
                      ]),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded,
                            color: Colors.white.withValues(alpha: 0.9), size: 18),
                        SizedBox(width: 10),
                        Text('OPEN CHAT',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                letterSpacing: 0.3)),
                      ])),
            ),

          ]),
    );
  }

  Widget _row(IconData icon, String label,
      {String? value, Color? valueColor, Widget? widget, bool small = false}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, color: AegisColors.textSecondary, size: 17),
            SizedBox(width: 12),
            Text(label,
                style: TextStyle(
                    color: AegisColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
          ]),
          widget ??
              Text(value ?? '',
                  style: TextStyle(
                      color: valueColor ?? Colors.white,
                      fontSize: small ? 12 : 13,
                      fontWeight: FontWeight.w700)),
        ]));
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
                    color: i < count ? AegisColors.violet : AegisColors.textDim,
                    borderRadius: BorderRadius.circular(1)))));
  }

  Widget _divider() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 0.5,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
              Colors.transparent,
              AegisColors.border1.withValues(alpha: 0.4),
              Colors.transparent
            ])));
  }
}
