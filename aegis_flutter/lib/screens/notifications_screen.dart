import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'settings_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilter = 0;

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
          'Notifications',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 22.0),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Horizontal filters tags
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFilterPill(0, 'All'),
                  _buildFilterPill(1, 'Alerts'),
                  _buildFilterPill(2, 'Messages'),
                  _buildFilterPill(3, 'System'),
                ],
              ),
              const SizedBox(height: 20.0),

              // 2. Notifications List
              Expanded(
                child: ListView(
                  children: [
                    _buildNotificationTile(
                      icon: Icons.add_rounded,
                      iconBgColor: AegisColors.sosRed,
                      title: 'Medical Help Needed',
                      subtitle: 'Near Central Park',
                      time: '2 min ago',
                    ),
                    _buildDivider(),
                    _buildNotificationTile(
                      icon: Icons.check_circle_rounded,
                      iconBgColor: AegisColors.neonGreen,
                      title: 'Food Available',
                      subtitle: 'At Green Area',
                      time: '15 min ago',
                    ),
                    _buildDivider(),
                    _buildNotificationTile(
                      titleIcon: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                        decoration: const BoxDecoration(
                          color: AegisColors.sosRed,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          'SOS',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 8.0),
                        ),
                      ),
                      title: 'SOS Alert',
                      subtitle: 'From 1.2 km away',
                      time: '20 min ago',
                    ),
                    _buildDivider(),
                    _buildNotificationTile(
                      icon: Icons.chat_bubble_rounded,
                      iconBgColor: AegisColors.electricBlue,
                      title: 'New Message',
                      subtitle: 'From Riya',
                      time: '25 min ago',
                    ),
                    _buildDivider(),
                    _buildNotificationTile(
                      icon: Icons.battery_alert_rounded,
                      iconBgColor: AegisColors.sosRed,
                      title: 'Battery Low',
                      subtitle: 'Your device battery is low',
                      time: '30 min ago',
                    ),
                    _buildDivider(),
                    _buildNotificationTile(
                      icon: Icons.wifi_tethering_rounded,
                      iconBgColor: AegisColors.violet,
                      title: 'Network Congestion',
                      subtitle: 'Some messages delayed',
                      time: '35 min ago',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPill(int index, String label) {
    final bool isSelected = _selectedFilter == index;
    final Color bgColor = isSelected ? AegisColors.violet : Colors.transparent;
    final Color strokeColor = isSelected ? AegisColors.violet : const Color(0xFF1E293B);
    final Color textColor = isSelected ? Colors.white : AegisColors.textSecondary;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 7.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: strokeColor, width: 1.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 12.0,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTile({
    IconData? icon,
    Color iconBgColor = Colors.grey,
    Widget? titleIcon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left circle icon
          if (titleIcon != null)
            titleIcon
          else
            Container(
              width: 32.0,
              height: 32.0,
              decoration: BoxDecoration(
                color: iconBgColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconBgColor,
                size: 16.0,
              ),
            ),
          const SizedBox(width: 14.0),

          // Title & subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AegisColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Time ago
          Text(
            time,
            style: const TextStyle(
              fontSize: 10.0,
              color: AegisColors.textMuted,
            ),
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
