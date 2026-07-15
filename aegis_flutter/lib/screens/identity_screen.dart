import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';

class IdentityScreen extends StatelessWidget {
  const IdentityScreen({super.key});

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
          'My Identity',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 22.0),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Identity profile card
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AegisColors.cardBackground,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AegisColors.border, width: 1.0),
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 52.0,
                        height: 52.0,
                        decoration: BoxDecoration(
                          color: AegisColors.busyPurple.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: AegisColors.busyPurple.withOpacity(0.3), width: 1.0),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.shield_outlined,
                            color: AegisColors.busyPurple,
                            size: 26.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14.0),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'SIG-7F3A',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                // Active Badge status
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF042F1A).withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: const Text(
                                    'Active',
                                    style: TextStyle(
                                      color: AegisColors.activeGreen,
                                      fontSize: 9.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4.0),
                            const Text(
                              'Your Mesh Identity',
                              style: TextStyle(
                                color: AegisColors.textSecondary,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),

                // Member Since row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Member Since',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: AegisColors.textSecondary,
                      ),
                    ),
                    Text(
                      '12 May 2024',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),

                // 2. Identity Key Copy Area
                const Text(
                  'IDENTITY KEY',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: AegisColors.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: AegisColors.cardBackground,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AegisColors.border, width: 1.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Text(
                          'a1b2c3d4e5f67890123456789\n0abcdef1234567890abcdef12',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12.0,
                            color: AegisColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      IconButton(
                        icon: const Icon(
                          Icons.copy_rounded,
                          color: AegisColors.textSecondary,
                          size: 20.0,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),

                // 3. Security Section info list
                const Text(
                  'SECURITY',
                  style: TextStyle(
                    fontSize: 9.5,
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
                      _buildSecurityItem(
                        icon: Icons.vpn_key_outlined,
                        label: 'Key Type',
                        valueText: 'Ed25519',
                      ),
                      const Divider(color: Color(0xFF1E293B), height: 1.0, thickness: 0.5),
                      _buildSecurityItem(
                        icon: Icons.verified_user_outlined,
                        label: 'Signature',
                        valueWidget: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Valid',
                              style: TextStyle(
                                color: AegisColors.activeGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                              ),
                            ),
                            SizedBox(width: 4.0),
                            Icon(
                              Icons.check_circle_rounded,
                              color: AegisColors.activeGreen,
                              size: 14.0,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36.0),

                // 4. Regenerate Identity action buttons
                Container(
                  width: double.infinity,
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: AegisColors.purpleLightBg.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(color: AegisColors.busyPurple, width: 1.0),
                  ),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(6.0),
                    child: const Center(
                      child: Text(
                        'Regenerate Identity Key',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                const Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Regenerating will change your identity\nacross the network.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.0,
                        color: AegisColors.textMuted,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityItem({
    required IconData icon,
    required String label,
    String? valueText,
    Widget? valueWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AegisColors.textSecondary, size: 18.0),
              const SizedBox(width: 10.0),
              Text(
                label,
                style: const TextStyle(
                  color: AegisColors.textSecondary,
                  fontSize: 13.0,
                ),
              ),
            ],
          ),
          if (valueWidget != null) valueWidget,
          if (valueText != null)
            Text(
              valueText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13.0,
              ),
            ),
        ],
      ),
    );
  }
}
