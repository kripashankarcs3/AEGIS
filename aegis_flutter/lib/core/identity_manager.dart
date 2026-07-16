import 'dart:math';

import 'package:cryptography/cryptography.dart';

import 'crypto_service.dart';

class IdentityManager {
  IdentityManager();

  final CryptoService _cryptoService = CryptoService();

  String? _sigId;
  String? _publicKey;
  String? _privateKey;

  // Getters
  String? get sigId => _sigId;
  String? get publicKey => _publicKey;
  String? get privateKey => _privateKey;

  /// Called when the app starts.
  Future<void> initialize() async {
    await loadIdentity();

    if (_sigId == null) {
      await generateIdentity();
      await saveIdentity();
    }
  }

  /// Generates a brand-new device identity.
  Future<void> generateIdentity() async {
    // Generate unique device ID
    _sigId = _generateSigId();

    // Generate Ed25519 key pair
    final KeyPair keyPair = await _cryptoService.generateKeyPair();

    // Extract public key
    final publicKey = await keyPair.extractPublicKey();

    // Convert public key to hex string
    if (publicKey is SimplePublicKey) {
      _publicKey = publicKey.bytes
          .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
          .join();
    } else {
      _publicKey = "";
    }

    // Temporary placeholder.
    // In the next step we'll serialize and store the real private key in Hive.
    _privateKey = "GENERATED_PRIVATE_KEY";
  }

  /// Loads identity from local storage.
  /// Hive implementation will be added next.
  Future<void> loadIdentity() async {}

  /// Saves identity to local storage.
  /// Hive implementation will be added next.
  Future<void> saveIdentity() async {}

  /// Creates IDs like:
  /// SIG-A7D2
  String _generateSigId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    final random = Random();

    final code = List.generate(
      4,
      (_) => chars[random.nextInt(chars.length)],
    ).join();

    return 'SIG-$code';
  }
}
