import 'package:cryptography/cryptography.dart';

class CryptoService {
  CryptoService();

  final Ed25519 _ed25519 = Ed25519();

  Future<KeyPair> generateKeyPair() async {
    return await _ed25519.newKeyPair();
  }

  Future<List<int>> signMessage(
    List<int> message,
    KeyPair keyPair,
  ) async {
    final signature = await _ed25519.sign(
      message,
      keyPair: keyPair,
    );

    return signature.bytes;
  }

  Future<bool> verifySignature(
    List<int> message,
    Signature signature,
    SimplePublicKey publicKey,
  ) async {
    return await _ed25519.verify(
      message,
      signature: Signature(
        signature.bytes,
        publicKey: publicKey,
      ),
    );
  }
}
