import 'package:flutter/material.dart';

import 'main_shell.dart';

class LoginJoinScreen extends StatelessWidget {
  const LoginJoinScreen({super.key});

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE5E7EB);
  static const _blue = Color(0xFF2563EB);
  static const _violet = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF5F3FF),
                  border: Border.all(color: const Color(0xFFEDE9FE)),
                ),
                child: const Center(
                  child: Text('A',
                      style: TextStyle(
                          color: _violet,
                          fontSize: 46,
                          fontWeight: FontWeight.w900)),
                ),
              ),
              const SizedBox(height: 22),
              const Text('Join the Network',
                  style: TextStyle(
                      color: _ink, fontSize: 30, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              const Text(
                'Choose a way to continue.',
                style: TextStyle(color: _muted, fontSize: 15),
              ),
              const SizedBox(height: 28),
              _actionCard(Icons.phone_outlined, 'Continue with Phone',
                  'Use your mobile number to create or restore access.'),
              const SizedBox(height: 12),
              _actionCard(Icons.qr_code_scanner_rounded, 'Scan QR Code',
                  'Join instantly by scanning a trusted code.'),
              const SizedBox(height: 12),
              _actionCard(Icons.person_outline_rounded, 'Join as Guest',
                  'Browse the network with limited access.'),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MainShell()),
                      (route) => false,
                    );
                  },
                  child: const Text('Enter AEGIS',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x10000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _blue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: _ink,
                        fontSize: 14,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(
                        color: _muted, fontSize: 11.5, height: 1.3)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: _muted),
        ],
      ),
    );
  }
}
