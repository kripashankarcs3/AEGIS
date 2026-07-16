import 'package:flutter/material.dart';

import 'settings_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilter = 0;

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE5E7EB);
  static const _blue = Color(0xFF2563EB);
  static const _green = Color(0xFF22C55E);
  static const _red = Color(0xFFFF3B30);
  static const _violet = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notifications',
          style:
              TextStyle(color: _ink, fontSize: 20, fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: _ink),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: _line),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: _filters(),
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                children: const [
                  _NotificationTile(
                    icon: Icons.medical_services_rounded,
                    color: _red,
                    title: 'Medical Help Needed',
                    subtitle: 'Near Central Park',
                    time: '2 min ago',
                  ),
                  _TileDivider(),
                  _NotificationTile(
                    icon: Icons.restaurant_rounded,
                    color: _green,
                    title: 'Food Available',
                    subtitle: 'At Green Area',
                    time: '15 min ago',
                  ),
                  _TileDivider(),
                  _NotificationTile(
                    icon: Icons.sos_rounded,
                    color: _red,
                    title: 'SOS Alert',
                    subtitle: 'From 1.2 km away',
                    time: '20 min ago',
                    badgeText: 'SOS',
                  ),
                  _TileDivider(),
                  _NotificationTile(
                    icon: Icons.chat_bubble_rounded,
                    color: _blue,
                    title: 'New Message',
                    subtitle: 'From Riya',
                    time: '25 min ago',
                  ),
                  _TileDivider(),
                  _NotificationTile(
                    icon: Icons.battery_alert_rounded,
                    color: _red,
                    title: 'Battery Low',
                    subtitle: 'Your device battery is low',
                    time: '30 min ago',
                  ),
                  _TileDivider(),
                  _NotificationTile(
                    icon: Icons.wifi_tethering_rounded,
                    color: _violet,
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
    );
  }

  Widget _filters() {
    final labels = ['All', 'Alerts', 'Messages', 'System'];
    return Row(
      children: List.generate(labels.length, (index) {
        final selected = _selectedFilter == index;
        return Padding(
          padding: EdgeInsets.only(right: index == labels.length - 1 ? 0 : 10),
          child: GestureDetector(
            onTap: () => setState(() => _selectedFilter = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFEFF6FF)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                    color: selected ? const Color(0xFFBFDBFE) : _line),
              ),
              child: Text(
                labels[index],
                style: TextStyle(
                  color: selected ? _blue : _muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;
  final String? badgeText;

  const _NotificationTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.time,
    this.badgeText,
  });

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (badgeText == null)
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            )
          else
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  badgeText!,
                  style: TextStyle(
                      color: color, fontSize: 9, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: _ink,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(color: _muted, fontSize: 11.5)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(time,
              style: const TextStyle(
                  color: _muted, fontSize: 10.5, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6));
  }
}
