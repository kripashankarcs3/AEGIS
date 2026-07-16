import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';

class DevicesNetworkScreen extends StatefulWidget {
  const DevicesNetworkScreen({super.key});

  @override
  State<DevicesNetworkScreen> createState() => _DevicesNetworkScreenState();
}

class _DevicesNetworkScreenState extends State<DevicesNetworkScreen> {
  final List<Map<String, dynamic>> _knownDevices = [];
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    // In future: load from StorageService.getAllSurvivorNodeModels()
    setState(() {
      _knownDevices.addAll([
        {'name': 'SIG-B2C1', 'status': 'Online', 'lastSeen': '2 min ago', 'hops': 1, 'type': 'Relay'},
        {'name': 'SIG-8AF3', 'status': 'Online', 'lastSeen': '5 min ago', 'hops': 2, 'type': 'Node'},
        {'name': 'SIG-C4E1', 'status': 'Away', 'lastSeen': '32 min ago', 'hops': 1, 'type': 'Node'},
        {'name': 'SIG-9E10', 'status': 'Busy', 'lastSeen': '12 min ago', 'hops': 3, 'type': 'Node'},
        {'name': 'SIG-1D9A', 'status': 'Offline', 'lastSeen': '2 hours ago', 'hops': 3, 'type': 'Node'},
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
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
              color: AegisColors.electricBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(_isScanning ? Icons.sensors_rounded : Icons.refresh_rounded, color: AegisColors.electricBlue, size: 18),
              onPressed: () {
                setState(() => _isScanning = !_isScanning);
              },
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
                  _summaryItem('Connected', '3', AegisColors.neonGreen, textPrimary),
                  _summaryItem('Hops Avg', '1.8', AegisColors.electricBlue, textPrimary),
                  _summaryItem('Signal', 'Good', AegisColors.amber, textPrimary),
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
                  Text('${_knownDevices.length} total', style: TextStyle(fontSize: 11, color: textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _knownDevices.length,
                itemBuilder: (context, index) {
                  final device = _knownDevices[index];
                  return _deviceTile(device, cardBg, border, textPrimary, textSecondary, isLight);
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

  Widget _deviceTile(Map<String, dynamic> device, Color cardBg, Color border, Color textPrimary, Color textSecondary, bool isLight) {
    final status = device['status'] as String;
    Color statusColor;
    switch (status) {
      case 'Online':
        statusColor = AegisColors.neonGreen;
      case 'Away':
        statusColor = AegisColors.amber;
      case 'Busy':
        statusColor = AegisColors.violet;
      default:
        statusColor = AegisColors.textMuted;
    }

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
              color: statusColor.withOpacity(0.12),
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
                    Text(device['name'] as String, style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(status, style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('${device['hops']} hops away • Last seen ${device['lastSeen']}', style: TextStyle(color: textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: textSecondary, size: 20),
        ],
      ),
    );
  }
}
