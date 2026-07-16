import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          'About AEGIS',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          children: [
            // 1. Core Shield Logo + Titles
            Center(
              child: Column(
                children: [
                  // Shield Logo
                  Container(
                    width: 90.0,
                    height: 104.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                        bottomLeft: Radius.circular(45.0),
                        bottomRight: Radius.circular(45.0),
                      ),
                      border: Border.all(
                        color: AegisColors.neonGreen,
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AegisColors.neonGreen.withOpacity(0.15),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'A',
                        style: TextStyle(
                          color: AegisColors.neonGreen,
                          fontSize: 48.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Brand name titles
                  const Text(
                    'AEGIS',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  const Text(
                    'Mesh Network',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: AegisColors.neonGreen,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  // Version badge tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF042F1A),
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: AegisColors.neonGreen.withOpacity(0.25),
                        width: 1.0,
                      ),
                    ),
                    child: const Text(
                      'v1.0.0',
                      style: TextStyle(
                        color: AegisColors.neonGreen,
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Platform descriptive pitch
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'AEGIS is an offline-first emergency communication platform that connects devices in a secure mesh network.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AegisColors.textSecondary,
                        fontSize: 12.0,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0),

            // 2. Info Details Cards
            Container(
              decoration: BoxDecoration(
                color: AegisColors.cardBg,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: AegisColors.border1, width: 1.0),
              ),
              child: Column(
                children: [
                  _buildAboutInfoTile('Version', '1.0.0'),
                  _buildDivider(),
                  _buildAboutInfoTile('Build', '100'),
                  _buildDivider(),
                  _buildAboutInfoTile(
                    'Website',
                    'aegis.app',
                    valueColor: AegisColors.neonGreen,
                  ),
                  _buildDivider(),
                  _buildAboutNavTile('Terms of Service'),
                  _buildDivider(),
                  _buildAboutNavTile('Privacy Policy'),
                  _buildDivider(),
                  _buildAboutNavTile('Open Source Licenses'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutInfoTile(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AegisColors.textSecondary,
              fontSize: 12.5,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutNavTile(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AegisColors.textSecondary,
              fontSize: 12.5,
            ),
          ),
          const Icon(
            Icons.chevron_right,
            size: 14.0,
            color: AegisColors.textMuted,
          ),
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
