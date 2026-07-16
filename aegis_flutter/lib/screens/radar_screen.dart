import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/mesh_provider.dart';
import 'chat_conversation_screen.dart';
import 'sos_incoming_overlay.dart';

class RadarScreen extends ConsumerWidget {
  const RadarScreen({super.key});

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE5E7EB);
  static const _blue = Color(0xFF1877F2);
  static const _green = Color(0xFF12C878);
  static const _orange = Color(0xFFFF8A1D);
  static const _red = Color(0xFFFF253A);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final peerCount = ref.watch(meshPeerCountProvider);
    final packetsRelayed = ref.watch(meshPacketsRelayedProvider);
    final isConnected = ref.watch(meshConnectedProvider);
    final activity = ref.watch(meshActivityProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 102),
          child: Column(
            children: [
              SizedBox(
                height: 455,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Positioned.fill(child: _RadarMap()),
                    Positioned(
                        left: 8, top: 2, child: _statusPill(isConnected)),
                    Positioned(right: 8, top: 0, child: _nodesPill(peerCount)),
                    Positioned(right: 4, top: 290, child: _mapTools()),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _networkOverview(peerCount, packetsRelayed),
              const SizedBox(height: 12),
              _recentActivity(activity),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusPill(bool isConnected) {
    return Row(
      children: [
        _SmallDot(color: isConnected ? _green : _muted, size: 11),
        const SizedBox(width: 9),
        Text(
          isConnected ? 'Mesh Active' : 'Searching...',
          style: TextStyle(
              color: isConnected ? _green : _muted,
              fontSize: 16,
              fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  Widget _nodesPill(int peerCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F3FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('$peerCount Node${peerCount == 1 ? '' : 's'}',
          style: const TextStyle(
              color: _blue, fontSize: 16, fontWeight: FontWeight.w900)),
    );
  }

  Widget _mapTools() {
    return Column(
      children: [
        _toolButton(Icons.open_in_full_rounded),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 12,
                  offset: Offset(0, 4))
            ],
            border: Border.all(color: _line),
          ),
          child: const Column(
            children: [
              SizedBox(
                  width: 40,
                  height: 42,
                  child: Icon(Icons.add_rounded, color: _ink, size: 26)),
              SizedBox(width: 40, child: Divider(height: 1, color: _line)),
              SizedBox(
                  width: 40,
                  height: 42,
                  child: Icon(Icons.remove_rounded, color: _ink, size: 26)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _toolButton(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x18000000), blurRadius: 12, offset: Offset(0, 4))
        ],
      ),
      child: Icon(icon, color: _ink, size: 22),
    );
  }

  Widget _networkOverview(int peerCount, int packetsRelayed) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x10000000), blurRadius: 14, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('NETWORK OVERVIEW',
              style: TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 11,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 17),
          Row(
            children: [
              _stat('$peerCount', 'Nodes'),
              _vLine(),
              _stat('$packetsRelayed', 'Packets Relayed'),
              _vLine(),
              _stat('—', 'Avg Latency'),
              _vLine(),
              _stat('—', 'Coverage'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: _ink,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  height: 1)),
          const SizedBox(height: 9),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: _muted, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _vLine() => Container(width: 1, height: 45, color: _line);

  Widget _recentActivity(List<String> activity) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 12, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x10000000), blurRadius: 14, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('RECENT ACTIVITY',
                    style: TextStyle(
                        color: Color(0xFF374151),
                        fontSize: 11,
                        fontWeight: FontWeight.w900)),
              ),
              Icon(Icons.close_rounded, color: Colors.grey.shade400, size: 17),
            ],
          ),
          const SizedBox(height: 16),
          if (activity.isEmpty)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('No recent activity.',
                  style: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            )
          else
            ...activity.take(5).map((msg) => _activity(
                  _green,
                  Icons.circle,
                  msg,
                  '',
                )),
        ],
      ),
    );
  }

  Widget _activity(Color color, IconData icon, String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          SizedBox(
              width: 18,
              child: Icon(icon,
                  color: color, size: icon == Icons.circle ? 11 : 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
          ),
          Text(time,
              style: const TextStyle(
                  color: _muted, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _RadarMap extends StatelessWidget {
  const _RadarMap();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final center = Offset(w * 0.50, h * 0.49);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
                child: CustomPaint(painter: _RadarPainter(center: center))),
            _userNode(context, center),
            _node(context, center + Offset(0, -154), 'SIG-8AF3', '2 hops',
                RadarScreen._green, Icons.local_fire_department_rounded),
            _node(context, center + Offset(-118, -86), 'SIG-C4E1', '1 hop',
                RadarScreen._green, Icons.local_fire_department_rounded),
            _node(context, center + Offset(118, -47), 'SIG-B2C1', '2 hops',
                RadarScreen._orange, Icons.local_fire_department_rounded),
            _node(context, center + Offset(-120, 126), 'SIG-1D9A', '3 hops',
                RadarScreen._red, Icons.local_fire_department_rounded,
                sos: true),
            _node(context, center + Offset(80, 176), 'SIG-9E10', 'Offline',
                const Color(0xFFD8DDE3), Icons.circle,
                offline: true),
          ],
        );
      },
    );
  }

  Widget _userNode(BuildContext context, Offset center) {
    return Positioned(
      left: center.dx - 44,
      top: center.dy - 36,
      child: const SizedBox(
        width: 88,
        child: Column(
          children: [
            _GlowNode(
                color: RadarScreen._blue,
                icon: Icons.person_rounded,
                size: 58,
                ring: true),
            SizedBox(height: 9),
            Text('SIG-7F3A',
                style: TextStyle(
                    color: RadarScreen._ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    height: 1)),
            SizedBox(height: 5),
            Text('You',
                style: TextStyle(
                    color: RadarScreen._ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    height: 1)),
          ],
        ),
      ),
    );
  }

  Widget _node(
    BuildContext context,
    Offset position,
    String title,
    String subtitle,
    Color color,
    IconData icon, {
    bool sos = false,
    bool offline = false,
  }) {
    return Positioned(
      left: position.dx - 45,
      top: position.dy - 39,
      child: GestureDetector(
        onTap: () {
          if (sos) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const SosIncomingOverlayScreen()));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ChatConversationScreen(nodeId: title)));
          }
        },
        child: SizedBox(
          width: 90,
          child: Column(
            children: [
              _GlowNode(color: color, icon: icon, size: 44, muted: offline),
              const SizedBox(height: 7),
              Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: RadarScreen._ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      height: 1.05)),
              const SizedBox(height: 4),
              Text(subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: offline ? Colors.grey.shade500 : RadarScreen._ink,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final Offset center;
  const _RadarPainter({required this.center});

  @override
  void paint(Canvas canvas, Size size) {
    final maxR = min(size.width, size.height) * 0.59;
    final ringPaint = Paint()
      ..color = const Color(0xFFE8F1FA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 1; i <= 9; i++) {
      canvas.drawCircle(center, maxR * i / 9, ringPaint);
    }

    final spoke = Paint()
      ..color = const Color(0xFFEAF2FA)
      ..strokeWidth = 1;
    for (var i = 0; i < 12; i++) {
      final a = pi * 2 * i / 12;
      canvas.drawLine(center, center + Offset(cos(a), sin(a)) * maxR, spoke);
    }

    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          RadarScreen._blue.withOpacity(0.13),
          RadarScreen._blue.withOpacity(0.04),
          Colors.transparent
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: maxR * 0.72));
    canvas.drawCircle(center, maxR * 0.72, glow);

    _line(canvas, center, center + const Offset(0, -154), RadarScreen._green,
        dashed: true);
    _line(canvas, center, center + const Offset(-118, -86), RadarScreen._green,
        dashed: true);
    _line(canvas, center, center + const Offset(118, -47), RadarScreen._orange,
        dashed: true);
    _line(canvas, center, center + const Offset(-120, 126), RadarScreen._red,
        dashed: true);
    _line(canvas, center, center + const Offset(80, 176), Colors.grey.shade400,
        dashed: true);

    final sector = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(center.dx - 34, center.dy + 176)
      ..lineTo(center.dx - 76, center.dy + 150)
      ..close();
    canvas.drawPath(
        sector, Paint()..color = RadarScreen._blue.withOpacity(0.20));
  }

  void _line(Canvas canvas, Offset a, Offset b, Color color,
      {bool dashed = false}) {
    final paint = Paint()
      ..color = color.withOpacity(0.60)
      ..strokeWidth = 1.4;
    if (!dashed) {
      canvas.drawLine(a, b, paint);
      return;
    }
    final delta = b - a;
    final distance = delta.distance;
    const dash = 5.0;
    const gap = 4.0;
    for (double t = 0; t < distance; t += dash + gap) {
      final start = a + delta * (t / distance);
      final end = a + delta * (min(t + dash, distance) / distance);
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => false;
}

class _GlowNode extends StatelessWidget {
  final Color color;
  final IconData icon;
  final double size;
  final bool ring;
  final bool muted;

  const _GlowNode({
    required this.color,
    required this.icon,
    required this.size,
    this.ring = false,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + 18,
      height: size + 18,
      decoration: BoxDecoration(
        color: color.withOpacity(muted ? 0.14 : 0.13),
        shape: BoxShape.circle,
        border:
            ring ? Border.all(color: color.withOpacity(0.26), width: 7) : null,
      ),
      child: Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: muted ? color.withOpacity(0.75) : color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 5),
            boxShadow: [
              BoxShadow(
                  color: color.withOpacity(muted ? 0.08 : 0.25),
                  blurRadius: 12,
                  spreadRadius: 2),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: size * 0.38),
        ),
      ),
    );
  }
}

class _SmallDot extends StatelessWidget {
  final Color color;
  final double size;
  const _SmallDot({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}
