import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/aegis_colors.dart';
import '../models/resource_item.dart';
import '../providers/identity_provider.dart';
import '../providers/mesh_provider.dart';
import '../services/storage_service.dart';
import 'help_support_screen.dart';
import 'identity_screen.dart';
import 'settings_screen.dart';
import 'emergency_contacts_screen.dart';
import 'devices_network_screen.dart';
import 'login_join_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final path = StorageService.getProfileImagePath();
    setState(() => _imagePath = path);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery, maxWidth: 512, maxHeight: 512);
    if (picked != null) {
      await StorageService.setProfileImagePath(picked.path);
      setState(() => _imagePath = picked.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = AegisColors.isLight;
    final bg = isLight ? const Color(0xFFF8FAFC) : const Color(0xFF050508);
    final cardBg = isLight ? Colors.white : const Color(0xFF0E0E1E);
    final textPrimary = AegisColors.textPrimary;
    final textSecondary = AegisColors.textSecondary;
    final border = isLight ? const Color(0xFFE2E8F0) : const Color(0xFF1E1E3A);
    final iconBg = isLight ? const Color(0xFFF1F5F9) : const Color(0xFF111122);
    final shadow = isLight ? const Color(0x11000000) : const Color(0x40000000);

    final myId = ref.watch(sigIdProvider);
    final meshResources = ref.watch(meshResourcesProvider);
    final peerCount = ref.watch(meshPeerCountProvider);
    final recentActivity = ref.watch(meshActivityProvider);

    final contributions = meshResources
        .where(
            (item) => item.nodeId == myId && item.type == ResourceType.offered)
        .length;
    final tasksJoined = peerCount;
    final peopleHelped = recentActivity
        .where((entry) =>
            entry.toLowerCase().contains('help') ||
            entry.contains('🆘') ||
            entry.contains('💬'))
        .length;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
              child: Column(
                children: [
                  _header(context, iconBg, textPrimary, border, shadow),
                  const SizedBox(height: 24),
                  _avatarAndName(
                      textPrimary, textSecondary, border, shadow, cardBg, bg),
                  const SizedBox(height: 18),
                  _activeBadge(isLight),
                  const SizedBox(height: 16),
                  _statsCard(cardBg, border, shadow, textPrimary, textSecondary,
                      contributions, tasksJoined, peopleHelped),
                  const SizedBox(height: 18),
                  _menuCard(context, cardBg, border, shadow, iconBg,
                      textPrimary, textSecondary),
                  const SizedBox(height: 22),
                  _logoutButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, Color iconBg, Color textPrimary,
      Color border, Color shadow) {
    return Row(
      children: [
        _topButton(Icons.arrow_back_rounded, () => Navigator.of(context).pop(),
            iconBg, textPrimary, border, shadow),
        const Spacer(),
        _topButton(Icons.more_vert_rounded, () {}, iconBg, textPrimary, border,
            shadow),
      ],
    );
  }

  Widget _topButton(IconData icon, VoidCallback onTap, Color iconBg,
      Color textPrimary, Color border, Color shadow) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(color: shadow, blurRadius: 14, offset: const Offset(0, 4))
          ],
        ),
        child: Icon(icon, color: textPrimary, size: 22),
      ),
    );
  }

  Widget _avatarAndName(Color textPrimary, Color textSecondary, Color border,
      Color shadow, Color cardBg, Color bg) {
    final sigId = ref.watch(sigIdProvider);
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cardBg,
                    border: Border.all(color: border, width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(48),
                    child: _imagePath != null
                        ? Image.file(File(_imagePath!),
                            fit: BoxFit.cover, width: 96, height: 96)
                        : Container(
                            width: 78,
                            height: 78,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFC05CFF), Color(0xFF7B4CE6)],
                              ),
                            ),
                            child: Icon(Icons.person_rounded,
                                color: Color(0xFFF6EDFF), size: 48),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(sigId,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1)),
              const SizedBox(height: 6),
              Text('ID: $sigId',
                  style: TextStyle(
                      color: textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1)),
            ],
          ),
          Positioned(
            right: 4,
            bottom: 76,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AegisColors.electricBlue,
                shape: BoxShape.circle,
                border: Border.all(color: bg, width: 2.5),
              ),
              child:
                  Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _activeBadge(bool isLight) {
    final green = isLight ? const Color(0xFF059669) : const Color(0xFF10B981);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: green, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text('Active',
              style: TextStyle(
                  color: green,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  height: 1)),
        ],
      ),
    );
  }

  Widget _statsCard(
      Color cardBg,
      Color border,
      Color shadow,
      Color textPrimary,
      Color textSecondary,
      int contributions,
      int tasksJoined,
      int peopleHelped) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(color: shadow, blurRadius: 14, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          _stat(Icons.groups_2_outlined, 'Contributions',
              contributions.toString(), textPrimary, textSecondary),
          _divider(border),
          _stat(Icons.assignment_turned_in_outlined, 'Tasks Joined',
              tasksJoined.toString(), textPrimary, textSecondary),
          _divider(border),
          _stat(Icons.favorite_border_rounded, 'People Helped',
              peopleHelped.toString(), textPrimary, textSecondary),
        ],
      ),
    );
  }

  Widget _stat(IconData icon, String label, String value, Color textPrimary,
      Color textSecondary) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AegisColors.violet, size: 22),
          const SizedBox(height: 6),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  color: textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  height: 1)),
        ],
      ),
    );
  }

  Widget _divider(Color border) =>
      Container(width: 1, height: 56, color: border);

  Widget _menuCard(BuildContext context, Color cardBg, Color border,
      Color shadow, Color iconBg, Color textPrimary, Color textSecondary) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(color: shadow, blurRadius: 14, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          _menuRow(context, Icons.person_outline_rounded, 'My Information',
              iconBg, textPrimary, textSecondary, () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const IdentityScreen()));
          }),
          _rowLine(border),
          _menuRow(context, Icons.contact_phone_outlined, 'Emergency Contacts',
              iconBg, textPrimary, textSecondary, () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const EmergencyContactsScreen()));
          }),
          _rowLine(border),
          _menuRow(context, Icons.wifi_tethering_rounded, 'Devices & Network',
              iconBg, textPrimary, textSecondary, () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const DevicesNetworkScreen()));
          }),
          _rowLine(border),
          _menuRow(context, Icons.settings_outlined, 'Settings', iconBg,
              textPrimary, textSecondary, () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()));
          }),
          _rowLine(border),
          _menuRow(context, Icons.help_outline_rounded, 'Help & Support',
              iconBg, textPrimary, textSecondary, () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HelpSupportScreen()));
          }),
        ],
      ),
    );
  }

  Widget _menuRow(
      BuildContext context,
      IconData icon,
      String label,
      Color iconBg,
      Color textPrimary,
      Color textSecondary,
      VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            const SizedBox(width: 20),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: iconBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: AegisColors.violet, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
                child: Text(label,
                    style: TextStyle(
                        color: textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600))),
            Icon(Icons.chevron_right_rounded, color: textSecondary, size: 24),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget _rowLine(Color border) => Divider(
      height: 1, thickness: 1, color: border, indent: 20, endIndent: 20);

  Widget _logoutButton() {
    return GestureDetector(
      onTap: () => _confirmLogout(),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AegisColors.sosRed.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AegisColors.sosRed.withValues(alpha: 0.3)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: Color(0xFFFF2D3D), size: 22),
            SizedBox(width: 12),
            Text('Log Out',
                style: TextStyle(
                    color: Color(0xFFFF2D3D),
                    fontSize: 16,
                    fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AegisColors.cardBg,
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const LoginJoinScreen(),
                  ),
                  (route) => false,
                );
              },
              child: Text('Log Out', style: TextStyle(color: AegisColors.sosRed)),
            ),
          ],
        ),
    );
  }
}
