import 'package:flutter/material.dart';

class VoiceMessageScreen extends StatelessWidget {
  const VoiceMessageScreen({super.key});

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
        title: const Text('Voice Message',
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
            _waveCard(),
            const SizedBox(height: 14),
            _recordButton(),
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
            child: const Icon(Icons.mic_rounded, color: _blue, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Record a message',
                    style: TextStyle(
                        color: _ink,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: 4),
                Text('Share your voice when typing is not practical.',
                    style:
                        TextStyle(color: _muted, fontSize: 12, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _waveCard() {
    return Container(
      padding: const EdgeInsets.all(18),
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
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF8FAFC),
              border: Border.all(color: _line),
            ),
            child: const Center(
              child: Icon(Icons.graphic_eq_rounded, color: _blue, size: 44),
            ),
          ),
          const SizedBox(height: 18),
          const Text('Tap the mic to start recording',
              style: TextStyle(
                  color: _ink, fontSize: 13.5, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('The message will be sent through nearby nodes.',
              style: TextStyle(color: _muted, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _recordButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: _blue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: () {},
        icon: const Icon(Icons.mic_rounded, size: 18),
        label: const Text('Record Voice Message',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
