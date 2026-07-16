import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/aegis_colors.dart';
import '../constants/aegis_styles.dart';
import '../providers/chat_provider.dart';
import 'share_file_screen.dart';
import 'voice_message_screen.dart';

class ChatConversationScreen extends ConsumerStatefulWidget {
  final String nodeId;
  const ChatConversationScreen({super.key, required this.nodeId});

  @override
  ConsumerState<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends ConsumerState<ChatConversationScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    ref.read(chatProvider(widget.nodeId).notifier).send(text);
    _messageController.clear();
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final bool offline = widget.nodeId == 'SIG-4D2F';
    final messages = ref.watch(chatProvider(widget.nodeId));
    final showMock = messages.isEmpty;

    return Scaffold(
      backgroundColor: AegisColors.background,
      appBar: AppBar(
        backgroundColor: AegisColors.surface0.withOpacity(0.95),
        elevation: 0,
        leading: Container(margin: const EdgeInsets.all(4), decoration: BoxDecoration(color: AegisColors.surface2, shape: BoxShape.circle, border: Border.all(color: AegisColors.border1, width: 0.5)),
          child: IconButton(icon: Icon(Icons.arrow_back, color: AegisColors.textPrimary, size: 20), onPressed: () => Navigator.of(context).pop())),
        title: Row(children: [
          Container(width: 36, height: 36, decoration: BoxDecoration(gradient: offline ? LinearGradient(colors: [AegisColors.textMuted, AegisColors.textDim]) : AegisColors.greenGradient, shape: BoxShape.circle, boxShadow: offline ? null : [BoxShadow(color: AegisColors.neonGreen.withOpacity(0.3), blurRadius: 8, spreadRadius: 1)]), child: Center(child: Icon(Icons.person_rounded, color: Colors.white, size: 18))),
          SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.nodeId, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AegisColors.textPrimary, letterSpacing: -0.2)),
            SizedBox(height: 2),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 6, height: 6, decoration: BoxDecoration(color: offline ? AegisColors.textMuted : AegisColors.neonGreen, shape: BoxShape.circle)),
              SizedBox(width: 6),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Text(offline ? 'Offline' : 'Online', style: TextStyle(fontSize: 11, color: offline ? AegisColors.textSecondary : AegisColors.neonGreen, fontWeight: FontWeight.w700)),
                if (!offline)
                  Text('  •  2 hops away', style: TextStyle(fontSize: 11, color: AegisColors.textSecondary, fontWeight: FontWeight.w500)),
              ]),
            ]),
          ]),
        ]),
        actions: [
          Container(margin: const EdgeInsets.all(4), decoration: BoxDecoration(color: AegisColors.surface2, shape: BoxShape.circle, border: Border.all(color: AegisColors.border1, width: 0.5)),
            child: IconButton(icon: Icon(Icons.more_vert, color: AegisColors.textPrimary, size: 20), onPressed: () {})),
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: ListView(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), children: showMock
              ? (offline
                  ? [
                      _incoming('Hello! Are you safe?', '10:18 AM'),
                      _outgoing("Yes, I'm safe here.", '10:19 AM', green: false),
                      _incoming('We need medical supplies.', '10:20 AM'),
                      _queued('I can help. I have some basic medicines.', '10:21 AM'),
                    ]
                  : [
                      _incoming('Are you safe?', '10:21 AM'),
                      _outgoing('Yes, we are safe.', '10:22 AM'),
                      _hopPath('SIG-7F3A → SIG-B2C1 → SIG-8AF3'),
                      _incoming('Do you have any medical supplies?', '10:23 AM'),
                      _outgoing('Yes, we have some basic medications.', '10:24 AM'),
                      _hopPath('SIG-7F3A → SIG-B2C1 → SIG-8AF3'),
                      _warning('Can you send bandages?', '10:25 AM'),
                      _queueInd(),
                    ])
              : messages.map((entry) {
                  final time = _formatTime(entry.timestamp);
                  if (entry.isMine) {
                    if (entry.status == MessageStatus.queued) {
                      return _queued(entry.text, time);
                    }
                    return _outgoing(entry.text, time);
                  }
                  return _incoming(entry.text, time);
                }).toList()),
          ),
          if (offline) _offlineBanner(),
          _input(),
        ]),
      ),
    );
  }

  Widget _incoming(String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Container(width: 28, height: 28, decoration: BoxDecoration(gradient: LinearGradient(colors: [AegisColors.violet.withOpacity(0.3), AegisColors.violet.withOpacity(0.1)]), shape: BoxShape.circle), child: Center(child: Icon(Icons.person_rounded, size: 14, color: AegisColors.violet))),
        SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AegisColors.isLight ? const Color(0xFFF3F4F6) : AegisColors.surface2, borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomLeft: Radius.circular(4), bottomRight: Radius.circular(20)), border: Border.all(color: AegisColors.border1.withOpacity(0.2), width: 0.5)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(text, style: AegisStyles.message),
              SizedBox(height: 6),
              Align(alignment: Alignment.bottomRight, child: Text(time, style: AegisStyles.timestamp.copyWith(color: AegisColors.textSecondary.withOpacity(0.8)))),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _outgoing(String text, String time, {bool green = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.end, children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AegisColors.isLight ? const Color(0xFFDCFCE7) : const Color(0xFF064E3B), borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(4)), border: Border.all(color: AegisColors.isLight ? const Color(0xFFA7F3D0).withOpacity(0.5) : AegisColors.neonGreen.withOpacity(0.15), width: 0.5)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
              Text(text, style: AegisStyles.message.copyWith(color: AegisColors.isLight ? const Color(0xFF111827) : Colors.white)),
              SizedBox(height: 6),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Text(time, style: AegisStyles.timestamp.copyWith(color: AegisColors.isLight ? const Color(0xFF047857) : Colors.white.withOpacity(0.6))),
                SizedBox(width: 4),
                Icon(Icons.done_all_rounded, color: AegisColors.isLight ? const Color(0xFF10B981) : AegisColors.neonGreen, size: 12),
              ]),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _queued(String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.end, children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AegisColors.isLight ? AegisColors.warning.withOpacity(0.08) : const Color(0xFF2D1F10), borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(4)), border: Border.all(color: AegisColors.warning.withOpacity(0.3), width: 0.5)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
              Text(text, style: AegisStyles.message),
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
      ]),
    );
  }

  Widget _offlineBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AegisColors.isLight ? AegisColors.surface0 : const Color(0xFF1E1710), borderRadius: BorderRadius.circular(14), border: Border.all(color: AegisColors.warning.withOpacity(0.25), width: 0.5)),
      child: Row(children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(color: AegisColors.warning.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.access_time_rounded, color: AegisColors.warning, size: 18)),
        SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text('Queued Message', style: TextStyle(color: AegisColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 13)),
          SizedBox(height: 2),
          Text('Will deliver when ${widget.nodeId} comes back online.', style: TextStyle(color: AegisColors.textSecondary, fontSize: 11)),
        ])),
      ]),
    );
  }

  Widget _warning(String text, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Container(width: 28, height: 28, decoration: BoxDecoration(color: AegisColors.warning.withOpacity(0.15), shape: BoxShape.circle), child: Center(child: Icon(Icons.warning_amber_rounded, size: 14, color: AegisColors.warning))),
        SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AegisColors.isLight ? AegisColors.warning.withOpacity(0.12) : const Color(0xFF451A03).withOpacity(0.6), borderRadius: const BorderRadius.only(topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)), border: Border.all(color: AegisColors.warning.withOpacity(0.25), width: 0.5)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(text, style: AegisStyles.message),
              SizedBox(height: 6),
              Align(alignment: Alignment.bottomRight, child: Text(time, style: AegisStyles.timestamp)),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _hopPath(String path) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(color: AegisColors.neonGreen.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: AegisColors.neonGreen.withOpacity(0.12), width: 0.5)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.check_circle_outline_rounded, color: AegisColors.neonGreen.withOpacity(0.7), size: 12),
            SizedBox(width: 6),
            Text('via 2 hops', style: TextStyle(color: AegisColors.neonGreen.withOpacity(0.8), fontSize: 10, fontWeight: FontWeight.w700)),
            SizedBox(width: 8),
            Text(path, style: TextStyle(color: AegisColors.textMuted.withOpacity(0.6), fontSize: 9, fontWeight: FontWeight.w500)),
          ]),
        ),
      ]),
    );
  }

  Widget _queueInd() {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 10),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: AegisColors.warning.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.hourglass_empty_rounded, color: AegisColors.warning, size: 14),
            SizedBox(width: 6),
            Text('Queued', style: TextStyle(color: AegisColors.warning, fontSize: 11, fontWeight: FontWeight.w700)),
          ]),
        ),
      ]),
    );
  }

  Widget _input() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF08080E),
        border: Border(top: BorderSide(color: AegisColors.border1.withOpacity(0.2), width: 0.5)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Expanded(
          child: Container(
            constraints: const BoxConstraints(minHeight: 46, maxHeight: 120),
            decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(20), border: Border.all(color: AegisColors.border1.withOpacity(0.4), width: 0.5)),
            padding: const EdgeInsets.only(left: 14, right: 4),
            child: Row(children: [
              Expanded(child: TextField(
                controller: _messageController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(hintText: 'Type a message...', hintStyle: TextStyle(color: AegisColors.textMuted, fontSize: 15), border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 0)),
              )),
              GestureDetector(
                onTap: () => showModalBottomSheet(context: context, backgroundColor: Colors.transparent, builder: (_) => _attachSheet()),
                child: Container(width: 36, height: 36, margin: const EdgeInsets.only(bottom: 6), decoration: BoxDecoration(color: AegisColors.border1.withOpacity(0.3), borderRadius: BorderRadius.circular(10)), child: Icon(Icons.attach_file_rounded, color: AegisColors.textMuted, size: 18)),
              ),
            ]),
          ),
        ),
        SizedBox(width: 10),
        GestureDetector(
          onTap: _sendMessage,
          child: Container(
            width: 46, height: 46,
            decoration: BoxDecoration(gradient: AegisColors.greenGradient, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AegisColors.neonGreen.withOpacity(0.3), blurRadius: 12, spreadRadius: 1)]),
            child: Icon(Icons.send_rounded, color: AegisColors.textPrimary, size: 20),
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
          _sheetOpt(Icons.file_present_rounded, 'Share File', AegisColors.violet, () { Navigator.of(context).pop(); Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ShareFileScreen())); }),
          SizedBox(height: 4),
          _sheetDivider(),
          SizedBox(height: 4),
          _sheetOpt(Icons.mic_none_rounded, 'Voice Message', AegisColors.violet, () { Navigator.of(context).pop(); Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VoiceMessageScreen())); }),
        ]),
      ),
    );
  }

  Widget _sheetOpt(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(14),
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12), child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2), width: 0.5)), child: Icon(icon, color: color, size: 20)),
        SizedBox(width: 14),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
      ])),
    );
  }

  Widget _sheetDivider() {
    return Container(margin: const EdgeInsets.symmetric(horizontal: 4), height: 0.5, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.transparent, AegisColors.border1.withOpacity(0.3), Colors.transparent])));
  }
}
