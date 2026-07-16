import 'package:flutter/material.dart';

class StatusHistoryScreen extends StatelessWidget {
  const StatusHistoryScreen({super.key});

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE5E7EB);
  static const _blue = Color(0xFF2563EB);
  static const _green = Color(0xFF22C55E);
  static const _red = Color(0xFFFF3B30);
  static const _amber = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Status History',
            style: TextStyle(
                color: _ink, fontSize: 20, fontWeight: FontWeight.w900)),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: _line),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
          children: [
            _summary(),
            const SizedBox(height: 16),
            _section('TODAY'),
            const SizedBox(height: 10),
            _timelineCard([
              _event(_green, 'SIG-8AF3', 'Safe check-in received', '10:24 AM'),
              _divider(),
              _event(_blue, 'SIG-B2C1', 'Resource relayed successfully',
                  '09:50 AM'),
              _divider(),
              _event(
                  _amber, 'SIG-1D9A', 'Route updated: 3 hops away', '08:35 AM'),
            ]),
            const SizedBox(height: 16),
            _section('YESTERDAY'),
            const SizedBox(height: 10),
            _timelineCard([
              _event(_red, 'SIG-4D2F', 'SOS received and forwarded', '6:12 PM'),
              _divider(),
              _event(_green, 'SIG-C4E1', 'Joined the mesh', '2:31 PM'),
              _divider(),
              _event(_blue, 'SIG-7F3A', 'Identity verified', '11:08 AM'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _summary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _line),
      ),
      child: const Row(
        children: [
          Icon(Icons.timeline_rounded, color: _blue, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'A clean log of key mesh events, SOS alerts, and status changes.',
              style: TextStyle(color: _muted, fontSize: 12.5, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Row(
      children: [
        Container(
            width: 3,
            height: 18,
            decoration: BoxDecoration(
                color: _blue, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                color: _muted,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.6)),
      ],
    );
  }

  Widget _timelineCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x10000000), blurRadius: 14, offset: Offset(0, 4))
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _event(Color color, String node, String text, String time) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
            color: color.withOpacity(0.12), shape: BoxShape.circle),
        child: Icon(Icons.circle, color: color, size: 12),
      ),
      title: Text(node,
          style: const TextStyle(
              color: _ink, fontSize: 13.5, fontWeight: FontWeight.w800)),
      subtitle:
          Text(text, style: const TextStyle(color: _muted, fontSize: 11.5)),
      trailing: Text(time,
          style: const TextStyle(
              color: _muted, fontSize: 10.5, fontWeight: FontWeight.w700)),
    );
  }

  Widget _divider() =>
      const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6));
}
