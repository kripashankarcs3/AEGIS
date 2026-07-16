import 'package:flutter/material.dart';

import 'chat_conversation_screen.dart';
import 'main_shell.dart';

class SosIncomingOverlayScreen extends StatefulWidget {
  const SosIncomingOverlayScreen({super.key});

  @override
  State<SosIncomingOverlayScreen> createState() =>
      _SosIncomingOverlayScreenState();
}

class _SosIncomingOverlayScreenState extends State<SosIncomingOverlayScreen>
    with SingleTickerProviderStateMixin {
  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE9EAF0);
  static const _softRed = Color(0xFFFFEEF0);
  static const _softPink = Color(0xFFFFF4F5);

  late final AnimationController _pulseController;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 104),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(context),
              const SizedBox(height: 18),
              _alertHeader(),
              const SizedBox(height: 18),
              _detailsCard(),
              const SizedBox(height: 12),
              _actionRow(context),
              const SizedBox(height: 12),
              _expiryNote(),
              const SizedBox(height: 14),
              _incomingOverlayCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => MainShell(initialTab: index),
            ),
          );
        },
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFFF3B30),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x26FF3B30),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'SOS',
            style: TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFF1F3F7)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 14,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            splashRadius: 22,
            onPressed: () {},
            icon: const Icon(
              Icons.info_outline_rounded,
              size: 20,
              color: Color(0xFF111827),
            ),
          ),
        ),
      ],
    );
  }

  Widget _alertHeader() {
    return Center(
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _pulse,
            builder: (_, __) {
              final glow = 0.18 + (_pulse.value * 0.15);
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _softRed,
                      border: Border.all(
                        color: const Color(0xFFFFD8DA),
                        width: 1,
                      ),
                    ),
                  ),
                  Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFFE8EA),
                      border: Border.all(
                        color: const Color(0xFFFFC7CB),
                        width: 1.2,
                      ),
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF3B30),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(255, 59, 48, glow),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.notifications_active_rounded,
                      color: Colors.white,
                      size: 23,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'SOS ALERT RECEIVED',
            style: TextStyle(
              color: _ink,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Emergency assistance needed!',
            style: TextStyle(
              color: Color(0xFFFF3B30),
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 18,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _detailRow(
            icon: Icons.rss_feed_rounded,
            label: 'From',
            value: 'SIG-8AF3',
          ),
          const _RowDivider(),
          _detailRow(
            icon: Icons.medical_services_rounded,
            label: 'Category',
            value: 'Medical Emergency',
            trailing: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFFFFEEF0),
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(
                Icons.gps_fixed_rounded,
                color: Color(0xFFFF3B30),
                size: 14,
              ),
            ),
          ),
          const _RowDivider(),
          _detailRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: '28.6139° N, 77.2090° E',
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
              size: 20,
            ),
          ),
          const _RowDivider(),
          _detailRow(
            icon: Icons.hub_outlined,
            label: 'Hop Count',
            value: '3 hops away',
            trailing: const Icon(
              Icons.groups_2_outlined,
              color: Color(0xFF94A3B8),
              size: 18,
            ),
          ),
          const _RowDivider(),
          _detailRow(
            icon: Icons.access_time_rounded,
            label: 'Time',
            value: '10:24 AM • 12 May 2024',
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF94A3B8),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String label,
    required String value,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _softPink,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFFF3B30),
              size: 14,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF8B93A6),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: _ink,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _actionRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFFE5E7EB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text(
                'DISMISS',
                style: TextStyle(
                  color: _ink,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4A43),
                elevation: 0,
                shadowColor: const Color(0x28FF4A43),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        const ChatConversationScreen(nodeId: 'SIG-8AF3'),
                  ),
                );
              },
              icon: const Icon(
                Icons.chat_bubble_rounded,
                color: Colors.white,
                size: 18,
              ),
              label: const Text(
                'OPEN CHAT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _expiryNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD6D8)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_active_outlined,
              color: Color(0xFFFF3B30), size: 14),
          SizedBox(width: 8),
          Text(
            '3 beeps sent - Alert will auto-expire in 60s',
            style: TextStyle(
              color: Color(0xFFFF3B30),
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _incomingOverlayCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0E000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _OverlayBadge(),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SOS INCOMING OVERLAY',
                  style: TextStyle(
                    color: _ink,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Full-screen emergency alert with details,\nopen chat and dismiss options\nwith 3-beep notification.',
                  style: TextStyle(
                    color: _muted,
                    fontSize: 11.5,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF1F3F7),
    );
  }
}

class _OverlayBadge extends StatelessWidget {
  const _OverlayBadge();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: Color(0xFFFFE8EA),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Text(
            '18.',
            style: TextStyle(
              color: Color(0xFFFF3B30),
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  static const _muted = Color(0xFF8791A3);
  static const _blue = Color(0xFF2F6BFF);
  static const _line = Color(0xFFF0F2F7);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 94,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _line)),
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(child: _item(0, Icons.radar_rounded, 'Radar')),
            Expanded(
                child: _item(1, Icons.chat_bubble_outline_rounded, 'Chats')),
            Expanded(child: _sosItem()),
            Expanded(child: _item(3, Icons.folder_outlined, 'Resources')),
            Expanded(child: _item(4, Icons.map_outlined, 'Map')),
          ],
        ),
      ),
    );
  }

  Widget _item(int index, IconData icon, String label) {
    final selected = currentIndex == index;
    return InkWell(
      onTap: () => onTap(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 25,
            color: selected ? _blue : _muted,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: selected ? _blue : _muted,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sosItem() {
    return Center(
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF5C61), Color(0xFFFF3B30)],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x38FF3B30),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: const Center(
          child: Text(
            'SOS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
