import 'package:flutter/material.dart';

class AutoSyncScreen extends StatefulWidget {
  const AutoSyncScreen({super.key});

  @override
  State<AutoSyncScreen> createState() => _AutoSyncScreenState();
}

class _AutoSyncScreenState extends State<AutoSyncScreen> {
  bool _autoSync = true;
  bool _syncWhenConnected = true;

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE5E7EB);
  static const _blue = Color(0xFF2563EB);
  static const _bg = Color(0xFFF8FAFC);

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
          'Auto Sync',
          style:
              TextStyle(color: _ink, fontSize: 20, fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, color: _ink),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: _line),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 102),
          children: [
            _heroCard(),
            const SizedBox(height: 16),
            _sectionTitle('SYNC SETTINGS'),
            const SizedBox(height: 10),
            _settingsCard(),
            const SizedBox(height: 16),
            _sectionTitle('SYNC STATUS'),
            const SizedBox(height: 10),
            _statusCard(),
          ],
        ),
      ),
    );
  }

  Widget _heroCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x10000000), blurRadius: 14, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child:
                const Icon(Icons.cloud_queue_rounded, color: _blue, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Auto Sync',
                    style: TextStyle(
                        color: _ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: 4),
                Text(
                  'Automatically sync data when a stable mesh connection is available.',
                  style: TextStyle(color: _muted, fontSize: 12, height: 1.35),
                ),
              ],
            ),
          ),
          Switch(
            value: _autoSync,
            onChanged: (value) => setState(() => _autoSync = value),
            activeColor: Colors.white,
            activeTrackColor: _blue,
            inactiveThumbColor: const Color(0xFFCBD5E1),
            inactiveTrackColor: const Color(0xFFE2E8F0),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Row(
      children: [
        Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
                color: _blue, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 10),
        Text(text,
            style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 11,
                fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _settingsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x10000000), blurRadius: 14, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          _toggleRow(
              Icons.settings_input_antenna_rounded,
              'Sync When Connected',
              'Automatically sync all data',
              _syncWhenConnected,
              (v) => setState(() => _syncWhenConnected = v)),
          const Divider(height: 1, thickness: 1, color: _line),
          _navRow(Icons.settings_outlined, 'Preferred Network',
              'Any available mesh network', 'Auto'),
          const Divider(height: 1, thickness: 1, color: _line),
          _navRow(Icons.access_time_rounded, 'Sync Interval',
              'How often data is synced', '15 minutes'),
          const Divider(height: 1, thickness: 1, color: _line),
          _navRow(Icons.phone_android_rounded, 'Data to Sync',
              'Messages, resources, identity, settings', 'All'),
        ],
      ),
    );
  }

  Widget _statusCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x10000000), blurRadius: 14, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          _statusRow('Last Sync', '2 min ago',
              Icons.check_circle_outline_rounded, const Color(0xFF22C55E)),
          const Divider(height: 1, thickness: 1, color: _line),
          _statusRow('Next Sync', 'In 13 min', Icons.schedule_rounded, _muted),
        ],
      ),
    );
  }

  Widget _toggleRow(IconData icon, String title, String subtitle, bool value,
      ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _line),
            ),
            child: Icon(icon, color: _muted, size: 17),
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
                        color: _muted, fontSize: 11.5, height: 1.35)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: _blue,
            inactiveThumbColor: const Color(0xFFCBD5E1),
            inactiveTrackColor: const Color(0xFFE2E8F0),
          ),
        ],
      ),
    );
  }

  Widget _navRow(
      IconData icon, String title, String subtitle, String trailing) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _line),
        ),
        child: Icon(icon, color: _muted, size: 17),
      ),
      title: Text(title,
          style: const TextStyle(
              color: _ink, fontSize: 13.5, fontWeight: FontWeight.w800)),
      subtitle:
          Text(subtitle, style: const TextStyle(color: _muted, fontSize: 11.5)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(trailing,
              style: const TextStyle(
                  color: _blue, fontWeight: FontWeight.w800, fontSize: 12)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded, size: 18, color: _muted),
        ],
      ),
    );
  }

  Widget _statusRow(String label, String value, IconData icon, Color color) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      title: Text(label, style: const TextStyle(color: _muted, fontSize: 12.5)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w800, fontSize: 12.5)),
          const SizedBox(width: 6),
          Icon(icon, color: color, size: 15),
        ],
      ),
    );
  }
}
