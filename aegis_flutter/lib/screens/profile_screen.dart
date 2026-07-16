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
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 126),
              child: Column(
                children: [
                  _header(context),
                  const SizedBox(height: 35),
                  _avatar(),
                  const SizedBox(height: 23),
                  const Text(
                    'Kripashankar Yadav',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: _ink,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        height: 1),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'ID: NEXUS_7FA2B3',
                    style: TextStyle(
                        color: _muted,
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        height: 1),
                  ),
                  const SizedBox(height: 25),
                  _activeBadge(),
                  const SizedBox(height: 18),
                  _statsCard(),
                  const SizedBox(height: 22),
                  _menuCard(context),
                  const SizedBox(height: 28),
                  _logoutButton(),
                ],
              ),
            ),
            Positioned(
                left: 6, right: 6, bottom: 18, child: _bottomNav(context)),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        _topButton(Icons.arrow_back_rounded, () => Navigator.of(context).pop()),
        const SizedBox(width: 30),
        const Expanded(
          child: Text('Profile',
              style: TextStyle(
                  color: _ink,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  height: 1)),
        ),
        _topButton(Icons.more_vert_rounded, () {}),
      ],
    );
  }

  Widget _topButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: const [
            BoxShadow(
                color: Color(0x16000000), blurRadius: 22, offset: Offset(0, 8))
          ],
        ),
        child: Icon(icon, color: _ink, size: 33),
      ),
    );
  }

  Widget _avatar() {
    return Container(
      width: 190,
      height: 190,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEFF2F6), width: 1),
      ),
      child: Center(
        child: Container(
          width: 146,
          height: 146,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFC05CFF), _purple],
            ),
          ),
          child: const Icon(Icons.person_rounded,
              color: Color(0xFFF6EDFF), size: 96),
        ),
      ),
    );
  }

  Widget _activeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE5F8EE),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Dot(color: _green, size: 15),
          SizedBox(width: 11),
          Text('Active',
              style: TextStyle(
                  color: _green,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  height: 1)),
        ],
      ),
    );
  }

  Widget _statsCard() {
    return Container(
      height: 133,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x11000000), blurRadius: 18, offset: Offset(0, 5))
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
          Icon(icon, color: _purple, size: 32),
          const SizedBox(height: 12),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: _muted, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 18),
          Text(value,
              style: const TextStyle(
                  color: _ink,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  height: 1)),
        ],
      ),
    );
  }

  Widget _divider() => Container(width: 1, height: 88, color: _line);

  Widget _menuCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x10000000), blurRadius: 18, offset: Offset(0, 5))
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
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        height: 92,
        child: Row(
          children: [
            const SizedBox(width: 34),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: _purple, size: 29),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(label,
                  style: const TextStyle(
                      color: _ink, fontSize: 21, fontWeight: FontWeight.w600)),
            ),
            const Icon(Icons.chevron_right_rounded, color: _muted, size: 34),
            const SizedBox(width: 32),
          ],
        ),
      ),
    );
  }

  Widget _rowLine() => const Divider(
      height: 1, thickness: 1, color: _line, indent: 34, endIndent: 34);

  Widget _logoutButton() {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFCDD2)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout_rounded, color: _red, size: 29),
          SizedBox(width: 18),
          Text('Log Out',
              style: TextStyle(
                  color: _red, fontSize: 23, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _bottomNav(BuildContext context) {
    return Container(
      height: 112,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x18000000), blurRadius: 24, offset: Offset(0, 8))
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
                  width: 82,
                  height: 82,
                  decoration: const BoxDecoration(
                    color: _red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x40FF2D3D),
                          blurRadius: 24,
                          spreadRadius: 2)
                    ],
                  ),
                  child: const Center(
                    child: Text('SOS',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
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
            Icon(icon, color: _muted, size: 31),
            const SizedBox(height: 9),
            Text(label,
                style: const TextStyle(
                    color: _muted, fontSize: 17, fontWeight: FontWeight.w600)),
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
