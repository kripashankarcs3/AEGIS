import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import '../constants/aegis_styles.dart';
import 'auto_sync_screen.dart';
import 'language_screen.dart';
import 'help_support_screen.dart';
import 'about_screen.dart';
import 'battery_saver_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoConnect = true; bool _backgroundDiscovery = true; bool _relayThroughMe = true; bool _lockApp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      appBar: AppBar(
        backgroundColor: AegisColors.surface0.withOpacity(0.95), elevation: 0,
        leading: Container(margin: const EdgeInsets.all(4), decoration: BoxDecoration(color: AegisColors.surface2, shape: BoxShape.circle, border: Border.all(color: AegisColors.border1, width: 0.5)), child: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20), onPressed: () => Navigator.of(context).pop())),
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: AegisStyles.padAll,
          children: [
            const Text('GENERAL', style: AegisStyles.overline),
            const SizedBox(height: 12),
            _section([
              _navRow(Icons.wifi_tethering_rounded, 'Mesh Network', 'Connected', AegisColors.neonGreen, () {}),
              _divider(),
              _navRow(Icons.cloud_off_rounded, 'Offline Mode', 'Enabled', AegisColors.neonGreen, () {}),
              _divider(),
              _navRow(Icons.battery_charging_full_rounded, 'Battery Saver', 'Enabled', AegisColors.neonGreen, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BatterySaverScreen()))),
              _divider(),
              _navRow(Icons.sync_rounded, 'Auto Sync', 'When Connected', AegisColors.neonGreen, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AutoSyncScreen()))),
              _divider(),
              _navRow(Icons.language_rounded, 'Language', 'English', AegisColors.textSecondary, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LanguageScreen()))),
              _divider(),
              _navRow(Icons.dark_mode_rounded, 'Theme', 'Dark', AegisColors.textSecondary, () {}),
              _divider(),
              _navRow(Icons.help_outline_rounded, 'Help & Support', 'Guides', AegisColors.textSecondary, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HelpSupportScreen()))),
              _divider(),
              _navRow(Icons.info_outline_rounded, 'About AEGIS', 'v1.0.0', AegisColors.textMuted, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutScreen()))),
            ]),
            const SizedBox(height: 28),
            const Text('NETWORK', style: AegisStyles.overline),
            const SizedBox(height: 12),
            _section([
              _toggleRow(Icons.autorenew_rounded, 'Auto Connect', _autoConnect, (v) => setState(() => _autoConnect = v)),
              _divider(),
              _toggleRow(Icons.find_in_page_outlined, 'Background Discovery', _backgroundDiscovery, (v) => setState(() => _backgroundDiscovery = v)),
              _divider(),
              _toggleRow(Icons.alt_route_rounded, 'Relay Through Me', _relayThroughMe, (v) => setState(() => _relayThroughMe = v), sublabel: 'Allow other nodes to relay via this device'),
            ]),
            const SizedBox(height: 28),
            const Text('SECURITY', style: AegisStyles.overline),
            const SizedBox(height: 12),
            _section([_toggleRow(Icons.lock_outline_rounded, 'Lock App', _lockApp, (v) => setState(() => _lockApp = v))]),
          ],
        ),
      ),
    );
  }

  Widget _section(List<Widget> children) {
    return Container(decoration: BoxDecoration(gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AegisColors.cardBg, AegisColors.surface2]), borderRadius: BorderRadius.circular(18), border: Border.all(color: AegisColors.border1.withOpacity(0.4), width: 0.5), boxShadow: AegisColors.cardShadow),
      child: Column(children: children));
  }

  Widget _navRow(IconData icon, String label, String statusText, Color statusColor, VoidCallback onTap) {
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(18), child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 32, height: 32, decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: AegisColors.textSecondary, size: 16)),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: AegisColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500)),
      ]),
      Row(mainAxisSize: MainAxisSize.min, children: [
        Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.w700, fontSize: 12)),
        const SizedBox(width: 6),
        const Icon(Icons.chevron_right, size: 16, color: AegisColors.textMuted),
      ]),
    ])));
  }

  Widget _toggleRow(IconData icon, String label, bool value, ValueChanged<bool> onChanged, {String? sublabel}) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 32, height: 32, decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: AegisColors.textSecondary, size: 16)),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: AegisColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500)),
        ]),
        Switch(value: value, onChanged: onChanged, activeColor: Colors.white, activeTrackColor: AegisColors.electricBlue, inactiveThumbColor: AegisColors.textMuted, inactiveTrackColor: AegisColors.border1),
      ]),
      if (sublabel != null) ...[
        const SizedBox(height: 4),
        Padding(padding: const EdgeInsets.only(left: 44), child: Text(sublabel, style: TextStyle(color: AegisColors.textMuted.withOpacity(0.7), fontSize: 10))),
      ],
    ]));
  }

  Widget _divider() {
    return Container(margin: const EdgeInsets.symmetric(horizontal: 16), height: 0.5, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.transparent, AegisColors.border1.withOpacity(0.3), Colors.transparent])));
  }
}
