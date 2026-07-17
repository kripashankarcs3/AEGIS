import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui';
import '../constants/aegis_colors.dart';
import '../providers/survivor_provider.dart';
import '../providers/mesh_provider.dart';
import '../providers/identity_provider.dart';
import '../models/signal_packet.dart';

class ShareFileScreen extends ConsumerStatefulWidget {
  const ShareFileScreen({super.key});

  @override
  ConsumerState<ShareFileScreen> createState() => _ShareFileScreenState();
}

class _ShareFileScreenState extends ConsumerState<ShareFileScreen> {
  XFile? _selectedFile;

  Future<void> _pickFile() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (picked != null) {
      setState(() => _selectedFile = picked);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected: ${picked.name}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _sendFile(String peerId) async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a file first'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final sigId = ref.read(sigIdProvider);

    final packet = SignalPacket(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      from: sigId,
      to: peerId,
      type: PacketType.chat,
      payload: '📎 File shared: ${_selectedFile!.name}',
      ttl: 5,
      hopCount: 0,
      path: [sigId],
      timestamp: DateTime.now(),
    );

    await ref.read(meshProvider.notifier).sendPacket(packet);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File sent to $peerId'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

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
          'Share File',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: AegisColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline_rounded, color: AegisColors.textPrimary, size: 22.0),
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
              CustomPaint(
                painter: DashedBorderPainter(),
                child: GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _selectedFile != null
                              ? Icons.check_circle_outline_rounded
                              : Icons.add_to_photos_rounded,
                          color: _selectedFile != null
                              ? AegisColors.neonGreen
                              : AegisColors.textSecondary,
                          size: 34.0,
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          _selectedFile != null
                              ? _selectedFile!.name
                              : 'Drag & drop file here',
                          style: TextStyle(
                            color: AegisColors.textPrimary,
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6.0),
                        Text(
                          _selectedFile != null
                              ? 'Tap to change file'
                              : 'or',
                          style: TextStyle(
                            color: AegisColors.textMuted,
                            fontSize: 11.0,
                          ),
                        ),
                        SizedBox(height: 14.0),
                        GestureDetector(
                          onTap: _pickFile,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: AegisColors.violet.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Text(
                              _selectedFile != null ? 'Change File' : 'Choose File',
                              style: TextStyle(
                                color: AegisColors.violet,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Text(
                'Nearby Devices',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: AegisColors.textSecondary,
                ),
              ),
              SizedBox(height: 12.0),
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
              Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: AegisColors.neonGreen.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.sensors_rounded,
                  color: AegisColors.neonGreen,
                  size: 16.0,
                ),
              ),
              SizedBox(width: 14.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nodeId,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AegisColors.textPrimary,
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
          GestureDetector(
            onTap: () => _sendFile(nodeId),
            child: Container(
              width: 32.0,
              height: 32.0,
              decoration: BoxDecoration(
                color: _selectedFile != null
                    ? AegisColors.violet.withValues(alpha: 0.15)
                    : AegisColors.violet.withValues(alpha: 0.05),
                shape: BoxShape.circle,
                border: Border.all(
                  color: _selectedFile != null
                      ? AegisColors.violet
                      : AegisColors.violet.withValues(alpha: 0.2),
                  width: 1.0,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.send_rounded,
                  color: _selectedFile != null
                      ? AegisColors.violet
                      : AegisColors.violet.withValues(alpha: 0.3),
                  size: 14.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerDivider() {
    return Divider(
      color: AegisColors.border1,
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
      ..color = AegisColors.border2
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(8.0),
    );

    final Path path = Path()..addRRect(rrect);

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