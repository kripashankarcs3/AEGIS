import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import '../constants/aegis_styles.dart';
import 'auto_sync_screen.dart';
import 'language_screen.dart';
import 'battery_saver_screen.dart';
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
      backgroundColor: const Color(0xFF040814), // Deep space black background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: Container(
          margin: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF09111F).withOpacity(0.5),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1.0,
            ),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFamily: 'SF Pro Display',
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          children: [
            // 1. GENERAL SECTION
            const Text(
              'GENERAL',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8888AA),
                letterSpacing: 1.2,
                fontFamily: 'SF Pro Display',
              ),
            ),
            const SizedBox(height: 12.0),
            _buildCardSection([
              _buildNavRow(
                icon: Icons.sensors_outlined, // Hexagon/sensor style
                label: 'Mesh Network',
                statusText: 'Connected',
                statusColor: const Color(0xFF00FF88), // Bright green
                onTap: () {},
              ),
              _buildDivider(),
              _buildNavRow(
                icon: Icons.portable_wifi_off_outlined, // Satellite/offline style
                label: 'Offline Mode',
                statusText: 'Enabled',
                statusColor: const Color(0xFF00FF88),
                onTap: () {},
              ),
              _buildDivider(),
              _buildNavRow(
                icon: Icons.offline_bolt_outlined, // Battery style
                label: 'Battery Saver',
                statusText: 'Enabled',
                statusColor: const Color(0xFF00FF88),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BatterySaverScreen()),
                ),
              ),
              _buildDivider(),
              _buildNavRow(
                icon: Icons.settings_outlined, // Auto Sync gear style
                label: 'Auto Sync',
                statusText: 'When Connected',
                statusColor: const Color(0xFF00FF88),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AutoSyncScreen()),
                ),
              ),
              _buildDivider(),
              _buildNavRow(
                icon: Icons.track_changes_outlined, // concentric language circle
                label: 'Language',
                statusText: 'English',
                statusColor: const Color(0xFFA8B3C7),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LanguageScreen()),
                ),
              ),
              _buildDivider(),
              _buildNavRow(
                icon: Icons.access_time_rounded, // clock style
                label: 'Theme',
                statusText: 'Dark',
                statusColor: const Color(0xFFA8B3C7),
                onTap: () {},
              ),
              _buildDivider(),
              _buildNavRow(
                icon: Icons.info_outline_rounded,
                label: 'About AEGIS',
                statusText: 'v1.0.0',
                statusColor: const Color(0xFFA8B3C7),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                ),
              ),
            ]),
            const SizedBox(height: 28.0),

            // 2. NETWORK SECTION
            const Text(
              'NETWORK',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8888AA),
                letterSpacing: 1.2,
                fontFamily: 'SF Pro Display',
              ),
            ),
            const SizedBox(height: 12.0),
            _buildCardSection([
              _buildToggleRow(
                icon: Icons.wifi_protected_setup_rounded,
                label: 'Auto Connect',
                value: _autoConnect,
                onChanged: (v) => setState(() => _autoConnect = v),
              ),
              _buildDivider(),
              _buildToggleRow(
                icon: Icons.track_changes_rounded,
                label: 'Background Discovery',
                value: _backgroundDiscovery,
                onChanged: (v) => setState(() => _backgroundDiscovery = v),
              ),
              _buildDivider(),
              _buildToggleRow(
                icon: Icons.alt_route_rounded,
                label: 'Relay Through Me',
                value: _relayThroughMe,
                onChanged: (v) => setState(() => _relayThroughMe = v),
                sublabel: 'Allow other nodes to relay via this device',
              ),
            ]),
            const SizedBox(height: 28.0),

            // 3. SECURITY SECTION
            const Text(
              'SECURITY',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8888AA),
                letterSpacing: 1.2,
                fontFamily: 'SF Pro Display',
              ),
            ),
            const SizedBox(height: 12.0),
            _buildCardSection([
              _buildToggleRow(
                icon: Icons.lock_outline_rounded,
                label: 'Lock App',
                value: _lockApp,
                onChanged: (v) => setState(() => _lockApp = v),
              ),
            ]),
            const SizedBox(height: 120.0), // leave space for bottom bar
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildCardSection(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF09111F), // Matching squircle logo theme
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1.0,
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildNavRow({
    required IconData icon,
    required String label,
    required String statusText,
    required Color statusColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF040814),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.04),
                      width: 1.0,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white.withOpacity(0.7),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Colors.white.withOpacity(0.3),
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
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 11.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF040814),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.04),
                        width: 1.0,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white.withOpacity(0.7),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'SF Pro Display',
                    ),
                  ),
                ],
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF256DFF), // Electric blue switch track
                inactiveThumbColor: Colors.white.withOpacity(0.4),
                inactiveTrackColor: const Color(0xFF151E33),
              ),
            ],
          ),
          if (sublabel != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 44.0),
              child: Text(
                sublabel,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 11,
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1.0,
      color: Colors.white.withOpacity(0.05),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 40,
            offset: const Offset(0, 12),
            spreadRadius: -8,
          ),
          BoxShadow(
            color: const Color(0xFF256DFF).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF09111F).withOpacity(0.92),
                  const Color(0xFF08080E).withOpacity(0.92),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(context, 'Radar', Icons.radar_rounded),
                _buildNavItem(context, 'Chats', Icons.chat_bubble_outline_rounded),
                _buildSosFab(context),
                _buildNavItem(context, 'Resources', Icons.library_books_outlined),
                _buildNavItem(context, 'Map', Icons.map_outlined),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label, IconData icon) {
    return Expanded(
      child: InkWell(
        onTap: () {
          // Return to main shell and pop settings screen
          Navigator.of(context).pop();
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white.withOpacity(0.4),
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSosFab(BuildContext context) {
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF0030), // vibrant red
                  Color(0xFF8B0000), // dark red
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF0030).withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: const Center(
              child: Text(
                'SOS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
