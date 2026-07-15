import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'auto_sync_screen.dart';
import 'language_screen.dart';
import 'help_support_screen.dart';
import 'about_screen.dart';

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
          'Settings',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          children: [
            // 1. GENERAL Section
            const Text(
              'GENERAL',
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
                color: AegisColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                color: AegisColors.cardBackground,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AegisColors.border, width: 1.0),
              ),
              child: Column(
                children: [
                  _buildNavigationRow(
                    icon: Icons.wifi_tethering_rounded,
                    label: 'Mesh Network',
                    statusText: 'Connected',
                    statusColor: AegisColors.activeGreen,
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    icon: Icons.cloud_off_rounded,
                    label: 'Offline Mode',
                    statusText: 'Enabled',
                    statusColor: AegisColors.activeGreen,
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    icon: Icons.battery_charging_full_rounded,
                    label: 'Battery Saver',
                    statusText: 'Enabled',
                    statusColor: AegisColors.activeGreen,
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    icon: Icons.sync_rounded,
                    label: 'Auto Sync',
                    statusText: 'When Connected',
                    statusColor: AegisColors.activeGreen,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AutoSyncScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    icon: Icons.language_rounded,
                    label: 'Language',
                    statusText: 'English',
                    statusColor: AegisColors.textSecondary,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LanguageScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    icon: Icons.dark_mode_rounded,
                    label: 'Theme',
                    statusText: 'Dark',
                    statusColor: AegisColors.textSecondary,
                    onTap: () {},
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    icon: Icons.help_outline_rounded,
                    label: 'Help & Support',
                    statusText: 'Guides',
                    statusColor: AegisColors.textSecondary,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HelpSupportScreen(),
                        ),
                      );
                    },
                  ),
                  _buildDivider(),
                  _buildNavigationRow(
                    icon: Icons.info_outline_rounded,
                    label: 'About AEGIS',
                    statusText: 'v1.0.0',
                    statusColor: AegisColors.textMuted,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AboutScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // 2. NETWORK Section
            const Text(
              'NETWORK',
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
                color: AegisColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                color: AegisColors.cardBackground,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AegisColors.border, width: 1.0),
              ),
              child: Column(
                children: [
                  _buildToggleRow(
                    icon: Icons.autorenew_rounded,
                    label: 'Auto Connect',
                    value: _autoConnect,
                    onChanged: (val) {
                      setState(() {
                        _autoConnect = val;
                      });
                    },
                  ),
                  _buildDivider(),
                  _buildToggleRow(
                    icon: Icons.find_in_page_outlined,
                    label: 'Background Discovery',
                    value: _backgroundDiscovery,
                    onChanged: (val) {
                      setState(() {
                        _backgroundDiscovery = val;
                      });
                    },
                  ),
                  _buildDivider(),
                  _buildToggleRow(
                    icon: Icons.alt_route_rounded,
                    label: 'Relay Through Me',
                    value: _relayThroughMe,
                    onChanged: (val) {
                      setState(() {
                        _relayThroughMe = val;
                      });
                    },
                    sublabel: 'Allow other nodes to relay via this device',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // 3. SECURITY Section
            const Text(
              'SECURITY',
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
                color: AegisColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                color: AegisColors.cardBackground,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AegisColors.border, width: 1.0),
              ),
              child: _buildToggleRow(
                icon: Icons.lock_outline_rounded,
                label: 'Lock App',
                value: _lockApp,
                onChanged: (val) {
                  setState(() {
                    _lockApp = val;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationRow({
    required IconData icon,
    required String label,
    required String statusText,
    required Color statusColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
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
            Row(
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
                const SizedBox(width: 6.0),
                const Icon(
                  Icons.chevron_right,
                  size: 14.0,
                  color: AegisColors.textMuted,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildToggleRow({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? sublabel,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              SizedBox(
                height: 24.0,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: Colors.white,
                  activeTrackColor: AegisColors.primaryBlue,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          if (sublabel != null) ...[
            const SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.only(left: 28.0),
              child: Text(
                sublabel,
                style: const TextStyle(
                  color: AegisColors.textMuted,
                  fontSize: 9.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFF1E293B),
      height: 1.0,
      thickness: 0.5,
    );
  }
}
