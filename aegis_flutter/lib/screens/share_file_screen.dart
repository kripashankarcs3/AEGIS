import 'package:flutter/material.dart';
import 'dart:ui';
import '../constants/aegis_colors.dart';

class ShareFileScreen extends StatelessWidget {
  const ShareFileScreen({super.key});

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
          'Share File',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, color: Colors.white, size: 22.0),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Dashed Border Upload Area
              CustomPaint(
                painter: DashedBorderPainter(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_to_photos_rounded,
                        color: AegisColors.textSecondary,
                        size: 34.0,
                      ),
                      const SizedBox(height: 12.0),
                      const Text(
                        'Drag & drop file here',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      const Text(
                        'or',
                        style: TextStyle(
                          color: AegisColors.textMuted,
                          fontSize: 11.0,
                        ),
                      ),
                      const SizedBox(height: 14.0),
                      // Choose File Button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: AegisColors.purpleLightBg,
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: const Text(
                          'Choose File',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              // 2. Nearby Devices Title
              const Text(
                'Nearby Devices',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: AegisColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12.0),

              // 3. List of Nearby Devices
              Expanded(
                child: ListView(
                  children: [
                    _buildShareDeviceRow('SIG-8AF3', '2 hops'),
                    _buildInnerDivider(),
                    _buildShareDeviceRow('SIG-C4E1', '1 hop'),
                    _buildInnerDivider(),
                    _buildShareDeviceRow('SIG-B2C1', '2 hops'),
                    _buildInnerDivider(),
                    _buildShareDeviceRow('SIG-1A9D', '3 hops'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareDeviceRow(String nodeId, String hops) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Device circular avatar
              Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: AegisColors.activeGreen.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sensors_rounded,
                  color: AegisColors.activeGreen,
                  size: 16.0,
                ),
              ),
              const SizedBox(width: 14.0),
              // Device Details info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nodeId,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    hops,
                    style: const TextStyle(
                      fontSize: 11.0,
                      color: AegisColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Purple Circle Send/Arrow icon button
          Container(
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              color: AegisColors.purpleLightBg.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(color: AegisColors.busyPurple.withOpacity(0.4), width: 1.0),
            ),
            child: const Center(
              child: Icon(
                Icons.send_rounded,
                color: AegisColors.busyPurple,
                size: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerDivider() {
    return const Divider(
      color: Color(0xFF1E293B),
      height: 1.0,
      thickness: 0.5,
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1F2937)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(8.0),
    );

    final Path path = Path()..addRRect(rrect);
    
    // Draw dashed path
    const double dashWidth = 5.0;
    const double dashSpace = 4.0;
    
    double distance = 0.0;
    for (final PathMetric metric in path.computeMetrics()) {
      while (distance < metric.length) {
        final double end = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, end),
          paint,
        );
        distance = end + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
