import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/aegis_colors.dart';
import '../services/storage_service.dart';
import '../providers/theme_provider.dart';
import '../providers/identity_provider.dart';
import '../providers/mesh_provider.dart';
import '../providers/survivor_provider.dart';
import 'auto_sync_screen.dart';
import 'language_screen.dart';
import 'battery_saver_screen.dart';
import 'about_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _autoConnect = true;
  bool _backgroundDiscovery = true;
  bool _relayThroughMe = true;
  bool _lockApp = true;

  @override
  void initState() {
    super.initState();
    _autoConnect = StorageService.getSetting('setting_auto_connect') ?? true;
    _backgroundDiscovery = StorageService.getSetting('setting_bg_discovery') ?? true;
    _relayThroughMe = StorageService.getSetting('setting_relay') ?? true;
    _lockApp = StorageService.getSetting('setting_lock_app') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = ThemeProviderWidget.of(context);
    return Scaffold(
      backgroundColor: AegisColors.background, // Deep space black background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: Container(
          margin: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: AegisColors.cardBg.withValues(alpha: 0.5),
            shape: BoxShape.circle,
            border: Border.all(
              color: AegisColors.border1,
              width: 1.0,
            ),
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: AegisColors.textPrimary,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w700,
            color: AegisColors.textPrimary,
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
            // 0. APPEARANCE SECTION
            Text(
              'APPEARANCE',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: AegisColors.textSecondary,
                letterSpacing: 1.2,
                fontFamily: 'SF Pro Display',
              ),
            ),
            SizedBox(height: 12.0),
            _buildCardSection([
              _buildThemeOption(
                icon: Icons.brightness_auto_rounded,
                label: 'Follow System',
                selected: themeProvider.mode == AppThemeMode.system,
                onTap: () => themeProvider.setMode(AppThemeMode.system),
              ),
              _buildDivider(),
              _buildThemeOption(
                icon: Icons.light_mode_rounded,
                label: 'Light',
                selected: themeProvider.mode == AppThemeMode.light,
                onTap: () => themeProvider.setMode(AppThemeMode.light),
              ),
              _buildDivider(),
              _buildThemeOption(
                icon: Icons.dark_mode_rounded,
                label: 'Dark',
                selected: themeProvider.mode == AppThemeMode.dark,
                onTap: () => themeProvider.setMode(AppThemeMode.dark),
              ),
            ]),
            SizedBox(height: 28.0),

            // 1. GENERAL SECTION
            Text(
              'GENERAL',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: AegisColors.textSecondary,
                letterSpacing: 1.2,
                fontFamily: 'SF Pro Display',
              ),
            ),
            SizedBox(height: 12.0),
            _buildCardSection([
              _buildNavRow(
                icon: Icons.sensors_outlined,
                label: 'Mesh Network',
                statusText: 'Connected',
                statusColor: const Color(0xFF00FF88),
                onTap: () => _showMeshInfo(context),
              ),
              _buildDivider(),
              _buildNavRow(
                icon: Icons.portable_wifi_off_outlined,
                label: 'Offline Mode',
                statusText: 'Enabled',
                statusColor: const Color(0xFF00FF88),
                onTap: () => _showOfflineInfo(context),
              ),
              _buildDivider(),
              _buildNavRow(
                icon: Icons.offline_bolt_outlined,
                label: 'Battery Saver',
                statusText: 'Enabled',
                statusColor: const Color(0xFF00FF88),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BatterySaverScreen()),
                ),
              ),
              _buildDivider(),
              _buildNavRow(
                icon: Icons.settings_outlined,
                label: 'Auto Sync',
                statusText: 'When Connected',
                statusColor: const Color(0xFF00FF88),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AutoSyncScreen()),
                ),
              ),
              _buildDivider(),
              _buildNavRow(
                icon: Icons.track_changes_outlined,
                label: 'Language',
                statusText: 'English',
                statusColor: const Color(0xFFA8B3C7),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const LanguageScreen()),
                ),
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
            SizedBox(height: 28.0),

            // 2. NETWORK SECTION
            Text(
              'NETWORK',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: AegisColors.textSecondary,
                letterSpacing: 1.2,
                fontFamily: 'SF Pro Display',
              ),
            ),
            SizedBox(height: 12.0),
            _buildCardSection([
              _buildToggleRow(
                icon: Icons.wifi_protected_setup_rounded,
                label: 'Auto Connect',
                value: _autoConnect,
                onChanged: (v) {
                  setState(() => _autoConnect = v);
                  StorageService.setSetting('setting_auto_connect', v);
                },
              ),
              _buildDivider(),
              _buildToggleRow(
                icon: Icons.track_changes_rounded,
                label: 'Background Discovery',
                value: _backgroundDiscovery,
                onChanged: (v) {
                  setState(() => _backgroundDiscovery = v);
                  StorageService.setSetting('setting_bg_discovery', v);
                },
              ),
              _buildDivider(),
              _buildToggleRow(
                icon: Icons.alt_route_rounded,
                label: 'Relay Through Me',
                value: _relayThroughMe,
                onChanged: (v) {
                  setState(() => _relayThroughMe = v);
                  StorageService.setSetting('setting_relay', v);
                },
                sublabel: 'Allow other nodes to relay via this device',
              ),
            ]),
            SizedBox(height: 28.0),

            // 3. SECURITY SECTION
            Text(
              'SECURITY',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: AegisColors.textSecondary,
                letterSpacing: 1.2,
                fontFamily: 'SF Pro Display',
              ),
            ),
            SizedBox(height: 12.0),
            _buildCardSection([
              _buildToggleRow(
                icon: Icons.lock_outline_rounded,
                label: 'Lock App',
                value: _lockApp,
                onChanged: (v) {
                  setState(() => _lockApp = v);
                  StorageService.setSetting('setting_lock_app', v);
                },
              ),
            ]),
            SizedBox(height: 120.0),
          ],
        ),
      ),
    );
  }

  void _showMeshInfo(BuildContext context) {
    final sigId = ref.read(identityProvider).sigId;
    final meshState = ref.read(meshProvider);
    final peerCount = ref.read(survivorProvider).values.where((n) => n.id != sigId).length;
    final isConnected = meshState.isConnected;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AegisColors.surface1,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(color: AegisColors.textMuted, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: AegisColors.neonGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.sensors_outlined, color: AegisColors.neonGreen, size: 22),
                ),
                const SizedBox(width: 14),
                Text('Mesh Network', style: TextStyle(color: AegisColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 20),
            _infoRow('Status', isConnected ? 'Connected' : 'Disconnected', isConnected ? AegisColors.neonGreen : AegisColors.sosRed),
            _infoRow('Node ID', sigId, AegisColors.textPrimary),
            _infoRow('Peers', '$peerCount active', AegisColors.textPrimary),
            _infoRow('Transport', 'WiFi Direct + BLE', AegisColors.textPrimary),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: TextButton.styleFrom(
                  backgroundColor: AegisColors.cardBg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('Close', style: TextStyle(color: AegisColors.textPrimary, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOfflineInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AegisColors.surface1,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(color: AegisColors.textMuted, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: AegisColors.amber.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.portable_wifi_off_outlined, color: AegisColors.amber, size: 22),
                ),
                const SizedBox(width: 14),
                Text('Offline Mode', style: TextStyle(color: AegisColors.textPrimary, fontSize: 20, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'When enabled, AEGIS will only communicate via mesh network and will not use any internet connection. All data is synced peer-to-peer.',
              style: TextStyle(color: AegisColors.textSecondary, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 16),
            _infoRow('Status', 'Enabled', AegisColors.neonGreen),
            _infoRow('Data Sync', 'Mesh only', AegisColors.textPrimary),
            _infoRow('Internet', 'Blocked', AegisColors.amber),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: TextButton.styleFrom(
                  backgroundColor: AegisColors.cardBg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('Close', style: TextStyle(color: AegisColors.textPrimary, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AegisColors.textSecondary, fontSize: 13)),
          Text(value, style: TextStyle(color: valueColor, fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildCardSection(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AegisColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AegisColors.border1,
          width: 1.0,
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildThemeOption({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 13.0),
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
                    color: AegisColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AegisColors.border1,
                      width: 1.0,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: selected
                        ? const Color(0xFF256DFF)
                        : Colors.white.withValues(alpha: 0.7),
                    size: 16,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? AegisColors.textPrimary : AegisColors.textSecondary,
                    fontSize: 15,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
              ],
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xFF256DFF)
                      : Colors.white.withValues(alpha: 0.2),
                  width: selected ? 2.0 : 1.5,
                ),
                color: selected
                    ? const Color(0xFF256DFF)
                    : Colors.transparent,
              ),
              child: selected
                  ? Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
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
                    color: AegisColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AegisColors.border1,
                      width: 1.0,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: AegisColors.textSecondary,
                    size: 16,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: AegisColors.textPrimary,
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
                SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
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
                      color: AegisColors.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AegisColors.border1,
                        width: 1.0,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: AegisColors.textSecondary,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      color: AegisColors.textPrimary,
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
                activeThumbColor: AegisColors.cardBg,
                activeTrackColor: AegisColors.electricBlue,
                inactiveThumbColor: AegisColors.textMuted,
                inactiveTrackColor: AegisColors.border2,
              ),
            ],
          ),
          if (sublabel != null) ...[
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 44.0),
              child: Text(
                sublabel,
                style: TextStyle(
                  color: AegisColors.textSecondary,
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
      color: AegisColors.border1,
    );
  }
}
