import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int _selected = 0;

  static const _ink = Color(0xFF111827);
  static const _muted = Color(0xFF6B7280);
  static const _line = Color(0xFFE5E7EB);
  static const _blue = Color(0xFF2563EB);

  final _languages = const [
    ('English', 'United States'),
    ('Hindi', 'India'),
    ('Español', 'España'),
    ('Français', 'France'),
  ];

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
        title: const Text('Language',
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
            _section('CHOOSE LANGUAGE'),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _line),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x10000000),
                      blurRadius: 14,
                      offset: Offset(0, 4))
                ],
              ),
              child: Column(
                children: List.generate(_languages.length, (index) {
                  final selected = _selected == index;
                  final language = _languages[index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () => setState(() => _selected = index),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFFEFF6FF)
                                      : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(11),
                                  border: Border.all(
                                      color: selected
                                          ? const Color(0xFFBFDBFE)
                                          : _line),
                                ),
                                child: Icon(Icons.language_rounded,
                                    color: selected ? _blue : _muted, size: 17),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(language.$1,
                                        style: const TextStyle(
                                            color: _ink,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800)),
                                    const SizedBox(height: 3),
                                    Text(language.$2,
                                        style: const TextStyle(
                                            color: _muted, fontSize: 11.5)),
                                  ],
                                ),
                              ),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: selected ? _blue : Colors.transparent,
                                  border: Border.all(
                                      color: selected ? _blue : _line),
                                ),
                                child: selected
                                    ? const Icon(Icons.check,
                                        color: Colors.white, size: 12)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (index != _languages.length - 1)
                        const Divider(height: 1, thickness: 1, color: _line),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
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
}
