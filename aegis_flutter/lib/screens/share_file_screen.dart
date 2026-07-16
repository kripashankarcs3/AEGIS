import 'package:flutter/material.dart';

class ShareFileScreen extends StatelessWidget {
  const ShareFileScreen({super.key});

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
        title: const Text('Share File',
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
            _hero(),
            const SizedBox(height: 16),
            _section('RECENT FILES'),
            const SizedBox(height: 10),
            _card(),
            const SizedBox(height: 14),
            _shareButton(),
          ],
        ),
      ),
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _line),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child:
                const Icon(Icons.file_present_rounded, color: _blue, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Send a file',
                    style: TextStyle(
                        color: _ink,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: 4),
                Text('Pick a document or photo and route it through the mesh.',
                    style:
                        TextStyle(color: _muted, fontSize: 12, height: 1.35)),
              ],
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

  Widget _card() {
    final files = [
      ('Emergency kit checklist.pdf', '2.4 MB'),
      ('Route map.png', '1.1 MB'),
      ('Medical notes.txt', '18 KB'),
    ];

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
      child: Column(
        children: List.generate(files.length, (index) {
          final file = files[index];
          return Column(
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                leading: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.description_rounded,
                      color: _blue, size: 17),
                ),
                title: Text(file.$1,
                    style: const TextStyle(
                        color: _ink,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800)),
                subtitle: Text(file.$2,
                    style: const TextStyle(color: _muted, fontSize: 11.5)),
                trailing:
                    const Icon(Icons.chevron_right_rounded, color: _muted),
              ),
              if (index != files.length - 1)
                const Divider(height: 1, thickness: 1, color: _line),
            ],
          );
        }),
      ),
    );
  }

  Widget _shareButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _blue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: () {},
        child: const Text('Share Selected File',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
