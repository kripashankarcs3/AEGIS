import 'dart:math';

import 'package:flutter/material.dart';

class BatterySaverScreen extends StatefulWidget {
  const BatterySaverScreen({super.key});

  @override
  State<BatterySaverScreen> createState() => _BatterySaverScreenState();
}

class _BatterySaverScreenState extends State<BatterySaverScreen> {
  bool _enabled = true;
  bool _reduceActivity = true;
  bool _lowerBrightness = true;
  bool _disableVibration = false;

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE5E7EB);
  static const _green = Color(0xFF22C55E);
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
          'Battery Saver',
          style: TextStyle(
            color: _ink,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
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
            _batteryHero(),
            const SizedBox(height: 16),
            _toggleCard(),
            const SizedBox(height: 12),
            _sectionTitle('OPTIMIZATIONS'),
            const SizedBox(height: 10),
            _optionsCard(),
          ],
        ),
      ),
    );
  }

  Widget _batteryHero() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x10000000), blurRadius: 18, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 210,
            height: 210,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _GaugePainter(percentage: 0.78),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.battery_charging_full_rounded,
                        color: _green, size: 38),
                    SizedBox(height: 10),
                    Text(
                      '78%',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Estimated time left',
                      style: TextStyle(color: _muted, fontSize: 11),
                    ),
                    SizedBox(height: 3),
                    Text(
                      '22h 45m',
                      style: TextStyle(
                          color: _green,
                          fontSize: 14,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Battery Saver Mode keeps the mesh alive longer by lowering background usage.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontSize: 12.5, height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget _toggleCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x10000000), blurRadius: 14, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEAFBF0),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: const Icon(Icons.eco_rounded, color: _green, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Battery Saver Mode',
                    style: TextStyle(
                        color: _ink,
                        fontSize: 15,
                        fontWeight: FontWeight.w800)),
                SizedBox(height: 4),
                Text('Optimize settings to extend battery life.',
                    style:
                        TextStyle(color: _muted, fontSize: 11.5, height: 1.35)),
              ],
            ),
          ),
          Switch(
            value: _enabled,
            onChanged: (value) => setState(() => _enabled = value),
            activeColor: Colors.white,
            activeTrackColor: _green,
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
                color: _green, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 10),
        Text(text,
            style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 11,
                fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _optionsCard() {
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
          _switchRow(
              Icons.settings_suggest_outlined,
              'Reduce Background Activity',
              'Limit non-essential processes',
              _reduceActivity,
              (v) => setState(() => _reduceActivity = v)),
          const Divider(height: 1, thickness: 1, color: _line),
          _switchRow(
              Icons.light_mode_outlined,
              'Lower Screen Brightness',
              'Set brightness to 30%',
              _lowerBrightness,
              (v) => setState(() => _lowerBrightness = v)),
          const Divider(height: 1, thickness: 1, color: _line),
          _switchRow(
              Icons.vibration_rounded,
              'Disable Vibrations',
              'Turn off haptic feedback',
              _disableVibration,
              (v) => setState(() => _disableVibration = v)),
          const Divider(height: 1, thickness: 1, color: _line),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            leading:
                const Icon(Icons.sync_alt_rounded, color: _muted, size: 18),
            title: const Text('Sync Less Frequently',
                style: TextStyle(
                    color: _ink, fontSize: 13.5, fontWeight: FontWeight.w800)),
            subtitle: const Text('Increase sync interval',
                style: TextStyle(color: _muted, fontSize: 11.5)),
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('30 min',
                    style: TextStyle(
                        color: _green,
                        fontWeight: FontWeight.w800,
                        fontSize: 12)),
                SizedBox(width: 4),
                Icon(Icons.chevron_right_rounded, size: 18, color: _muted),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _switchRow(IconData icon, String title, String subtitle, bool value,
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
                        color: _muted, fontSize: 11.5, height: 1.3)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: _green,
            inactiveThumbColor: const Color(0xFFCBD5E1),
            inactiveTrackColor: const Color(0xFFE2E8F0),
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double percentage;
  _GaugePainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final track = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    final active = Paint()
      ..color = const Color(0xFF22C55E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    const startAngle = 3 * pi / 4;
    const sweepAngle = 3 * pi / 2;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepAngle, false, track);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepAngle * percentage, false, active);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.percentage != percentage;
}
