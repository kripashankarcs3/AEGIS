import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IdentityScreen extends StatelessWidget {
  const IdentityScreen({super.key});

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE5E7EB);
  static const _violet = Color(0xFF7C3AED);
  static const _green = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    const publicKey = 'a1b2c3d4e5f678901234567890abcdef1234567890abcdef12';

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
          'My Identity',
          style:
              TextStyle(color: _ink, fontSize: 20, fontWeight: FontWeight.w900),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F3FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEDE9FE)),
            ),
            child: const Icon(Icons.verified_user_rounded,
                color: _violet, size: 18),
          ),
          const SizedBox(width: 4),
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
            _profileCard(context),
            const SizedBox(height: 18),
            _keyCard(context, publicKey),
            const SizedBox(height: 18),
            _securityCard(),
            const SizedBox(height: 18),
            _infoCard(),
          ],
        ),
      ),
    );
  }

  Widget _profileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x10000000), blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFA855F7), Color(0xFF7C3AED)],
                  ),
                ),
                child: const Icon(Icons.person_rounded,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text('SIG-7F3A',
                                style: TextStyle(
                                    color: _ink,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900)),
                            SizedBox(width: 8),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAFBF0),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: const Color(0xFFBBF7D0)),
                          ),
                          child: const Text('Active & Trusted',
                              style: TextStyle(
                                  color: _green,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text('2 hops away • via SIG-B2C1',
                        style: TextStyle(color: _muted, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(height: 1, thickness: 1, color: _line),
          const SizedBox(height: 14),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Member since',
                  style: TextStyle(color: _muted, fontSize: 12)),
              Text('12 May 2024',
                  style: TextStyle(
                      color: _ink, fontSize: 12, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _keyCard(BuildContext context, String key) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: key));
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Public key copied to clipboard')));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('IDENTITY KEY',
                    style: TextStyle(
                        color: _muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6)),
                Icon(Icons.copy_rounded, color: _muted, size: 15),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Public Key (Tap to copy)',
                style: TextStyle(
                    color: _ink, fontSize: 12.5, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Text(key,
                style: const TextStyle(
                    fontFamily: 'monospace',
                    color: _violet,
                    fontSize: 12,
                    height: 1.5)),
          ],
        ),
      ),
    );
  }

  Widget _securityCard() {
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
          _row('Key Type', 'Ed25519'),
          const Divider(height: 1, thickness: 1, color: _line),
          _row('Signature', 'Valid',
              valueColor: _green, icon: Icons.check_circle_outline_rounded),
          const Divider(height: 1, thickness: 1, color: _line),
          _row('Key Created', '12 May 2024'),
          const Divider(height: 1, thickness: 1, color: _line),
          _row('Last Rotated', 'Never'),
        ],
      ),
    );
  }

  Widget _row(String label, String value,
      {Color valueColor = _ink, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: _muted, fontSize: 12.5)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: valueColor, size: 15),
                const SizedBox(width: 6),
              ],
              Text(value,
                  style: TextStyle(
                      color: valueColor,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDE9FE)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.help_outline_rounded, color: _violet, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('What is SIG-ID?',
                    style: TextStyle(
                        color: _ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w800)),
                SizedBox(height: 6),
                Text(
                  'Your SIG-ID is derived from your public key. It is your unique identity in the mesh network.',
                  style: TextStyle(color: _muted, fontSize: 12.5, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
