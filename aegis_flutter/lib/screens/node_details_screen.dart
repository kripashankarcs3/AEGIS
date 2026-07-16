import 'package:flutter/material.dart';

import 'chat_conversation_screen.dart';

class NodeDetailsScreen extends StatelessWidget {
  final String nodeId;
  const NodeDetailsScreen({super.key, required this.nodeId});

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE5E7EB);
  static const _blue = Color(0xFF2563EB);
  static const _green = Color(0xFF22C55E);
  static const _violet = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    final isOffline = nodeId == 'SIG-9E10';

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
        title: const Text('Node Details',
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
            _profileCard(isOffline),
            const SizedBox(height: 16),
            _section('CONNECTION'),
            const SizedBox(height: 10),
            _infoCard([
              _infoRow('Link Quality', isOffline ? 'None' : 'Strong',
                  valueColor: isOffline ? _muted : _green),
              const Divider(height: 1, thickness: 1, color: _line),
              _infoRow('Latency', isOffline ? '--' : '28 ms'),
              const Divider(height: 1, thickness: 1, color: _line),
              _infoRow('Packets Relayed', isOffline ? '0' : '245'),
              const Divider(height: 1, thickness: 1, color: _line),
              _infoRow('Uptime', isOffline ? '--' : '2h 14m'),
            ]),
            const SizedBox(height: 16),
            _section('DEVICE INFO'),
            const SizedBox(height: 10),
            _infoCard([
              _infoRow('Device Name', 'Pixel 7'),
              const Divider(height: 1, thickness: 1, color: _line),
              _infoRow('Platform', 'Android 14'),
              const Divider(height: 1, thickness: 1, color: _line),
              _infoRow('App Version', '1.0.0+15'),
              const Divider(height: 1, thickness: 1, color: _line),
              _infoRow('Battery', '76%'),
            ]),
            const SizedBox(height: 16),
            _actions(context),
          ],
        ),
      ),
    );
  }

  Widget _profileCard(bool isOffline) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
              color: Color(0x10000000), blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFA855F7), Color(0xFF7C3AED)],
                  ),
                ),
                child: const Icon(Icons.person_rounded,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(nodeId,
                            style: const TextStyle(
                                color: _ink,
                                fontSize: 18,
                                fontWeight: FontWeight.w900)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isOffline
                                ? const Color(0xFFF1F5F9)
                                : const Color(0xFFEAFBF0),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                                color: isOffline
                                    ? _line
                                    : const Color(0xFFBBF7D0)),
                          ),
                          child: Text(
                            isOffline ? 'Offline' : 'Online',
                            style: TextStyle(
                                color: isOffline ? _muted : _green,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                        isOffline
                            ? 'Disconnected'
                            : '2 hops away • via SIG-B2C1',
                        style: const TextStyle(color: _muted, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(height: 1, thickness: 1, color: _line),
          const SizedBox(height: 14),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('First seen', style: TextStyle(color: _muted, fontSize: 12)),
              Text('2 mins ago',
                  style: TextStyle(
                      color: _ink, fontSize: 12, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Last seen', style: TextStyle(color: _muted, fontSize: 12)),
              Text('Just now',
                  style: TextStyle(
                      color: _ink, fontSize: 12, fontWeight: FontWeight.w800)),
            ],
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
                color: _violet, borderRadius: BorderRadius.circular(3))),
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

  Widget _infoCard(List<Widget> children) {
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

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: _muted, fontSize: 12.5)),
          Text(value,
              style: TextStyle(
                  color: valueColor ?? _ink,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _actions(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5F3FF),
                    foregroundColor: _violet,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    side: const BorderSide(color: Color(0xFFEDE9FE)),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            ChatConversationScreen(nodeId: nodeId)));
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                  label: const Text('Send Message',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFFBEB),
                    foregroundColor: const Color(0xFFD97706),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    side: const BorderSide(color: Color(0xFFFDE68A)),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.share_rounded, size: 18),
                  label: const Text('Share Resource',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEFF6FF),
              foregroundColor: _blue,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              side: const BorderSide(color: Color(0xFFBFDBFE)),
            ),
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.map_outlined, size: 18),
            label: const Text('View on Map',
                style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ),
      ],
    );
  }
}
