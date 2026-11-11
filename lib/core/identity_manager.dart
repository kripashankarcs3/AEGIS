import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'crypto_service.dart';

class IdentityManager {
  IdentityManager();
  final CryptoService _cryptoService = CryptoService();

  String? _sigId;
  String? _publicKey;
  String? _privateKey;
  DateTime? _createdAt;

  String? get sigId => _sigId;
  String? get publicKey => _publicKey;
  String? get privateKey => _privateKey;
  DateTime? get createdAt => _createdAt;

  Future<void> initialize() async {
    await loadIdentity();
    if (_sigId == null) {
      await generateIdentity();
      await saveIdentity();
    }
  }

  Future<void> generateIdentity() async {
    final keyPair = await _cryptoService.generateKeyPair();
    final pubKey = await keyPair.extractPublicKey();

    if (pubKey is SimplePublicKey && keyPair is SimpleKeyPair) {
      final privKeyBytes = await keyPair.extractPrivateKeyBytes();
      final pubBytes = pubKey.bytes;
      final h = List<int>.filled(8, 0);
      for (int i = 0; i < pubBytes.length; i++) {
        h[i % 8] ^= pubBytes[i];
      }
      final code = h
          .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
          .join()
          .substring(0, 8);
      _sigId = 'SIG-$code';
      _publicKey =
          pubBytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
      _privateKey = base64Encode(privKeyBytes);
      _createdAt = DateTime.now();
    }
  }

  Future<void> loadIdentity() async {
    final box = Hive.box('settings');
    _sigId = box.get('identity_sigId') as String?;
    _publicKey = box.get('identity_publicKey') as String?;
    _privateKey = box.get('identity_privateKey') as String?;
    final createdAtMs = box.get('identity_createdAt') as int?;
    _createdAt = createdAtMs != null
        ? DateTime.fromMillisecondsSinceEpoch(createdAtMs)
        : null;
  }

  Future<void> saveIdentity() async {
    final box = Hive.box('settings');
    await box.put('identity_sigId', _sigId);
    await box.put('identity_publicKey', _publicKey);
    await box.put('identity_privateKey', _privateKey);
    await box.put('identity_createdAt', _createdAt?.millisecondsSinceEpoch);
  }
}
