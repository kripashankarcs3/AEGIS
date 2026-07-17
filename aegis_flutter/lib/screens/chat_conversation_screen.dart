import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/aegis_colors.dart';
import '../constants/aegis_styles.dart';
import '../models/survivor_node_model.dart';
import '../providers/chat_provider.dart';
import '../providers/survivor_provider.dart';
import '../services/storage_service.dart';

class ChatConversationScreen extends ConsumerStatefulWidget {
  final String nodeId;
  const ChatConversationScreen({super.key, required this.nodeId});

  @override
  ConsumerState<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends ConsumerState<ChatConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showScrollDownFab = false;
  int _prevMsgCount = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      final showFab = currentScroll < maxScroll - 120;
      if (showFab != _showScrollDownFab) {
        setState(() => _showScrollDownFab = showFab);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider(widget.nodeId).notifier).clearUnread();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _autoScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    ref.read(chatProvider(widget.nodeId).notifier).send(text);
    _messageController.clear();
    _autoScroll();
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDate = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(msgDate).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '${dt.day}/${dt.month}';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _copyMessage(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message copied'), behavior: SnackBarBehavior.floating, duration: Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider(widget.nodeId));
    final hasQueued = messages.any((m) => m.isMine && m.status == MessageStatus.queued);
    final peerData = ref.watch(survivorProvider);
    final peerStatus = peerData[widget.nodeId] ?? SurvivorNodeModel(id: widget.nodeId, status: 'unknown', lastSeen: 0);
    final isOnline = !peerStatus.isOffline && peerStatus.lastSeen > DateTime.now().millisecondsSinceEpoch - 120000;

    if (messages.length != _prevMsgCount && _prevMsgCount > 0 && messages.length > _prevMsgCount) {
      _autoScroll();
    }
    _prevMsgCount = messages.length;

    return Scaffold(
      backgroundColor: AegisColors.background,
      appBar: AppBar(
        backgroundColor: AegisColors.surface0.withValues(alpha: 0.95),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: AegisColors.surface2, shape: BoxShape.circle, border: Border.all(color: AegisColors.border1, width: 0.5)),
          child: IconButton(icon: Icon(Icons.arrow_back, color: AegisColors.textPrimary, size: 20), onPressed: () => Navigator.of(context).pop()),
        ),
        title: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              gradient: isOnline ? AegisColors.greenGradient : LinearGradient(colors: [AegisColors.textMuted, AegisColors.textDim]),
              shape: BoxShape.circle,
              boxShadow: isOnline ? [BoxShadow(color: AegisColors.neonGreen.withValues(alpha: 0.3), blurRadius: 8, spreadRadius: 1)] : null,
            ),
            child: Center(child: Icon(Icons.person_rounded, color: Colors.white, size: 18)),
          ),
          SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.nodeId, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AegisColors.textPrimary, letterSpacing: -0.2)),
            SizedBox(height: 2),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 6, height: 6, decoration: BoxDecoration(color: isOnline ? AegisColors.neonGreen : AegisColors.textMuted, shape: BoxShape.circle)),
              SizedBox(width: 6),
              Text(isOnline ? 'Online' : 'Offline', style: TextStyle(fontSize: 11, color: isOnline ? AegisColors.neonGreen : AegisColors.textMuted, fontWeight: FontWeight.w700)),
            ]),
          ]),
        ]),
        actions: [
          Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: AegisColors.surface2, shape: BoxShape.circle, border: Border.all(color: AegisColors.border1, width: 0.5)),
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: AegisColors.textPrimary, size: 20),
              onSelected: (value) {
                if (value == 'clear') {
                  StorageService.clearChatHistory(widget.nodeId);
                } else if (value == 'info') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Peer: ${widget.nodeId}\nStatus: ${isOnline ? 'Online' : 'Offline'}'), behavior: SnackBarBehavior.floating),
                  );
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'info', child: Text('Peer Info', style: TextStyle(color: AegisColors.textPrimary))),
                PopupMenuItem(value: 'clear', child: Text('Clear Chat', style: TextStyle(color: AegisColors.sosRed))),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: Stack(children: [
              messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded, size: 48, color: AegisColors.textMuted),
                          SizedBox(height: 16),
                          Text('No messages yet', style: TextStyle(color: AegisColors.textMuted, fontSize: 15, fontWeight: FontWeight.w500)),
                          SizedBox(height: 8),
                          Text('Send a message to start the conversation', style: TextStyle(color: AegisColors.textDim, fontSize: 13)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      itemCount: _buildMessageItems(messages).length,
                      itemBuilder: (context, index) => _buildMessageItems(messages)[index],
                    ),
              if (_showScrollDownFab && messages.isNotEmpty)
                Positioned(
                  right: 8, bottom: 8,
                  child: GestureDetector(
                    onTap: _autoScroll,
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: AegisColors.surface2, shape: BoxShape.circle, border: Border.all(color: AegisColors.border1, width: 0.5), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)]),
                      child: Icon(Icons.keyboard_arrow_down_rounded, color: AegisColors.textPrimary, size: 22),
                    ),
                  ),
                ),
            ]),
          ),
          if (hasQueued) _offlineBanner(),
          _input(),
        ]),
      ),
    );
  }

  List<Widget> _buildMessageItems(List<ChatEntry> messages) {
    final items = <Widget>[];
    DateTime? lastDate;

    for (final entry in messages) {
      final msgDate = entry.timestamp;
      if (lastDate == null || !_isSameDay(lastDate, msgDate)) {
        items.add(_dateSeparator(msgDate));
        lastDate = msgDate;
      }

      final time = _formatTime(entry.timestamp);
      if (entry.isMine) {
        if (entry.status == MessageStatus.queued) {
          items.add(_queued(entry, time));
        } else {
          items.add(_outgoing(entry, time));
        }
      } else {
        items.add(_incoming(entry, time));
      }
    }
    return items;
  }

  Widget _dateSeparator(DateTime dt) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(12), border: Border.all(color: AegisColors.border1.withValues(alpha: 0.3), width: 0.5)),
          child: Text(_formatDate(dt), style: TextStyle(color: AegisColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  Widget _incoming(ChatEntry entry, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Container(
          width: 28, height: 28,
          decoration: BoxDecoration(gradient: LinearGradient(colors: [AegisColors.violet.withValues(alpha: 0.3), AegisColors.violet.withValues(alpha: 0.1)]), shape: BoxShape.circle),
          child: Center(child: Icon(Icons.person_rounded, size: 14, color: AegisColors.violet)),
        ),
        SizedBox(width: 8),
        Flexible(
          child: GestureDetector(
            onLongPress: () => _copyMessage(entry.text),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AegisColors.isLight ? const Color(0xFFF3F4F6) : AegisColors.surface2, borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomLeft: Radius.circular(4), bottomRight: Radius.circular(20)), border: Border.all(color: AegisColors.border1.withValues(alpha: 0.2), width: 0.5)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(entry.text, style: AegisStyles.message),
                SizedBox(height: 6),
                Align(alignment: Alignment.bottomRight, child: Text(time, style: AegisStyles.timestamp.copyWith(color: AegisColors.textSecondary.withValues(alpha: 0.8)))),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _outgoing(ChatEntry entry, String time) {
    final isSending = entry.status == MessageStatus.sending;
    final isSent = entry.status == MessageStatus.sent || entry.status == MessageStatus.delivered;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.end, children: [
        Flexible(
          child: GestureDetector(
            onLongPress: () => _copyMessage(entry.text),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AegisColors.isLight ? const Color(0xFFDCFCE7) : const Color(0xFF064E3B),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(4)),
                border: Border.all(color: AegisColors.isLight ? const Color(0xFFA7F3D0).withValues(alpha: 0.5) : AegisColors.neonGreen.withValues(alpha: 0.15), width: 0.5),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
                Text(entry.text, style: AegisStyles.message.copyWith(color: AegisColors.isLight ? const Color(0xFF111827) : Colors.white)),
                SizedBox(height: 6),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(time, style: AegisStyles.timestamp.copyWith(color: AegisColors.isLight ? const Color(0xFF047857) : Colors.white.withValues(alpha: 0.6))),
                  SizedBox(width: 4),
                  if (isSending)
                    SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 1.5, color: AegisColors.isLight ? const Color(0xFF047857) : Colors.white60)),
                  if (isSent)
                    Icon(Icons.done_all_rounded, color: AegisColors.isLight ? const Color(0xFF10B981) : AegisColors.neonGreen, size: 12),
                ]),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _queued(ChatEntry entry, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.end, children: [
        Flexible(
          child: GestureDetector(
            onLongPress: () => _copyMessage(entry.text),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AegisColors.isLight ? AegisColors.warning.withValues(alpha: 0.08) : const Color(0xFF2D1F10), borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(4)), border: Border.all(color: AegisColors.warning.withValues(alpha: 0.3), width: 0.5)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
                Text(entry.text, style: AegisStyles.message),
                SizedBox(height: 6),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(time, style: AegisStyles.timestamp),
                  SizedBox(width: 4),
                  Icon(Icons.access_time_rounded, color: AegisColors.warning, size: 11),
                ]),
                SizedBox(height: 2),
                Text('Queued', style: TextStyle(color: AegisColors.warning, fontSize: 10, fontWeight: FontWeight.w700)),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _offlineBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AegisColors.isLight ? AegisColors.surface0 : const Color(0xFF1E1710), borderRadius: BorderRadius.circular(14), border: Border.all(color: AegisColors.warning.withValues(alpha: 0.25), width: 0.5)),
      child: Row(children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(color: AegisColors.warning.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.access_time_rounded, color: AegisColors.warning, size: 18)),
        SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text('Queued Message', style: TextStyle(color: AegisColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 13)),
          SizedBox(height: 2),
          Text('Will deliver when ${widget.nodeId} comes back online.', style: TextStyle(color: AegisColors.textSecondary, fontSize: 11)),
        ])),
      ]),
    );
  }

  Widget _input() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF08080E),
        border: Border(top: BorderSide(color: AegisColors.border1.withValues(alpha: 0.2), width: 0.5)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Expanded(
          child: Container(
            constraints: const BoxConstraints(minHeight: 46, maxHeight: 120),
            decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(20), border: Border.all(color: AegisColors.border1.withValues(alpha: 0.4), width: 0.5)),
            padding: const EdgeInsets.only(left: 14, right: 4),
            child: Row(children: [
              Expanded(child: TextField(
                controller: _messageController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(hintText: 'Type a message...', hintStyle: TextStyle(color: AegisColors.textMuted, fontSize: 15), border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 0)),
                onChanged: (_) => setState(() {}),
              )),
              GestureDetector(
                onTap: () => showModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (_) => _attachSheet()),
                child: Container(width: 36, height: 36, margin: const EdgeInsets.only(bottom: 6), decoration: BoxDecoration(color: AegisColors.border1.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.attach_file_rounded, color: AegisColors.textMuted, size: 18)),
              ),
            ]),
          ),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: _sendMessage,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 46, height: 46,
            decoration: BoxDecoration(
              gradient: _messageController.text.trim().isEmpty ? LinearGradient(colors: [AegisColors.textMuted, AegisColors.textDim]) : AegisColors.greenGradient,
              shape: BoxShape.circle,
              boxShadow: _messageController.text.trim().isEmpty ? null : [BoxShadow(color: AegisColors.neonGreen.withValues(alpha: 0.3), blurRadius: 12, spreadRadius: 1)],
            ),
            child: Icon(Icons.send_rounded, color: _messageController.text.trim().isEmpty ? AegisColors.textDim : AegisColors.textPrimary, size: 20),
          ),
        ),
      ]),
    );
  }

  Widget _attachSheet() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF141428), Color(0xFF0E0E1E)]), borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28))),
      child: SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Center(child: Container(width: 44, height: 5, decoration: BoxDecoration(color: AegisColors.textDim, borderRadius: BorderRadius.circular(3)))),
          SizedBox(height: 20),
          _sheetOpt(Icons.file_present_rounded, 'Share File', AegisColors.textDim, () { Navigator.of(context).pop(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File sharing coming soon'), duration: Duration(seconds: 1))); }),
          SizedBox(height: 4),
          _sheetDivider(),
          SizedBox(height: 4),
          _sheetOpt(Icons.mic_none_rounded, 'Voice Message', AegisColors.textDim, () { Navigator.of(context).pop(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voice messages coming soon'), duration: Duration(seconds: 1))); }),
        ]),
      ),
    );
  }

  Widget _sheetOpt(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(14),
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12), child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.2), width: 0.5)), child: Icon(icon, color: color, size: 20)),
        SizedBox(width: 14),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
      ])),
    );
  }

  Widget _sheetDivider() {
    return Container(margin: const EdgeInsets.symmetric(horizontal: 4), height: 0.5, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.transparent, AegisColors.border1.withValues(alpha: 0.3), Colors.transparent])));
  }
}