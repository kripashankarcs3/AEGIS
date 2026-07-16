import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE5E7EB);
  static const _violet = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
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
          'About AEGIS',
          style:
              TextStyle(color: _ink, fontSize: 20, fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded, color: _ink),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: _line),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
          children: [
            _hero(),
            const SizedBox(height: 20),
            _infoCard(),
            const SizedBox(height: 14),
            _linksCard(),
          ],
        ),
      ),
    );
  }

  Widget _hero() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 94,
            height: 94,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF5F3FF),
              border: Border.all(color: const Color(0xFFEDE9FE)),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x10000000),
                    blurRadius: 16,
                    offset: Offset(0, 4)),
              ],
            ),
            child: const Center(
              child: Text(
                'A',
                style: TextStyle(
                  color: _violet,
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text('AEGIS',
              style: TextStyle(
                  color: _ink, fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          const Text('Mesh Network',
              style: TextStyle(
                  color: _violet, fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F3FF),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFEDE9FE)),
            ),
            child: const Text('v1.0.0',
                style: TextStyle(
                    color: _violet,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: 14),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'AEGIS is an offline-first emergency communication platform designed to keep people connected when the network gets shaky.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 12.5, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
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
      child: Column(
        children: [
          _row('Version', '1.0.0'),
          const Divider(height: 1, thickness: 1, color: _line),
          _row('Build', '100'),
          const Divider(height: 1, thickness: 1, color: _line),
          _row('Website', 'aegis.app', valueColor: _violet),
          const Divider(height: 1, thickness: 1, color: _line),
          _linkRow('Terms of Service'),
          const Divider(height: 1, thickness: 1, color: _line),
          _linkRow('Privacy Policy'),
          const Divider(height: 1, thickness: 1, color: _line),
          _linkRow('Open Source Licenses'),
        ],
      ),
    );
  }

  Widget _linksCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: _violet, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Built for local-first coordination, fast recovery, and calm communication when it matters most.',
              style: TextStyle(color: _muted, fontSize: 12.5, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color valueColor = _ink}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: _muted, fontSize: 12.5)),
          Text(value,
              style: TextStyle(
                  color: valueColor,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _linkRow(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  color: _ink, fontSize: 12.5, fontWeight: FontWeight.w700)),
          const Icon(Icons.chevron_right_rounded, size: 18, color: _muted),
        ],
      ),
    );
  }
}
