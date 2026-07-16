import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import '../constants/aegis_colors.dart';
import '../providers/survivor_provider.dart';

class ShareFileScreen extends ConsumerWidget {
  const ShareFileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF090D16),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Share File',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline_rounded, color: Colors.white, size: 22.0),
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
                      Icon(
                        Icons.add_to_photos_rounded,
                        color: AegisColors.textSecondary,
                        size: 34.0,
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        'Drag & drop file here',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        'or',
                        style: TextStyle(
                          color: AegisColors.textMuted,
                          fontSize: 11.0,
                        ),
                      ),
                      SizedBox(height: 14.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: AegisColors.violet.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Text(
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
              SizedBox(height: 24.0),

              // 2. Nearby Devices Title
              Text(
                'Nearby Devices',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: AegisColors.textSecondary,
                ),
              ),
              SizedBox(height: 12.0),

              // 3. List of Nearby Devices
              Expanded(
                child: _buildPeerList(ref),
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
                  color: AegisColors.neonGreen.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.sensors_rounded,
                  color: AegisColors.neonGreen,
                  size: 16.0,
                ),
              ),
              SizedBox(width: 14.0),
              // Device Details info
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nodeId,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    hops,
                    style: TextStyle(
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
              color: AegisColors.violet.withOpacity(0.1).withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(color: AegisColors.violet.withOpacity(0.4), width: 1.0),
            ),
            child: Center(
              child: Icon(
                Icons.send_rounded,
                color: AegisColors.violet,
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

  Widget _buildPeerList(WidgetRef ref) {
    final peers = ref.watch(survivorProvider);
    if (peers.isEmpty) {
      return Center(
        child: Text(
          'No peers available',
          style: TextStyle(
            color: AegisColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
    final items = peers.values.toList();
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final peer = items[index];
        final status = peer.isOffline ? 'Offline' : 'Online';
        return Column(
          children: [
            if (index > 0) _buildInnerDivider(),
            _buildShareDeviceRow(peer.id, status),
          ],
        );
      },
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
