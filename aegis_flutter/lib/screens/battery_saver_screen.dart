import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';

class BatterySaverScreen extends StatefulWidget {
  const BatterySaverScreen({super.key});

  @override
  State<BatterySaverScreen> createState() => _BatterySaverScreenState();
}

class _BatterySaverScreenState extends State<BatterySaverScreen> {
  bool _batterySaverMode = true;
  bool _reduceActivity = true;
  bool _lowerBrightness = true;
  bool _disableVibration = false;

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
          'Battery Saver',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: AegisColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline_rounded, color: AegisColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          children: [
            // 1. Semi-circular battery progress gauge
            Center(
              child: SizedBox(
                width: 220.0,
                height: 220.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Custom Painter Gauge
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CustomPaint(
                          painter: BatterySaverGaugePainter(percentage: 0.0),
                        ),
                      ),
                    ),
                    // Centered battery stats column
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Battery icon with lightning green bolt
                        Icon(
                          Icons.battery_charging_full_rounded,
                          color: AegisColors.neonGreen,
                          size: 40.0,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          '--%',
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.w900,
                            color: AegisColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Estimated time left',
                          style: TextStyle(
                            fontSize: 11.0,
                            color: AegisColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 3.0),
                        Text(
                          '--h --m',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: AegisColors.neonGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),

            // 2. Battery Saver Mode Toggle Card
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
                    width: 40.0,
                    height: 40.0,
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
                        Icons.eco_rounded,
                        color: AegisColors.neonGreen,
                        size: 20.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Battery Saver Mode',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: AegisColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 3.0),
                        Text(
                          'Optimize settings to extend battery life.',
                          style: TextStyle(
                            fontSize: 11.0,
                            color: AegisColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                    child: Switch(
                      value: _batterySaverMode,
                      onChanged: (val) {
                        setState(() {
                          _batterySaverMode = val;
                        });
                      },
                      activeThumbColor: Colors.white,
                      activeTrackColor: AegisColors.neonGreen,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: AegisColors.border1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),

            // 3. Optimizations section
            Text(
              'Optimizations',
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
                  // Reduce Background Activity
                  _buildToggleOptimizationTile(
                    icon: Icons.settings_suggest_outlined,
                    title: 'Reduce Background Activity',
                    description: 'Limit non-essential processes',
                    value: _reduceActivity,
                    onChanged: (val) {
                      setState(() {
                        _reduceActivity = val;
                      });
                    },
                  ),
                  _buildDivider(),

                  // Lower Screen Brightness
                  _buildToggleOptimizationTile(
                    icon: Icons.light_mode_outlined,
                    title: 'Lower Screen Brightness',
                    description: 'Set brightness to 30%',
                    value: _lowerBrightness,
                    onChanged: (val) {
                      setState(() {
                        _lowerBrightness = val;
                      });
                    },
                  ),
                  _buildDivider(),

                  // Disable Vibrations
                  _buildToggleOptimizationTile(
                    icon: Icons.vibration_rounded,
                    title: 'Disable Vibrations',
                    description: 'Turn off haptic feedback',
                    value: _disableVibration,
                    onChanged: (val) {
                      setState(() {
                        _disableVibration = val;
                      });
                    },
                  ),
                  _buildDivider(),

                  // Sync Less Frequently
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.sync_alt_rounded, color: AegisColors.textSecondary, size: 18.0),
                            SizedBox(width: 12.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sync Less Frequently',
                                  style: TextStyle(color: AegisColors.textPrimary, fontSize: 13.0, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 3.0),
                                Text(
                                  'Increase sync interval',
                                  style: TextStyle(color: AegisColors.textSecondary, fontSize: 10.5),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '30 min',
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

  Widget _buildToggleOptimizationTile({
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: AegisColors.textSecondary, size: 18.0),
          SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: AegisColors.textPrimary, fontSize: 13.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 3.0),
                Text(
                  description,
                  style: TextStyle(color: AegisColors.textSecondary, fontSize: 10.5),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24.0,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: AegisColors.neonGreen,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: AegisColors.border1,
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

class BatterySaverGaugePainter extends CustomPainter {
  final double percentage;

  BatterySaverGaugePainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    // Draw background track ring
    final Paint trackPaint = Paint()
      ..color = AegisColors.border1
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    // Draw active progress ring
    final Paint activePaint = Paint()
      ..color = AegisColors.neonGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    const double startAngle = 3 * pi / 4;
    const double sweepAngle = 3 * pi / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * percentage,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant BatterySaverGaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}
