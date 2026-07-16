import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/chat_provider.dart';
import 'share_file_screen.dart';
import 'voice_message_screen.dart';

class ChatConversationScreen extends ConsumerStatefulWidget {
  final String nodeId;
  const ChatConversationScreen({super.key, required this.nodeId});

  @override
  ConsumerState<ChatConversationScreen> createState() =>
      _ChatConversationScreenState();
}

class _ChatConversationScreenState
    extends ConsumerState<ChatConversationScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE5E7EB);
  static const _blue = Color(0xFF1877F2);

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();
    ref.read(chatProvider(widget.nodeId).notifier).send(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider(widget.nodeId).notifier).messages;

    // Scroll when new messages arrive
    ref.listen(chatProvider(widget.nodeId), (_, __) => _scrollToBottom());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 48,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _ink, size: 25),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.nodeId,
              style: const TextStyle(
                  color: _ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  height: 1),
            ),
            const SizedBox(height: 7),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StatusDot(),
                const SizedBox(width: 6),
                const Text('Online',
                    style: TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 12,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: _ink, size: 24),
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
        top: false,
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? const Center(
                      child: Text('No messages yet.\nSay hello!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: _muted,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(18, 26, 18, 12),
                      itemCount: messages.length,
                      itemBuilder: (_, i) {
                        final msg = messages[i];
                        return msg.isMine
                            ? _OutgoingBubble(
                                text: msg.message,
                                time: _formatTime(msg.timestamp),
                              )
                            : _IncomingBubble(
                                text: msg.message,
                                time: _formatTime(msg.timestamp),
                              );
                      },
                    ),
            ),
            _MessageInput(
              controller: _textController,
              onSend: _sendMessage,
              onAttach: () => _showAttachSheet(context),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void _showAttachSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
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
              const SizedBox(height: 18),
              ListTile(
                leading: const Icon(Icons.file_present_rounded, color: _blue),
                title: const Text('Share File',
                    style: TextStyle(color: _ink, fontWeight: FontWeight.w700)),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const ShareFileScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.mic_none_rounded, color: _blue),
                title: const Text('Voice Message',
                    style: TextStyle(color: _ink, fontWeight: FontWeight.w700)),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const VoiceMessageScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// UI components
// ─────────────────────────────────────────────────────────────────────────────

class _StatusDot extends StatelessWidget {
  const _StatusDot();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration:
          const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
    );
  }
}

class _IncomingBubble extends StatelessWidget {
  final String text;
  final String time;
  const _IncomingBubble({required this.text, required this.time});

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 240),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        decoration: const BoxDecoration(
          color: Color(0xFFF2F3F5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(3),
            topRight: Radius.circular(14),
            bottomLeft: Radius.circular(3),
            bottomRight: Radius.circular(14),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text,
                style: const TextStyle(
                    color: _ink,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.18)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(time,
                  style: const TextStyle(
                      color: _muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutgoingBubble extends StatelessWidget {
  final String text;
  final String time;
  const _OutgoingBubble({required this.text, required this.time});

  static const _blue = Color(0xFF1877F2);
  // _ink removed (unused — outgoing bubble uses white text on blue bg)

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 240),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
        decoration: const BoxDecoration(
          color: _blue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(3),
            bottomLeft: Radius.circular(14),
            bottomRight: Radius.circular(3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(text,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.18)),
            ),
            const SizedBox(height: 7),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(time,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.78),
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
                const SizedBox(width: 4),
                Icon(Icons.done_all_rounded,
                    color: Colors.white.withValues(alpha: 0.9), size: 13),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttach;

  const _MessageInput({
    required this.controller,
    required this.onSend,
    required this.onAttach,
  });

  static const _ink = Color(0xFF111827);
  static const _line = Color(0xFFE5E7EB);
  static const _blue = Color(0xFF1877F2);
  static const _muted = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 94),
      decoration: const BoxDecoration(color: Colors.white),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: _line),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 18),
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(color: _ink, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                  border: InputBorder.none,
                  isDense: true,
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: onAttach,
              icon: const Icon(Icons.attach_file_rounded,
                  color: _muted, size: 23),
            ),
            GestureDetector(
              onTap: onSend,
              child: Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(right: 7),
                decoration:
                    const BoxDecoration(color: _blue, shape: BoxShape.circle),
                child: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
