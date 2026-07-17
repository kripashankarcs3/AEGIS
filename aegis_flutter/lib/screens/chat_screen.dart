import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/aegis_colors.dart';
import '../constants/aegis_styles.dart';
import '../constants/aegis_animations.dart';
import '../providers/survivor_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/identity_provider.dart';
import '../models/survivor_node_model.dart';
import '../services/storage_service.dart';
import 'chat_conversation_screen.dart';
import 'broadcast_screen.dart';

final _sigIdRegex = RegExp(r'^SIG-[A-Za-z0-9]{8}$');

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  int _tab = 0;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final allSurvivors = ref.watch(survivorProvider);
    final myId = ref.watch(sigIdProvider);

    // Remove own SIG-ID so self-chat never appears
    final peers = Map<String, SurvivorNodeModel>.from(allSurvivors)..remove(myId);

    final filteredSurvivors = _searchQuery.isEmpty || _searchQuery == ' '
        ? peers
        : Map.fromEntries(peers.entries.where((e) =>
            e.value.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            e.value.message.toLowerCase().contains(_searchQuery.toLowerCase())));

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
                  if (_searchQuery.isNotEmpty) ...[
                    SizedBox(height: 8),
                    _searchBar(),
                  ],
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView(children: [
                      ..._buildPeerList(filteredSurvivors),
                      const SizedBox(height: 16),
                    ]),
                  ),
                ],
              ),
            ),
            Positioned(right: 20, bottom: 24, child: StaggeredFadeIn(index: 5, child: FloatingActionButton(backgroundColor: AegisColors.violet, elevation: 8, child: Icon(Icons.add_rounded, color: Colors.white, size: 28), onPressed: () => showModalBottomSheet(context: context, backgroundColor: Colors.transparent, isScrollControlled: true, builder: (_) => _sheet())))),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(12), border: Border.all(color: AegisColors.border1, width: 0.5)),
      child: TextField(
        autofocus: true,
        style: TextStyle(color: AegisColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search by SIG-ID or message...',
          hintStyle: TextStyle(color: AegisColors.textMuted, fontSize: 13),
          border: InputBorder.none,
          isDense: true,
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _searchQuery = ''),
            child: Icon(Icons.close, color: AegisColors.textMuted, size: 18),
          ),
        ),
        onChanged: (v) => setState(() => _searchQuery = v),
      ),
    );
  }

  Widget _header() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 3, height: 24, decoration: BoxDecoration(gradient: AegisColors.purpleGradient, borderRadius: BorderRadius.circular(2))),
        SizedBox(width: 12),
        Text('Messages', style: AegisStyles.h2),
      ]),
      Row(mainAxisSize: MainAxisSize.min, children: [
        _hdrIcon(Icons.search_rounded, () => setState(() => _searchQuery = _searchQuery.isNotEmpty ? '' : ' ')),
        SizedBox(width: 4),
        _hdrIcon(Icons.tune_rounded, () => _showFilterOptions()),
      ]),
    ]);
  }

  Widget _hdrIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(width: 36, height: 36, decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(10), border: Border.all(color: AegisColors.border1, width: 0.5)), child: Icon(icon, color: AegisColors.textPrimary, size: 18)),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        decoration: BoxDecoration(gradient: AegisColors.cardGradient, borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28))),
        child: SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Center(child: Container(width: 44, height: 5, decoration: BoxDecoration(color: AegisColors.textDim, borderRadius: BorderRadius.circular(3)))),
            SizedBox(height: 20),
            Text('Sort & Filter', style: TextStyle(color: AegisColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w700)),
            SizedBox(height: 16),
            _filterOption(Icons.access_time_rounded, 'Recent first', () { Navigator.of(context).pop(); }),
            _filterOption(Icons.person_rounded, 'By name', () { Navigator.of(context).pop(); }),
            _filterOption(Icons.online_prediction_rounded, 'Online only', () { Navigator.of(context).pop(); }),
          ]),
        ),
      ),
    );
  }

  Widget _filterOption(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(14),
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4), child: Row(children: [
        Icon(icon, color: AegisColors.violet, size: 20),
        SizedBox(width: 14),
        Text(label, style: TextStyle(color: AegisColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w500)),
      ])),
    );
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
        decoration: sel ? BoxDecoration(border: Border(bottom: BorderSide(color: AegisColors.violet, width: 2))) : null,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(color: sel ? AegisColors.textPrimary : AegisColors.textMuted, fontSize: 14, fontWeight: sel ? FontWeight.w700 : FontWeight.w500, letterSpacing: -0.2),
          child: Text(title),
        ),
      ),
    );
  }

  String _formatTime(int epochMs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(epochMs);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDate = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(msgDate).inDays;

    if (diff == 0) {
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $ampm';
    }
    if (diff == 1) return 'Yesterday';
    return '${dt.day}/${dt.month}';
  }

  List<Widget> _buildPeerList(Map<String, SurvivorNodeModel> survivors) {
    if (survivors.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.chat_bubble_outline_rounded, size: 48, color: AegisColors.textMuted),
                SizedBox(height: 16),
                Text('No conversations yet', style: TextStyle(color: AegisColors.textMuted, fontSize: 15, fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                Text('Tap + to start a new encrypted chat', style: TextStyle(color: AegisColors.textDim, fontSize: 13)),
              ],
            ),
          ),
        ),
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
      final isOnline = !node.isOffline && node.lastSeen > DateTime.now().millisecondsSinceEpoch - 120000;

      int unread = 0;
      try {
        unread = ref.read(chatProvider(node.id).notifier).unreadCount;
      } catch (_) {}

      tiles.add(_tile(
        color,
        node.id,
        time,
        subtitle,
        unread: unread,
        urgent: isNeedHelp,
        dot: isOnline,
        badgeText: badgeText,
        badgeColor: badgeColor,
      ));
      if (i < entries.length - 1) {
        tiles.add(_divider());
      }
    }
    return tiles;
  }

  Widget _tile(Color avatarColor, String nodeId, String time, String subtitle, {int unread = 0, bool urgent = false, bool dot = false, String? badgeText, Color? badgeColor}) {
    return InkWell(
      onTap: () {
        ref.read(chatProvider(nodeId).notifier).clearUnread();
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, a, __) => ChatConversationScreen(nodeId: nodeId),
          transitionsBuilder: (_, a, __, child) => SlideTransition(
            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
            child: child,
          ),
        ));
      },
      onLongPress: () => _showChatOptions(nodeId),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(gradient: LinearGradient(colors: [avatarColor.withValues(alpha: 0.2), avatarColor.withValues(alpha: 0.05)]), shape: BoxShape.circle, border: Border.all(color: avatarColor.withValues(alpha: urgent ? 0.5 : 0.2), width: urgent ? 1.5 : 1), boxShadow: urgent ? [BoxShadow(color: avatarColor.withValues(alpha: 0.3), blurRadius: 12, spreadRadius: 2)] : null),
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
                        color: badgeColor!.withValues(alpha: AegisColors.isLight ? 0.12 : 0.2),
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
                Expanded(child: Text(subtitle, style: TextStyle(fontSize: 13, color: AegisColors.textSecondary.withValues(alpha: 0.8), fontWeight: urgent ? FontWeight.w600 : FontWeight.w400), maxLines: 1, overflow: TextOverflow.ellipsis)),
                if (unread > 0)
                  Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(gradient: urgent ? AegisColors.sosGradient : AegisColors.purpleGradient, shape: BoxShape.circle),
                    child: Center(child: Text('$unread', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800))),
                  ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _divider() {
    return Container(margin: const EdgeInsets.only(left: 62), height: 0.5, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.transparent, AegisColors.border1.withValues(alpha: 0.3), Colors.transparent])));
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
          Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withValues(alpha: 0.2), width: 0.5)), child: Icon(icon, color: color, size: 20)),
          SizedBox(width: 14),
          Text(label, style: TextStyle(color: AegisColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Widget _sheetDivider() {
    return Container(margin: const EdgeInsets.symmetric(horizontal: 4), height: 0.5, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.transparent, AegisColors.border1.withValues(alpha: 0.3), Colors.transparent])));
  }

  void _showChatOptions(String nodeId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        decoration: BoxDecoration(gradient: AegisColors.cardGradient, borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28))),
        child: SafeArea(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Center(child: Container(width: 44, height: 5, decoration: BoxDecoration(color: AegisColors.textDim, borderRadius: BorderRadius.circular(3)))),
            SizedBox(height: 20),
            _sheetOpt(Icons.delete_outline_rounded, 'Delete Chat', AegisColors.sosRed, () async {
              Navigator.of(context).pop();
              ref.read(survivorProvider.notifier).removeSurvivor(nodeId);
              await StorageService.deleteChatHistory(nodeId);
            }),
            SizedBox(height: 4),
            _sheetDivider(),
            SizedBox(height: 4),
            _sheetOpt(Icons.cleaning_services_outlined, 'Clear Messages', AegisColors.textPrimary, () async {
              Navigator.of(context).pop();
              await StorageService.clearChatHistory(nodeId);
            }),
          ]),
        ),
      ),
    );
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
                  hintText: 'SIG-XXXXXXXX',
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
                  setDialogState(() => errorText = 'Must be SIG-XXXXXXXX format');
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