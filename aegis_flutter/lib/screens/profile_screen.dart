import 'package:flutter/material.dart';

import 'help_support_screen.dart';
import 'identity_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE5E7EB);
  static const _purple = Color(0xFF7B4CE6);
  static const _red = Color(0xFFFF2D3D);
  static const _green = Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
              child: Column(
                children: [
                  _header(context),
                  const SizedBox(height: 24),
                  _avatarAndName(),
                  const SizedBox(height: 18),
                  _activeBadge(),
                  const SizedBox(height: 16),
                  _statsCard(),
                  const SizedBox(height: 18),
                  _menuCard(context),
                  const SizedBox(height: 22),
                  _logoutButton(),
                ],
              ),
            ),
            Positioned(
                left: 6, right: 6, bottom: 12, child: _bottomNav(context)),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        _topButton(Icons.arrow_back_rounded, () => Navigator.of(context).pop()),
        const Spacer(),
        _topButton(Icons.more_vert_rounded, () {}),
      ],
    );
  }

  Widget _topButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: const [
            BoxShadow(
                color: Color(0x16000000), blurRadius: 14, offset: Offset(0, 4))
          ],
        ),
        child: Icon(icon, color: _ink, size: 22),
      ),
    );
  }

  Widget _avatarAndName() {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: const Color(0xFFEFF2F6), width: 1),
          ),
          child: Center(
            child: Container(
              width: 78,
              height: 78,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFC05CFF), _purple],
                ),
              ),
              child: const Icon(Icons.person_rounded,
                  color: Color(0xFFF6EDFF), size: 48),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text(
          'Kripashankar Yadav',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: _ink,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1),
        ),
        const SizedBox(height: 6),
        const Text(
          'ID: NEXUS_7FA2B3',
          style: TextStyle(
              color: _muted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              height: 1),
        ),
      ],
    );
  }

  Widget _activeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFE5F8EE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Dot(color: _green, size: 10),
          SizedBox(width: 8),
          Text('Active',
              style: TextStyle(
                  color: _green,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  height: 1)),
        ],
      ),
    );
  }

  Widget _statsCard() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x11000000), blurRadius: 14, offset: Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          _stat(Icons.groups_2_outlined, 'Contributions', '24'),
          _divider(),
          _stat(Icons.assignment_turned_in_outlined, 'Tasks Joined', '6'),
          _divider(),
          _stat(Icons.favorite_border_rounded, 'People Helped', '18'),
        ],
      ),
    );
  }

  Widget _stat(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _purple, size: 22),
          const SizedBox(height: 6),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: _muted, fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  color: _ink,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  height: 1)),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 56, color: _line);

  Widget _menuCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x10000000), blurRadius: 14, offset: Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          _menuRow(context, Icons.person_outline_rounded, 'My Information', () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const IdentityScreen()));
          }),
          _rowLine(),
          _menuRow(context, Icons.contact_phone_outlined, 'Emergency Contacts',
              () {}),
          _rowLine(),
          _menuRow(context, Icons.wifi_tethering_rounded, 'Devices & Network',
              () {}),
          _rowLine(),
          _menuRow(context, Icons.settings_outlined, 'Settings', () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()));
          }),
          _rowLine(),
          _menuRow(context, Icons.help_outline_rounded, 'Help & Support', () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HelpSupportScreen()));
          }),
        ],
      ),
    );
  }

  Widget _menuRow(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
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
                color: const Color(0xFFF4F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: _purple, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      color: _ink, fontSize: 15, fontWeight: FontWeight.w600)),
            ),
            const Icon(Icons.chevron_right_rounded, color: _muted, size: 24),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget _rowLine() => const Divider(
      height: 1, thickness: 1, color: _line, indent: 20, endIndent: 20);

  Widget _logoutButton() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFCDD2)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout_rounded, color: _red, size: 22),
          SizedBox(width: 12),
          Text('Log Out',
              style: TextStyle(
                  color: _red, fontSize: 16, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _bottomNav(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x18000000), blurRadius: 18, offset: Offset(0, 6))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _navItem(Icons.radar_rounded, 'Radar',
                () => Navigator.of(context).pop()),
            _navItem(Icons.chat_bubble_outline_rounded, 'Chats',
                () => Navigator.of(context).pop()),
            Expanded(
              child: Center(
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: _red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x40FF2D3D),
                          blurRadius: 18,
                          spreadRadius: 1)
                    ],
                  ),
                  child: const Center(
                    child: Text('SOS',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900)),
                  ),
                ),
              ),
            ),
            _navItem(Icons.folder_outlined, 'Resources',
                () => Navigator.of(context).pop()),
            _navItem(
                Icons.map_outlined, 'Map', () => Navigator.of(context).pop()),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _muted, size: 22),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    color: _muted, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final double size;
  const _Dot({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}
