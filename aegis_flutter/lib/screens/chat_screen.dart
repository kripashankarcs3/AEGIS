import 'package:flutter/material.dart';

import 'broadcast_screen.dart';
import 'chat_conversation_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _showTip = true;

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE5E7EB);
  static const _blue = Color(0xFF1877F2);
  static const _green = Color(0xFF10B981);
  static const _red = Color(0xFFFF253A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: _blue,
        elevation: 10,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        onPressed: () => showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) => _sheet(),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 14),
              _meshSummary(),
              const SizedBox(height: 2),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _chatTile(
                      avatarColor: const Color(0xFF6D5DFB),
                      icon: Icons.support_agent_rounded,
                      nodeId: 'SIG-8AF3',
                      message: 'All good here. We have supplies.',
                      time: '',
                      badge: 'SAFE',
                      badgeColor: _green,
                      unread: 2,
                    ),
                    _divider(),
                    _chatTile(
                      avatarColor: _red,
                      icon: Icons.medical_services_rounded,
                      nodeId: 'SIG-4D2F',
                      message: 'Urgent! Need medical assistance.',
                      time: '10:18 AM',
                      badge: 'NEED HELP',
                      badgeColor: _red,
                      unread: 1,
                    ),
                    _divider(),
                    _chatTile(
                      avatarColor: Colors.black87,
                      icon: Icons.person_rounded,
                      nodeId: 'SIG-1A9D',
                      message: 'How many people in your group?',
                      time: '9:56 AM',
                    ),
                    _divider(),
                    _chatTile(
                      avatarColor: Colors.black87,
                      icon: Icons.person_rounded,
                      nodeId: 'SIG-B2C1',
                      message: 'Water available. 2 bottles left.',
                      time: '9:41 AM',
                    ),
                    _divider(),
                    _chatTile(
                      avatarColor: Colors.black87,
                      icon: Icons.person_rounded,
                      nodeId: 'SIG-3C7E',
                      message: 'Heading north. Roads blocked.',
                      time: '9:32 AM',
                    ),
                    const SizedBox(height: 26),
                    _tipBanner(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Chat',
            style: TextStyle(
              color: _ink,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ),
        _iconButton(Icons.search_rounded),
        const SizedBox(width: 12),
        _iconButton(Icons.tune_rounded),
      ],
    );
  }

  Widget _iconButton(IconData icon) {
    return SizedBox(
      width: 30,
      height: 30,
      child: Icon(icon, color: _ink, size: 23),
    );
  }

  Widget _meshSummary() {
    return Container(
      height: 32,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: _line, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration:
                const BoxDecoration(color: _green, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          const Text(
            '8 Nodes Online',
            style: TextStyle(
                color: _muted, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          const Icon(Icons.arrow_upward_rounded, color: _muted, size: 14),
          const SizedBox(width: 3),
          const Text(
            '127 Relayed',
            style: TextStyle(
                color: _muted, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _chatTile({
    required Color avatarColor,
    required IconData icon,
    required String nodeId,
    required String message,
    required String time,
    String? badge,
    Color? badgeColor,
    int unread = 0,
  }) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => ChatConversationScreen(nodeId: nodeId)),
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SizedBox(
        height: 92,
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: avatarColor.withOpacity(0.11),
                shape: BoxShape.circle,
                border: Border.all(color: avatarColor.withOpacity(0.12)),
              ),
              child: Center(
                child: Icon(icon, color: avatarColor, size: 24),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          nodeId,
                          style: const TextStyle(
                            color: _ink,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: badgeColor!.withOpacity(0.13),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              color: badgeColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        )
                      else
                        Text(
                          time,
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF374151),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (time.isNotEmpty && badge != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          time,
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      if (unread > 0) ...[
                        const SizedBox(width: 10),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: unread == 1 ? _red : _blue,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$unread',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, thickness: 1, color: _line, indent: 62);
  }

  Widget _tipBanner() {
    if (!_showTip) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF3FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: _blue, size: 20),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Tip: Long press on a chat\nfor more options',
              style: TextStyle(
                  color: _blue,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1.25),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => setState(() => _showTip = false),
            icon: const Icon(Icons.close_rounded, color: _blue, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _sheet() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 42,
                height: 5,
                decoration: BoxDecoration(
                    color: _line, borderRadius: BorderRadius.circular(3))),
            const SizedBox(height: 20),
            _sheetOpt(Icons.chat_bubble_outline_rounded, 'New Chat',
                () => Navigator.of(context).pop()),
            _sheetOpt(Icons.podcasts_rounded, 'Broadcast Message', () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BroadcastScreen()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _sheetOpt(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: _blue),
      title: Text(label,
          style: const TextStyle(color: _ink, fontWeight: FontWeight.w700)),
    );
  }
}
