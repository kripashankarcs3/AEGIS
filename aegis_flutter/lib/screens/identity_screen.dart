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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Identity Profile Card (Shield, SIG-8AF3, Active Badge, Public Key, Local Warning Note)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AegisColors.cardBackground,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AegisColors.border, width: 1.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'SIG-8AF3',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                // Active status badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: AegisColors.greenLightBg,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: const Text(
                                    'Active',
                                    style: TextStyle(
                                      color: AegisColors.activeGreen,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),

                      // Public Key copies block
                      const Text(
                        'Public Key',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: AegisColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Text(
                              '7f3a9c2d8b6e4f1a9c2d8b6e4f1a9c2d8b6e4f1a9c2d8b6e4f1a9c2d8b6e4f1a',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11.5,
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
                              size: 18.0,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),

                      // Local generation outline check note box
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF042F1A).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6.0),
                          border: Border.all(
                            color: AegisColors.activeGreen.withOpacity(0.3),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              color: AegisColors.activeGreen,
                              size: 16.0,
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Text(
                                'Generated locally — never sent to any server.',
                                style: TextStyle(
                                  color: AegisColors.activeGreen,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28.0),

                // 2. Share Identity Section
                const Text(
                  'Share Identity',
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                    color: AegisColors.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Mockup QR Code
                    Container(
                      width: 104.0,
                      height: 104.0,
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: const Icon(
                        Icons.qr_code_2_rounded,
                        color: Colors.black,
                        size: 92.0,
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    // Instructions details list
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Scan to connect',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          _buildShareRowDetail('LAN IP', '192.168.1.105'),
                          const SizedBox(height: 6.0),
                          _buildShareRowDetail('SIG-ID', 'SIG-8AF3'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),

                // 3. Mesh Statistics (This Session) Section
                const Text(
                  'Mesh Statistics (This Session)',
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                    color: AegisColors.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12.0),
                Container(
                  decoration: BoxDecoration(
                    color: AegisColors.cardBackground,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AegisColors.border, width: 1.0),
                  ),
                  child: Column(
                    children: [
                      _buildMeshStatItem(
                        icon: Icons.access_time_rounded,
                        label: 'Session Uptime',
                        value: '2h 45m',
                      ),
                      const Divider(color: Color(0xFF1E293B), height: 1.0, thickness: 0.5),
                      _buildMeshStatItem(
                        icon: Icons.sync_alt_rounded,
                        label: 'Total Relayed',
                        value: '1,248 packets',
                      ),
                      const Divider(color: Color(0xFF1E293B), height: 1.0, thickness: 0.5),
                      _buildMeshStatItem(
                        icon: Icons.sensors_rounded,
                        label: 'Nodes Discovered',
                        value: '8',
                      ),
                      const Divider(color: Color(0xFF1E293B), height: 1.0, thickness: 0.5),
                      _buildMeshStatItem(
                        icon: Icons.cancel_presentation_rounded,
                        label: 'Packets Dropped',
                        value: '23',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShareRowDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AegisColors.textSecondary,
            fontSize: 10.5,
          ),
        ),
        const SizedBox(height: 1.0),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMeshStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 13.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AegisColors.textSecondary, size: 18.0),
              const SizedBox(width: 12.0),
              Text(
                label,
                style: const TextStyle(
                  color: AegisColors.textSecondary,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}
