import 'package:flutter/material.dart';

class BroadcastScreen extends StatelessWidget {
  const BroadcastScreen({super.key});

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE5E7EB);
  static const _red = Color(0xFFFF3B30);
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
        title: const Text('Broadcast',
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
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 96),
          children: [
            _hero(),
            const SizedBox(height: 16),
            _formCard(),
            const SizedBox(height: 14),
            _broadcastButton(),
          ],
        ),
      ),
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
                color: Color(0xFFFFE4E6), shape: BoxShape.circle),
            child: const Icon(Icons.campaign_rounded, color: _red, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Broadcast Alert',
                    style: TextStyle(
                        color: _ink,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: 4),
                Text(
                    'Send an alert to nearby nodes with location and request details.',
                    style:
                        TextStyle(color: _muted, fontSize: 12, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _formCard() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          _field('Title', 'Medical emergency'),
          const SizedBox(height: 12),
          _field('Details', 'Need water and a first-aid kit', maxLines: 3),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _chip('Nearby nodes', true)),
              const SizedBox(width: 10),
              Expanded(child: _chip('Entire mesh', false)),
            ],
          ),
          const SizedBox(height: 12),
          _chipRow(),
        ],
      ),
    );
  }

  Widget _field(String label, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: _muted,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.4)),
        const SizedBox(height: 6),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: _line)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _line)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _blue)),
          ),
        ),
      ],
    );
  }

  Widget _chip(String label, bool selected) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: selected ? const Color(0xFFBFDBFE) : _line),
      ),
      child: Center(
        child: Text(label,
            style: TextStyle(
                color: selected ? _blue : _muted,
                fontSize: 12,
                fontWeight: FontWeight.w800)),
      ),
    );
  }

  Widget _chipRow() {
    return Row(
      children: [
        _smallChip('Location'),
        const SizedBox(width: 8),
        _smallChip('Urgent'),
        const SizedBox(width: 8),
        _smallChip('Safe route'),
      ],
    );
  }

  Widget _smallChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _line),
      ),
      child: Text(label,
          style: const TextStyle(
              color: _muted, fontSize: 11.5, fontWeight: FontWeight.w700)),
    );
  }

  Widget _broadcastButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: _red,
          foregroundColor: Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: () {},
        icon: const Icon(Icons.notifications_active_rounded, size: 18),
        label: const Text('Broadcast Message',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
