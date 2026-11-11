import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/aegis_colors.dart';
import '../providers/survivor_provider.dart';

class DevicesNetworkScreen extends ConsumerWidget {
  const DevicesNetworkScreen({super.key});

  String _formatLastSeen(int epochMs) {
    final diff = DateTime.now().millisecondsSinceEpoch - epochMs;
    if (diff < 60000) return 'just now';
    if (diff < 120000) return '1 min ago';
    if (diff < 3600000) return '${diff ~/ 60000} min ago';
    if (diff < 7200000) return '1 hour ago';
    return '${diff ~/ 3600000} hours ago';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final survivors = ref.watch(survivorProvider);
    final now = DateTime.now().millisecondsSinceEpoch;
    final devices = survivors.values.where((n) => now - n.lastSeen <= 120000).toList();

    final isLight = AegisColors.isLight;
    final bg = isLight ? const Color(0xFFF8FAFC) : AegisColors.background;
    final cardBg = isLight ? Colors.white : AegisColors.cardBg;
    final textPrimary = AegisColors.textPrimary;
    final textSecondary = AegisColors.textSecondary;
    final border = isLight ? const Color(0xFFE2E8F0) : AegisColors.border1;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isLight ? const Color(0xFFF1F5F9) : AegisColors.surface2,
            shape: BoxShape.circle,
            border: Border.all(color: border, width: 0.5),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: textPrimary, size: 18),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text('Devices & Network', style: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AegisColors.electricBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.refresh_rounded, color: AegisColors.electricBlue, size: 18),
              onPressed: () => ref.invalidate(survivorProvider),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Connection summary card
            Container(
              margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isLight
                      ? [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)]
                      : [const Color(0xFF1E1B4B), const Color(0xFF0E0E2E)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _summaryItem('Connected', '${devices.length}', AegisColors.neonGreen, textPrimary),
                  _summaryItem('Hops Avg', devices.isEmpty ? '0' : '${(5 - devices.map((d) => d.signalStrength).reduce((a, b) => a + b) / devices.length).clamp(1, 4).toStringAsFixed(1)}', AegisColors.electricBlue, textPrimary),
                  _summaryItem('Signal', devices.isNotEmpty ? 'Good' : 'None', AegisColors.amber, textPrimary),
                ],
              ),
            ),

            // Devices list header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('KNOWN DEVICES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: textSecondary, letterSpacing: 0.5)),
                  Text('${devices.length} total', style: TextStyle(fontSize: 11, color: textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: devices.isEmpty
                  ? Center(
                      child: Text('No devices found', style: TextStyle(color: textSecondary, fontSize: 14)),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        final node = devices[index];
                        final isOnline = now - node.lastSeen <= 60000;
                        final status = isOnline ? 'Online' : 'Away';
                        final statusColor = isOnline ? AegisColors.neonGreen : AegisColors.amber;
                        final lastSeen = _formatLastSeen(node.lastSeen);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.hub_rounded, color: statusColor, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(node.id, style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: statusColor.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(status, style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.w800)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Last seen $lastSeen', style: TextStyle(color: textSecondary, fontSize: 11)),
                                  ],
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded, color: textSecondary, size: 20),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(String label, String value, Color valueColor, Color textPrimary) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: valueColor, fontSize: 22, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: AegisColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
