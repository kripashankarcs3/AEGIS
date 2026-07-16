import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE5E7EB);
  static const _blue = Color(0xFF2563EB);

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
        title: const Text('Help & Support',
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
            _search(),
            const SizedBox(height: 16),
            _section('QUICK ACTIONS'),
            const SizedBox(height: 10),
            _card([
              _item(Icons.chat_bubble_outline_rounded, 'Contact Support',
                  'Open a support chat or leave a message'),
              const Divider(height: 1, thickness: 1, color: _line),
              _item(Icons.report_problem_outlined, 'Report an Issue',
                  'Share a bug or unexpected behavior'),
              const Divider(height: 1, thickness: 1, color: _line),
              _item(Icons.local_police_outlined, 'Emergency Guide',
                  'What to do when SOS is triggered'),
            ]),
            const SizedBox(height: 16),
            _section('FREQUENTLY ASKED'),
            const SizedBox(height: 10),
            _card([
              _item(Icons.question_mark_rounded, 'How does mesh work?',
                  'Nodes talk directly to nearby devices first'),
              const Divider(height: 1, thickness: 1, color: _line),
              _item(Icons.lock_outline_rounded, 'Is my data secure?',
                  'Messages are routed with local-first rules'),
              const Divider(height: 1, thickness: 1, color: _line),
              _item(Icons.battery_full_rounded, 'Will it save battery?',
                  'Yes, especially with battery saver enabled'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _search() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search help topics',
        prefixIcon: const Icon(Icons.search_rounded),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: _line)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _line)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: _blue)),
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

  Widget _card(List<Widget> children) {
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

  Widget _item(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: _blue, size: 17),
      ),
      title: Text(title,
          style: const TextStyle(
              color: _ink, fontSize: 13.5, fontWeight: FontWeight.w800)),
      subtitle:
          Text(subtitle, style: const TextStyle(color: _muted, fontSize: 11.5)),
      trailing: const Icon(Icons.chevron_right_rounded, color: _muted),
    );
  }
}
