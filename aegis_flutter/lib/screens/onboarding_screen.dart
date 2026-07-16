import 'package:flutter/material.dart';

import 'login_join_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFF5F3FF),
                        border: Border.all(color: const Color(0xFFEDE9FE)),
                      ),
                      child: const Center(
                        child: Text('A',
                            style: TextStyle(
                                color: _violet,
                                fontSize: 52,
                                fontWeight: FontWeight.w900)),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text('Welcome to AEGIS',
                        style: TextStyle(
                            color: _ink,
                            fontSize: 32,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 10),
                    const Text(
                      'Stay connected. Stay informed. Stay alive.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: _muted, fontSize: 15, height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    _featureCard(Icons.hub_rounded, 'Mesh Communication',
                        'Nearby devices keep talking even when the internet does not.'),
                    const SizedBox(height: 10),
                    _featureCard(
                        Icons.notifications_active_rounded,
                        'Emergency Broadcast',
                        'Send SOS and route alerts to the closest nodes first.'),
                    const SizedBox(height: 10),
                    _featureCard(
                        Icons.volunteer_activism_rounded,
                        'Resources & Community',
                        'Share supplies, help requests, and status updates.'),
                  ],
                ),
              ),
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
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (_) => const LoginJoinScreen()),
                    );
                  },
                  child: const Text('Get Started',
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

  Widget _featureCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _blue, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: _ink,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(
                        color: _muted, fontSize: 11.5, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
