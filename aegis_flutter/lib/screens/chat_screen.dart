import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/aegis_colors.dart';
import '../constants/aegis_styles.dart';
import '../constants/aegis_animations.dart';
import '../providers/survivor_provider.dart';
import '../models/survivor_node_model.dart';
import 'chat_conversation_screen.dart';
import 'broadcast_screen.dart';

final _sigIdRegex = RegExp(r'^SIG-[A-Za-z0-9]{4}$');

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StaggeredFadeIn(index: 0, child: _header()),
                  SizedBox(height: 6),
                  StaggeredFadeIn(index: 1, child: _tabs()),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView(children: [
                      ..._buildPeerList(ref.watch(survivorProvider)),
                      const SizedBox(height: 16),
                      _buildTipBanner(),
                    ]),
                  ),
                ],
              ),
            ),
            Positioned(right: 20, bottom: 100, child: StaggeredFadeIn(index: 5, child: FloatingActionButton(backgroundColor: AegisColors.violet, elevation: 8, child: Icon(Icons.add_rounded, color: Colors.white, size: 28), onPressed: () => showModalBottomSheet(context: context, backgroundColor: Colors.transparent, isScrollControlled: true, builder: (_) => _sheet())))),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 3, height: 24, decoration: BoxDecoration(gradient: AegisColors.purpleGradient, borderRadius: BorderRadius.circular(2))),
        SizedBox(width: 12),
        Text('ENCRYPTED CHAT', style: AegisStyles.h2),
      ]),
      Row(mainAxisSize: MainAxisSize.min, children: [
        _hdrIcon(Icons.search_rounded),
        SizedBox(width: 4),
        _hdrIcon(Icons.tune_rounded),
      ]),
    ]);
  }

  Widget _hdrIcon(IconData icon) {
    return Container(width: 36, height: 36, decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(10), border: Border.all(color: AegisColors.border1, width: 0.5)), child: Icon(icon, color: AegisColors.textPrimary, size: 18));
  }

  Widget _tabs() {
    return Row(children: [
      _tabItem(0, 'All Chats'),
      _tabItem(1, 'Nearby'),
      _tabItem(2, 'Groups'),
    ]);
  }

  Widget _tabItem(int idx, String title) {
    final sel = _tab == idx;
    return GestureDetector(
      onTap: () => setState(() => _tab = idx),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(right: 28),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: null,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(color: sel ? AegisColors.textPrimary : AegisColors.textMuted, fontSize: 14, fontWeight: sel ? FontWeight.w700 : FontWeight.w500, letterSpacing: -0.2),
          child: Text(title),
        ),
      ),
    );
  }

  bool _showTip = true;

  String _formatTime(int epochMs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(epochMs);
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
  }

  List<Widget> _buildPeerList(Map<String, SurvivorNodeModel> survivors) {
    if (survivors.isEmpty) {
      return [
        _tile(AegisColors.violet, 'SIG-8AF3', '10:24 AM', 'All good here. We have supplies.', unread: 2, badgeText: 'SAFE', badgeColor: AegisColors.neonGreen, dot: true),
        _divider(),
        _tile(AegisColors.sosRed, 'SIG-4D2F', '10:18 AM', 'Need medical assistance.', unread: 1, urgent: true, badgeText: 'NEED HELP', badgeColor: AegisColors.sosRed),
        _divider(),
        _tile(AegisColors.neonGreen, 'SIG-1A9D', '9:56 AM', 'How many people in your group?', dot: true),
        _divider(),
        _tile(AegisColors.electricBlue, 'SIG-B2C1', '9:41 AM', 'Water available. 2 bottles left.', dot: true),
        _divider(),
        _tile(AegisColors.violet, 'SIG-3C7E', '9:32 AM', 'Heading north. Roads blocked.', dot: true),
      ];
    }

    final tiles = <Widget>[];
    final entries = survivors.entries.toList();
    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final node = entry.value;
      final isNeedHelp = node.status == 'need_help';
      final hasResources = node.status == 'have_resources';
      final color = isNeedHelp
          ? AegisColors.sosRed
          : hasResources
              ? const Color(0xFFF59E0B)
              : AegisColors.neonGreen;
      final badgeText = isNeedHelp
          ? 'NEED HELP'
          : hasResources
              ? 'HAS RESOURCES'
              : 'SAFE';
      final badgeColor = isNeedHelp
          ? AegisColors.sosRed
          : hasResources
              ? const Color(0xFFF59E0B)
              : AegisColors.neonGreen;
      final subtitle = node.message.isNotEmpty
          ? node.message
          : 'Status: ${node.status}';
      final time = _formatTime(node.lastSeen);
      tiles.add(_tile(
        color,
        node.id,
        time,
        subtitle,
        unread: 0,
        urgent: isNeedHelp,
        dot: !isNeedHelp,
        badgeText: badgeText,
        badgeColor: badgeColor,
      ));
      if (i < entries.length - 1) {
        tiles.add(_divider());
      }
    }
    return tiles;
  }

  Widget _buildTipBanner() {
    if (!_showTip) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AegisColors.isLight ? const Color(0xFFE8F5E9) : const Color(0xFF1B2A1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AegisColors.isLight ? const Color(0xFFC8E6C9) : AegisColors.neonGreen.withOpacity(0.15),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.security_outlined, color: AegisColors.isLight ? const Color(0xFF2E7D32) : AegisColors.neonGreen, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tip: Long press on a chat for more options',
              style: TextStyle(
                color: AegisColors.isLight ? const Color(0xFF2E7D32) : AegisColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro Display',
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _showTip = false),
            child: Icon(Icons.close_rounded, color: AegisColors.isLight ? const Color(0xFF2E7D32).withOpacity(0.6) : AegisColors.textMuted, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _tile(Color avatarColor, String nodeId, String time, String subtitle, {int unread = 0, bool urgent = false, bool dot = false, String? badgeText, Color? badgeColor}) {
    return InkWell(
      onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, a, __) => ChatConversationScreen(nodeId: nodeId), transitionsBuilder: (_, a, __, child) => SlideTransition(position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)), child: child))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(gradient: LinearGradient(colors: [avatarColor.withOpacity(0.2), avatarColor.withOpacity(0.05)]), shape: BoxShape.circle, border: Border.all(color: avatarColor.withOpacity(urgent ? 0.5 : 0.2), width: urgent ? 1.5 : 1), boxShadow: urgent ? [BoxShadow(color: avatarColor.withOpacity(0.3), blurRadius: 12, spreadRadius: 2)] : null),
                child: Icon(Icons.person_rounded, color: avatarColor, size: 24),
              ),
              if (dot)
                Positioned(
                  bottom: -1, right: -1,
                  child: Container(
                    width: 12, height: 12,
                    decoration: BoxDecoration(
                      color: AegisColors.neonGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: AegisColors.isLight ? Colors.white : const Color(0xFF08080E), width: 2),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(nodeId, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AegisColors.textPrimary, letterSpacing: -0.2)),
                  if (badgeText != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeColor!.withOpacity(AegisColors.isLight ? 0.12 : 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(color: badgeColor, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.2),
                      ),
                    ),
                  ],
                ]),
                Text(time, style: TextStyle(fontSize: 11, color: AegisColors.textMuted, fontWeight: FontWeight.w500)),
              ]),
              SizedBox(height: 6),
              Row(children: [
                Expanded(child: Text(subtitle, style: TextStyle(fontSize: 13, color: AegisColors.textSecondary.withOpacity(0.8), fontWeight: urgent ? FontWeight.w600 : FontWeight.w400), maxLines: 1, overflow: TextOverflow.ellipsis)),
                if (unread > 0)
                  Container(width: 24, height: 24, decoration: BoxDecoration(gradient: urgent ? AegisColors.sosGradient : AegisColors.purpleGradient, shape: BoxShape.circle), child: Center(child: Text('$unread', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)))),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _divider() {
    return Container(margin: const EdgeInsets.only(left: 62), height: 0.5, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.transparent, AegisColors.border1.withOpacity(0.3), Colors.transparent])));
  }

  Widget _sheet() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(gradient: AegisColors.cardGradient, borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28))),
      child: SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Center(child: Container(width: 44, height: 5, decoration: BoxDecoration(color: AegisColors.textDim, borderRadius: BorderRadius.circular(3)))),
          SizedBox(height: 20),
          _sheetOpt(Icons.chat_bubble_outline_rounded, 'New Chat', AegisColors.violet, () { Navigator.of(context).pop(); _showNewChatDialog(); }),
          SizedBox(height: 4),
          _sheetDivider(),
          SizedBox(height: 4),
          _sheetOpt(Icons.podcasts_rounded, 'Broadcast Message', AegisColors.violet, () { Navigator.of(context).pop(); Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BroadcastScreen())); }),
        ]),
      ),
    );
  }

  Widget _sheetOpt(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.2), width: 0.5)), child: Icon(icon, color: color, size: 20)),
          SizedBox(width: 14),
          Text(label, style: TextStyle(color: AegisColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Widget _sheetDivider() {
    return Container(margin: const EdgeInsets.symmetric(horizontal: 4), height: 0.5, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.transparent, AegisColors.border1.withOpacity(0.3), Colors.transparent])));
  }

  void _showNewChatDialog() {
    final controller = TextEditingController();
    String? errorText;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AegisColors.surface1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('New Chat', style: TextStyle(color: AegisColors.textPrimary, fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter the SIG-ID of the peer you want to chat with.', style: TextStyle(color: AegisColors.textSecondary, fontSize: 13)),
              SizedBox(height: 16),
              TextField(
                controller: controller,
                style: TextStyle(color: AegisColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'SIG-XXXX',
                  hintStyle: TextStyle(color: AegisColors.textMuted),
                  errorText: errorText,
                  filled: true,
                  fillColor: AegisColors.surface2,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel', style: TextStyle(color: AegisColors.textMuted)),
            ),
            TextButton(
              onPressed: () {
                final sigId = controller.text.trim().toUpperCase();
                if (!_sigIdRegex.hasMatch(sigId)) {
                  setDialogState(() => errorText = 'Must be SIG-XXXX format');
                  return;
                }
                Navigator.of(ctx).pop();
                Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, a, __) => ChatConversationScreen(nodeId: sigId),
                  transitionsBuilder: (_, a, __, child) => SlideTransition(
                    position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
                    child: child,
                  ),
                ));
              },
              child: Text('Start Chat', style: TextStyle(color: AegisColors.violet, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
