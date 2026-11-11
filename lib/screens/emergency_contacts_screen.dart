import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import '../services/storage_service.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  List<Map<String, String>> _contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final raw = StorageService.getSetting('emergency_contacts');
    if (raw != null) {
      final list = (raw as List).map((e) => Map<String, String>.from(e as Map)).toList();
      setState(() => _contacts = list);
    }
  }

  Future<void> _saveContacts() async {
    await StorageService.setSetting('emergency_contacts', _contacts);
  }

  Future<void> _addContact() async {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AegisColors.surface1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Add Contact', style: TextStyle(color: AegisColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              style: TextStyle(color: AegisColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Name',
                hintStyle: TextStyle(color: AegisColors.textMuted),
                fillColor: AegisColors.background,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AegisColors.border1)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              style: TextStyle(color: AegisColors.textPrimary),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Phone',
                hintStyle: TextStyle(color: AegisColors.textMuted),
                fillColor: AegisColors.background,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AegisColors.border1)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('Cancel', style: TextStyle(color: AegisColors.textSecondary))),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Add', style: TextStyle(color: AegisColors.electricBlue, fontWeight: FontWeight.w700))),
        ],
      ),
    );
    if (result == true && nameCtrl.text.trim().isNotEmpty) {
      _contacts.add({'name': nameCtrl.text.trim(), 'phone': phoneCtrl.text.trim()});
      await _saveContacts();
      setState(() {});
    }
  }

  Future<void> _removeContact(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AegisColors.surface1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Remove Contact?', style: TextStyle(color: AegisColors.textPrimary)),
        content: Text('Remove ${_contacts[index]['name']}?', style: TextStyle(color: AegisColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('Cancel', style: TextStyle(color: AegisColors.textSecondary))),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Remove', style: TextStyle(color: AegisColors.sosRed, fontWeight: FontWeight.w700))),
        ],
      ),
    );
    if (confirm == true) {
      _contacts.removeAt(index);
      await _saveContacts();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = AegisColors.isLight;
    final bg = isLight ? const Color(0xFFF8FAFC) : AegisColors.background;
    final cardBg = isLight ? Colors.white : AegisColors.cardBg;
    final textPrimary = AegisColors.textPrimary;
    final textSecondary = AegisColors.textSecondary;
    final border = isLight ? const Color(0xFFE2E8F0) : AegisColors.border1;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isLight ? const Color(0xFFF1F5F9) : AegisColors.surface2,
            shape: BoxShape.circle,
            border: Border.all(color: border, width: 0.5),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: textPrimary, size: 18),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text('Emergency Contacts', style: TextStyle(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AegisColors.electricBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.add_rounded, color: AegisColors.electricBlue, size: 20),
              onPressed: _addContact,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: _contacts.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.contact_phone_outlined, color: textSecondary, size: 64),
                    const SizedBox(height: 16),
                    Text('No emergency contacts', style: TextStyle(color: textSecondary, fontSize: 16)),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _addContact,
                      icon: Icon(Icons.add_rounded, color: AegisColors.electricBlue),
                      label: Text('Add Contact', style: TextStyle(color: AegisColors.electricBlue)),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final c = _contacts[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: AegisColors.electricBlue.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              (c['name'] ?? '?')[0].toUpperCase(),
                              style: TextStyle(color: AegisColors.electricBlue, fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(c['name'] ?? '', style: TextStyle(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w700)),
                              if ((c['phone'] ?? '').isNotEmpty) ...[
                                const SizedBox(height: 3),
                                Text(c['phone']!, style: TextStyle(color: textSecondary, fontSize: 13)),
                              ],
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _removeContact(index),
                          child: Container(
                            width: 32, height: 32,
                            decoration: BoxDecoration(
                              color: AegisColors.sosRed.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.delete_outline_rounded, color: AegisColors.sosRed, size: 18),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: _contacts.isNotEmpty
          ? FloatingActionButton(
              onPressed: _addContact,
              backgroundColor: AegisColors.electricBlue,
              child: const Icon(Icons.add_rounded, color: Colors.white),
            )
          : null,
    );
  }
}
