import 'package:flutter/material.dart';

import '../providers/theme_provider.dart';
import 'about_screen.dart';
import 'auto_sync_screen.dart';
import 'battery_saver_screen.dart';
import 'language_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoConnect = true;
  bool _backgroundDiscovery = true;
  bool _relayThroughMe = true;
  bool _lockApp = true;

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE5E7EB);
  static const _blue = Color(0xFF2563EB);
  static const _green = Color(0xFF22C55E);
  static const _violet = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProviderWidget.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Settings',
          style:
              TextStyle(color: _ink, fontSize: 20, fontWeight: FontWeight.w900),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: _line),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 120),
          children: [
            _section('APPEARANCE'),
            const SizedBox(height: 10),
            _card([
              _themeRow(
                  Icons.brightness_auto_rounded,
                  'Follow System',
                  themeProvider.mode == AppThemeMode.system,
                  () => themeProvider.setMode(AppThemeMode.system)),
              const Divider(height: 1, thickness: 1, color: _line),
              _themeRow(
                  Icons.light_mode_rounded,
                  'Light',
                  themeProvider.mode == AppThemeMode.light,
                  () => themeProvider.setMode(AppThemeMode.light)),
              const Divider(height: 1, thickness: 1, color: _line),
              _themeRow(
                  Icons.dark_mode_rounded,
                  'Dark',
                  themeProvider.mode == AppThemeMode.dark,
                  () => themeProvider.setMode(AppThemeMode.dark)),
            ]),
            const SizedBox(height: 24),
            _section('GENERAL'),
            const SizedBox(height: 10),
            _card([
              _navRow(Icons.sensors_outlined, 'Mesh Network', 'Connected',
                  _green, () {}),
              const Divider(height: 1, thickness: 1, color: _line),
              _navRow(
                  Icons.offline_bolt_outlined,
                  'Battery Saver',
                  'Enabled',
                  _green,
                  () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const BatterySaverScreen()))),
              const Divider(height: 1, thickness: 1, color: _line),
              _navRow(
                  Icons.settings_outlined,
                  'Auto Sync',
                  'When Connected',
                  _green,
                  () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const AutoSyncScreen()))),
              const Divider(height: 1, thickness: 1, color: _line),
              _navRow(
                  Icons.track_changes_outlined,
                  'Language',
                  'English',
                  _muted,
                  () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const LanguageScreen()))),
              const Divider(height: 1, thickness: 1, color: _line),
              _navRow(
                  Icons.info_outline_rounded,
                  'About AEGIS',
                  'v1.0.0',
                  _muted,
                  () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AboutScreen()))),
            ]),
            const SizedBox(height: 24),
            _section('NETWORK'),
            const SizedBox(height: 10),
            _card([
              _toggleRow(Icons.wifi_protected_setup_rounded, 'Auto Connect',
                  _autoConnect, (v) => setState(() => _autoConnect = v)),
              const Divider(height: 1, thickness: 1, color: _line),
              _toggleRow(
                  Icons.track_changes_rounded,
                  'Background Discovery',
                  _backgroundDiscovery,
                  (v) => setState(() => _backgroundDiscovery = v)),
              const Divider(height: 1, thickness: 1, color: _line),
              _toggleRow(Icons.alt_route_rounded, 'Relay Through Me',
                  _relayThroughMe, (v) => setState(() => _relayThroughMe = v),
                  sublabel: 'Allow other nodes to relay via this device'),
            ]),
            const SizedBox(height: 24),
            _section('SECURITY'),
            const SizedBox(height: 10),
            _card([
              _toggleRow(Icons.lock_outline_rounded, 'Lock App', _lockApp,
                  (v) => setState(() => _lockApp = v)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) {
    return Row(
      children: [
        Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
                color: _violet, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                color: _muted,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.6)),
      ],
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x10000000), blurRadius: 14, offset: Offset(0, 4)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _themeRow(
      IconData icon, String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _iconTile(icon, selected ? _blue : _muted),
                const SizedBox(width: 12),
                Text(label,
                    style: TextStyle(
                        color: selected ? _ink : _muted,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? _blue : Colors.transparent,
                border: Border.all(color: selected ? _blue : _line),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _navRow(IconData icon, String title, String subtitle,
      Color statusColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _iconTile(icon, _muted),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: _ink,
                            fontSize: 14,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(subtitle,
                        style: TextStyle(color: statusColor, fontSize: 11.5)),
                  ],
                ),
              ],
            ),
            const Icon(Icons.chevron_right_rounded, size: 18, color: _muted),
          ],
        ),
      ),
    );
  }

  Widget _toggleRow(
      IconData icon, String label, bool value, ValueChanged<bool> onChanged,
      {String? sublabel}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _iconTile(icon, _muted),
                  const SizedBox(width: 12),
                  Text(label,
                      style: const TextStyle(
                          color: _ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                ],
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: _blue,
                inactiveThumbColor: const Color(0xFFCBD5E1),
                inactiveTrackColor: const Color(0xFFE2E8F0),
              ),
            ],
          ),
          if (sublabel != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 44),
              child: Text(sublabel,
                  style: const TextStyle(
                      color: _muted, fontSize: 11.5, height: 1.3)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _iconTile(IconData icon, Color color) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _line),
      ),
      child: Icon(icon, color: color, size: 17),
    );
  }
}
