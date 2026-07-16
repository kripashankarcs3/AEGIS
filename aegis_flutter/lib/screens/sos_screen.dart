import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../providers/mesh_provider.dart';

class SosScreen extends ConsumerStatefulWidget {
  const SosScreen({super.key});

  @override
  ConsumerState<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends ConsumerState<SosScreen> {
  int _selectedCategory = 0;
  int _priority = 2;
  bool _isSending = false;
  final _detailsController = TextEditingController();

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE5E7EB);
  static const _red = Color(0xFFFF2D3D);
  static const _orange = Color(0xFFFF8A1D);
  static const _blue = Color(0xFF2F9BFF);
  static const _violet = Color(0xFF7C7A9E);

  final _categories = const [
    _EmergencyType('Medical', Icons.medical_services_rounded, _red),
    _EmergencyType(
        'Fire', Icons.local_fire_department_rounded, Color(0xFFFF3B22)),
    _EmergencyType('Water', Icons.water_drop_rounded, _blue),
    _EmergencyType('Trapped', Icons.warning_amber_rounded, _orange),
    _EmergencyType('Other', Icons.more_horiz_rounded, _violet),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 102),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 18),
              _broadcastCard(),
              const SizedBox(height: 14),
              _sectionTitle('EMERGENCY TYPE'),
              const SizedBox(height: 12),
              _categoryRow(),
              const SizedBox(height: 18),
              _sectionTitle('PRIORITY LEVEL'),
              const SizedBox(height: 10),
              _prioritySelector(),
              const SizedBox(height: 18),
              _sectionTitle('ADDITIONAL DETAILS (OPTIONAL)'),
              const SizedBox(height: 10),
              _detailsBox(),
              const SizedBox(height: 14),
              _broadcastButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: _red,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x22FF2D3D),
                    blurRadius: 10,
                    offset: Offset(0, 4))
              ],
            ),
            child: const Icon(Icons.warning_amber_rounded,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Text(
              'SOS',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                  height: 1),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                    color: Color(0x18000000),
                    blurRadius: 14,
                    offset: Offset(0, 4))
              ],
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: const Icon(Icons.info_outline_rounded,
                color: Color(0xFF111A3A), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _broadcastCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(17, 16, 17, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x12000000), blurRadius: 18, offset: Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: const BoxDecoration(
                    color: Color(0xFFFFE5E7), shape: BoxShape.circle),
                child:
                    const Icon(Icons.campaign_rounded, color: _red, size: 31),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Emergency Broadcast',
                        style: TextStyle(
                            color: _ink,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            height: 1.1)),
                    SizedBox(height: 9),
                    Text(
                      'Notify every nearby mesh node instantly.\nYour location and request will be shared.',
                      style: TextStyle(
                          color: _muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.35),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          const Divider(height: 1, color: _line),
          const SizedBox(height: 17),
          const _CountdownButton(),
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
                color: _red, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 12),
        Text(text,
            style: const TextStyle(
                color: Color(0xFF4B5563),
                fontSize: 11,
                fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _categoryRow() {
    return Row(
      children: List.generate(_categories.length, (index) {
        return Expanded(
          child: Padding(
            padding:
                EdgeInsets.only(right: index == _categories.length - 1 ? 0 : 7),
            child: _categoryCard(index),
          ),
        );
      }),
    );
  }

  Widget _categoryCard(int index) {
    final item = _categories[index];
    final selected = _selectedCategory == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = index),
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          color: selected ? item.color.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: selected ? item.color.withOpacity(0.18) : _line),
          boxShadow: const [
            BoxShadow(
                color: Color(0x11000000), blurRadius: 10, offset: Offset(0, 3))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: item.color, size: 25),
            const SizedBox(height: 7),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: selected ? item.color : _ink,
                  fontSize: 10,
                  fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }

  Widget _prioritySelector() {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          _priorityItem(0, 'Low'),
          _priorityDivider(),
          _priorityItem(1, 'Medium'),
          _priorityDivider(),
          _priorityItem(2, 'High'),
        ],
      ),
    );
  }

  Widget _priorityItem(int index, String label) {
    final selected = _priority == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _priority = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 31,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFFE1E2) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: selected ? _red : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: selected ? _red : const Color(0xFFB9C0CC),
                      width: 1.4),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                    color: selected ? _red : _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priorityDivider() => Container(width: 1, height: 28, color: _line);

  Widget _detailsBox() {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 3))
        ],
      ),
      child: const Stack(
        children: [
          Positioned(
            left: 14,
            top: 13,
            child: Text(
              'Describe your emergency...',
              style: TextStyle(
                  color: Color(0xFFB2B8C4),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Positioned(
            right: 14,
            bottom: 9,
            child: Text('0 / 200',
                style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 11,
                    fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  Widget _broadcastButton() {
    return Center(
      child: GestureDetector(
        onTap: _isSending ? null : _triggerSOS,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 285,
          height: 47,
          decoration: BoxDecoration(
            color: _isSending ? _red.withValues(alpha: 0.6) : _red,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x2EFF2D3D),
                  blurRadius: 18,
                  offset: Offset(0, 8))
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isSending)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                )
              else
                const Icon(Icons.emergency_share_rounded,
                    color: Colors.white, size: 25),
              const SizedBox(width: 11),
              Text(
                _isSending ? 'Sending...' : 'Broadcast Emergency',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _triggerSOS() async {
    final meshNotifier = ref.read(meshProvider.notifier);
    final sosHandler = meshNotifier.sosHandler;

    setState(() => _isSending = true);
    HapticFeedback.heavyImpact();

    // Try to get GPS (best-effort, 5s timeout)
    double lat = 0.0;
    double lng = 0.0;
    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 5));
      lat = pos.latitude;
      lng = pos.longitude;
    } catch (_) {
      // GPS unavailable — send with 0,0 coordinates
    }

    final customMessage = _detailsController.text.trim();
    final categories = ['Medical', 'Fire', 'Water', 'Trapped', 'Emergency'];
    final categoryMsg = categories[_selectedCategory];
    final finalMessage = customMessage.isEmpty
        ? '$categoryMsg emergency!'
        : '$categoryMsg: $customMessage';

    try {
      await sosHandler.sendSOS(
        latitude: lat,
        longitude: lng,
        message: finalMessage,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SOS broadcast sent to mesh network.'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send SOS: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }
}

class _CountdownButton extends StatelessWidget {
  const _CountdownButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 236,
      height: 236,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
              size: const Size.square(236), painter: _CountdownRingPainter()),
          Container(
            width: 170,
            height: 170,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0xFFFF635F), _SosScreenState._red],
                radius: 0.85,
              ),
              boxShadow: [
                BoxShadow(
                    color: Color(0x3DFF2D3D), blurRadius: 33, spreadRadius: 12),
              ],
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('HOLD TO SEND',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800)),
                SizedBox(height: 19),
                Text('05:00',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 41,
                        fontWeight: FontWeight.w900,
                        height: 1)),
                SizedBox(height: 20),
                Text('Hold for 5 seconds',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 14;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFFFFD8DB)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );

    final rect = Rect.fromCircle(center: center, radius: radius);
    final arcPaint = Paint()
      ..color = _SosScreenState._red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;

    canvas.drawArc(rect, -pi / 2 + 0.03, pi * 1.55, false, arcPaint);
    canvas.drawArc(rect, pi * 0.88, pi * 0.46, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _EmergencyType {
  final String label;
  final IconData icon;
  final Color color;

  const _EmergencyType(this.label, this.icon, this.color);
}
