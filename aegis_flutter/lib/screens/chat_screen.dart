import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import '../constants/aegis_styles.dart';
import '../constants/aegis_animations.dart';
import 'chat_conversation_screen.dart';
import 'broadcast_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
                      _tile(AegisColors.violet, 'SIG-8AF3', '10:24 AM', 'All good here. We have supplies.', unread: 2),
                      _divider(),
                      _tile(AegisColors.sosRed, 'SIG-4D2F', '10:18 AM', 'Need medical assistance.', unread: 1, urgent: true),
                      _divider(),
                      _tile(AegisColors.neonGreen, 'SIG-1A9D', '9:56 AM', 'How many people in your group?'),
                      _divider(),
                      _tile(AegisColors.electricBlue, 'SIG-B2C1', '9:41 AM', 'Water available. 2 bottles left.', dot: true),
                      _divider(),
                      _tile(AegisColors.violet, 'SIG-3C7E', '9:32 AM', 'Heading north. Roads blocked.'),
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
    return Container(width: 36, height: 36, decoration: BoxDecoration(color: AegisColors.surface2, borderRadius: BorderRadius.circular(10), border: Border.all(color: AegisColors.border1, width: 0.5)), child: Icon(icon, color: Colors.white, size: 18));
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
        decoration: BoxDecoration(border: sel ? Border(bottom: BorderSide(color: AegisColors.electricBlue, width: 2.5)) : null),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(color: sel ? Colors.white : AegisColors.textMuted, fontSize: 14, fontWeight: sel ? FontWeight.w700 : FontWeight.w500, letterSpacing: -0.2),
          child: Text(title),
        ),
      ),
    );
  }

  Widget _tile(Color avatarColor, String nodeId, String time, String subtitle, {int unread = 0, bool urgent = false, bool dot = false}) {
    return InkWell(
      onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, a, __) => ChatConversationScreen(nodeId: nodeId), transitionsBuilder: (_, a, __, child) => SlideTransition(position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)), child: child))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [avatarColor.withOpacity(0.2), avatarColor.withOpacity(0.05)]), shape: BoxShape.circle, border: Border.all(color: avatarColor.withOpacity(urgent ? 0.5 : 0.2), width: urgent ? 1.5 : 1), boxShadow: urgent ? [BoxShadow(color: avatarColor.withOpacity(0.3), blurRadius: 12, spreadRadius: 2)] : null),
            child: Icon(Icons.person_rounded, color: avatarColor, size: 24),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(nodeId, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.2)),
                Text(time, style: TextStyle(fontSize: 11, color: AegisColors.textMuted, fontWeight: FontWeight.w500)),
              ]),
              SizedBox(height: 6),
              Row(children: [
                if (dot) ...[PulseDot(color: AegisColors.neonGreen, size: 7), SizedBox(width: 8)],
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
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF141428), Color(0xFF0E0E1E)]), borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28))),
      child: SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Center(child: Container(width: 44, height: 5, decoration: BoxDecoration(color: AegisColors.textDim, borderRadius: BorderRadius.circular(3)))),
          SizedBox(height: 20),
          _sheetOpt(Icons.chat_bubble_outline_rounded, 'New Chat', AegisColors.violet, () => Navigator.of(context).pop()),
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
          Text(label, style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Widget _sheetDivider() {
    return Container(margin: const EdgeInsets.symmetric(horizontal: 4), height: 0.5, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.transparent, AegisColors.border1.withOpacity(0.3), Colors.transparent])));
  }
}
