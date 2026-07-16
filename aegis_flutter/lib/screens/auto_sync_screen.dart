import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';

class AutoSyncScreen extends StatefulWidget {
  const AutoSyncScreen({super.key});

  @override
  State<AutoSyncScreen> createState() => _AutoSyncScreenState();
}

class _AutoSyncScreenState extends State<AutoSyncScreen> {
  bool _autoSync = true;
  bool _syncWhenConnected = true;

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
          'Auto Sync',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // 1. Auto Sync Core Toggle Card
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AegisColors.cardBg,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: AegisColors.border1, width: 1.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Glowing green cloud icon container
                      Container(
                        width: 44.0,
                        height: 44.0,
                        decoration: BoxDecoration(
                          color: AegisColors.neonGreen.withOpacity(0.08),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AegisColors.neonGreen.withOpacity(0.3),
                            width: 1.0,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.cloud_queue_rounded,
                            color: AegisColors.neonGreen,
                            size: 22.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Auto Sync',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 24.0,
                                  child: Switch(
                                    value: _autoSync,
                                    onChanged: (val) {
                                      setState(() {
                                        _autoSync = val;
                                      });
                                    },
                                    activeColor: Colors.white,
                                    activeTrackColor: AegisColors.neonGreen,
                                    inactiveThumbColor: Colors.grey,
                                    inactiveTrackColor: const Color(0xFF1E293B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6.0),
                            const Text(
                              'Automatically sync data when a stable mesh connection becomes available.',
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
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // 2. Sync Settings Section
            const Text(
              'Sync Settings',
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
                color: AegisColors.cardBg,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AegisColors.border1, width: 1.0),
              ),
              child: Column(
                children: [
                  // Sync When Connected toggle tile
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                    child: Row(
                      children: [
                        const Icon(Icons.settings_input_antenna_rounded, color: AegisColors.neonGreen, size: 18.0),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Sync When Connected',
                                style: TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 3.0),
                              Text(
                                'Automatically sync all data',
                                style: TextStyle(color: AegisColors.textSecondary, fontSize: 10.5),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 24.0,
                          child: Switch(
                            value: _syncWhenConnected,
                            onChanged: (val) {
                              setState(() {
                                _syncWhenConnected = val;
                              });
                            },
                            activeColor: Colors.white,
                            activeTrackColor: AegisColors.neonGreen,
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildDivider(),

                  // Preferred Network nav tile
                  _buildNavTile(
                    icon: Icons.settings_outlined,
                    title: 'Preferred Network',
                    subtitle: 'Any available mesh network',
                  ),
                  _buildDivider(),

                  // Sync Interval nav tile
                  _buildNavTile(
                    icon: Icons.access_time,
                    title: 'Sync Interval',
                    trailingWidget: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          '15 minutes',
                          style: TextStyle(
                            color: AegisColors.neonGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(width: 6.0),
                        Icon(Icons.chevron_right, size: 14.0, color: AegisColors.textMuted),
                      ],
                    ),
                  ),
                  _buildDivider(),

                  // Data to Sync nav tile
                  _buildNavTile(
                    icon: Icons.phone_android_rounded,
                    title: 'Data to Sync',
                    subtitle: 'Messages, Resources, Identity, Settings',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // 3. Sync Status Section
            const Text(
              'Sync Status',
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
                color: AegisColors.cardBg,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: AegisColors.border1, width: 1.0),
              ),
              child: Column(
                children: [
                  // Last sync tile
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Last Sync',
                          style: TextStyle(color: AegisColors.textSecondary, fontSize: 13.0),
                        ),
                        Row(
                          children: const [
                            Text(
                              '2 min ago',
                              style: TextStyle(
                                color: AegisColors.neonGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.5,
                              ),
                            ),
                            SizedBox(width: 6.0),
                            Icon(
                              Icons.check_circle_outline_rounded,
                              color: AegisColors.neonGreen,
                              size: 14.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildDivider(),

                  // Next sync tile
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Next Sync',
                          style: TextStyle(color: AegisColors.textSecondary, fontSize: 13.0),
                        ),
                        Row(
                          children: const [
                            Text(
                              'In 13 min',
                              style: TextStyle(
                                color: AegisColors.textSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.5,
                              ),
                            ),
                            SizedBox(width: 6.0),
                            Icon(
                              Icons.access_time_rounded,
                              color: AegisColors.textMuted,
                              size: 14.0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailingWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AegisColors.textSecondary, size: 18.0),
              const SizedBox(width: 12.0),
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
                  if (subtitle != null) ...[
                    const SizedBox(height: 3.0),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AegisColors.textSecondary,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          trailingWidget ?? const Icon(Icons.chevron_right, size: 14.0, color: AegisColors.textMuted),
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
