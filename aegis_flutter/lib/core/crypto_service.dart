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

  SimpleKeyPair keyPairFromBytes(
    List<int> privateKey,
    List<int> publicKey,
  ) {
    return SimpleKeyPairData(
      privateKey,
      publicKey: SimplePublicKey(publicKey, type: KeyPairType.ed25519),
      type: KeyPairType.ed25519,
    );
  }

  Future<bool> verifySignatureBytes(
    List<int> message,
    List<int> signature,
    List<int> publicKey,
  ) async {
    return await _ed25519.verify(
      message,
      signature: Signature(
        signature,
        publicKey: SimplePublicKey(publicKey, type: KeyPairType.ed25519),
      ),
    );
  }
}
