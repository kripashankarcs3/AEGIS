import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AegisColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Help & Support',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: AegisColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AegisColors.cardBg,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: AegisColors.border1, width: 1.0),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44.0,
                    height: 44.0,
                    decoration: BoxDecoration(
                      color: AegisColors.neonGreen.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AegisColors.neonGreen.withValues(alpha: 0.3),
                        width: 1.0,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.headset_mic_rounded,
                        color: AegisColors.neonGreen,
                        size: 22.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "We're here to help!",
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: AegisColors.textPrimary,
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
            SizedBox(height: 24.0),
            Text(
              'Help Center',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: AegisColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                color: AegisColors.cardBg,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AegisColors.border1, width: 1.0),
              ),
              child: Column(
                children: [
                  _buildSupportTile(
                    icon: Icons.help_outline_rounded,
                    title: 'FAQs',
                    subtitle: 'Frequently asked questions',
                    onTap: () => _showComingSoon(context, 'FAQs'),
                  ),
                  _buildDivider(),
                  _buildSupportTile(
                    icon: Icons.menu_book_rounded,
                    title: 'User Guide',
                    subtitle: 'Learn how to use AEGIS',
                    onTap: () => _showComingSoon(context, 'User Guide'),
                  ),
                  _buildDivider(),
                  _buildSupportTile(
                    icon: Icons.play_circle_outline_rounded,
                    title: 'Video Tutorials',
                    subtitle: 'Watch step-by-step guides',
                    onTap: () => _showComingSoon(context, 'Video Tutorials'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              'Contact Support',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: AegisColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              decoration: BoxDecoration(
                color: AegisColors.cardBg,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AegisColors.border1, width: 1.0),
              ),
              child: Column(
                children: [
                  _buildSupportTile(
                    icon: Icons.bug_report_outlined,
                    title: 'Report an Issue',
                    subtitle: 'Let us know what went wrong',
                    onTap: () => _showComingSoon(context, 'Report an Issue'),
                  ),
                  _buildDivider(),
                  _buildSupportTile(
                    icon: Icons.mail_outline_rounded,
                    title: 'Email Support',
                    subtitle: 'support@aegis.app',
                    onTap: () => _showComingSoon(context, 'Email Support'),
                  ),
                  _buildDivider(),
                  _buildSupportTile(
                    icon: Icons.description_outlined,
                    title: 'Send Logs',
                    subtitle: 'Share logs for better support',
                    onTap: () => _showComingSoon(context, 'Send Logs'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildSupportTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: AegisColors.textSecondary, size: 18.0),
                SizedBox(width: 14.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AegisColors.textPrimary,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3.0),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AegisColors.textSecondary,
                        fontSize: 11.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(Icons.chevron_right, size: 14.0, color: AegisColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: AegisColors.border1,
      height: 1.0,
      thickness: 0.5,
    );
  }
}