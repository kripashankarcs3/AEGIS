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
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AegisColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: AegisColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: AegisColors.textPrimary, size: 22.0),
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
              SizedBox(height: 20.0),

              // 2. Notifications List
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_none_outlined, size: 56, color: AegisColors.textMuted),
                      SizedBox(height: 16),
                      Text('No notifications yet', style: TextStyle(color: AegisColors.textMuted, fontSize: 15, fontWeight: FontWeight.w500)),
                      SizedBox(height: 8),
                      Text('Notifications from mesh activity\nwill appear here', style: TextStyle(color: AegisColors.textDim, fontSize: 13), textAlign: TextAlign.center),
                    ],
                  ),
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
    final Color strokeColor = isSelected ? AegisColors.violet : AegisColors.border1;
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
          SizedBox(width: 14.0),

          // Title & subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: AegisColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: TextStyle(
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
style: TextStyle(
                fontSize: 10.0,
                color: AegisColors.textMuted,
              ),
          ),
        ],
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
