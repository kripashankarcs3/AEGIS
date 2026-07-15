import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF090D16),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Help & Support',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // 1. Support banner core card
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AegisColors.cardBackground,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: AegisColors.border, width: 1.0),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44.0,
                    height: 44.0,
                    decoration: BoxDecoration(
                      color: AegisColors.greenLightBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AegisColors.activeGreen.withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.headset_mic_rounded,
                        color: AegisColors.activeGreen,
                        size: 22.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "We're here to help!",
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Find answers or get in touch with our support team.',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: AegisColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // 2. Help Center Section
            const Text(
              'Help Center',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: AegisColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                color: AegisColors.cardBackground,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AegisColors.border, width: 1.0),
              ),
              child: Column(
                children: [
                  _buildSupportTile(
                    icon: Icons.help_outline_rounded,
                    title: 'FAQs',
                    subtitle: 'Frequently asked questions',
                  ),
                  _buildDivider(),
                  _buildSupportTile(
                    icon: Icons.menu_book_rounded,
                    title: 'User Guide',
                    subtitle: 'Learn how to use AEGIS',
                  ),
                  _buildDivider(),
                  _buildSupportTile(
                    icon: Icons.play_circle_outline_rounded,
                    title: 'Video Tutorials',
                    subtitle: 'Watch step-by-step guides',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // 3. Contact Support Section
            const Text(
              'Contact Support',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: AegisColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                color: AegisColors.cardBackground,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AegisColors.border, width: 1.0),
              ),
              child: Column(
                children: [
                  _buildSupportTile(
                    icon: Icons.bug_report_outlined,
                    title: 'Report an Issue',
                    subtitle: 'Let us know what went wrong',
                  ),
                  _buildDivider(),
                  _buildSupportTile(
                    icon: Icons.mail_outline_rounded,
                    title: 'Email Support',
                    subtitle: 'support@aegis.app',
                  ),
                  _buildDivider(),
                  _buildSupportTile(
                    icon: Icons.description_outlined,
                    title: 'Send Logs',
                    subtitle: 'Share logs for better support',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AegisColors.textSecondary, size: 18.0),
              const SizedBox(width: 14.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AegisColors.textSecondary,
                      fontSize: 11.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Icon(Icons.chevron_right, size: 14.0, color: AegisColors.textMuted),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFF1E293B),
      height: 1.0,
      thickness: 0.5,
    );
  }
}
