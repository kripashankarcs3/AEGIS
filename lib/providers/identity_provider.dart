// IdentityProvider — exposes the device's SIG-ID and keys to the rest of the app.
//
// First launch: generates an Ed25519 keypair, derives SIG-XXXX, persists to Hive.
// Subsequent launches: loads from Hive.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/identity_manager.dart';

// ──────────────────────────────────────────────
// State
// ──────────────────────────────────────────────

class IdentityState {
  final String sigId;
  final String publicKey;
  final String privateKey;
  final bool isReady;
  final DateTime? createdAt;

  const IdentityState({
    this.sigId = 'SIG-????',
    this.publicKey = '',
    this.privateKey = '',
    this.isReady = false,
    this.createdAt,
  });

  IdentityState copyWith({
    String? sigId,
    String? publicKey,
    String? privateKey,
    bool? isReady,
    DateTime? createdAt,
  }) =>
      IdentityState(
        sigId: sigId ?? this.sigId,
        publicKey: publicKey ?? this.publicKey,
        privateKey: privateKey ?? this.privateKey,
        isReady: isReady ?? this.isReady,
        createdAt: createdAt ?? this.createdAt,
      );
}

// ──────────────────────────────────────────────
// Notifier
// ──────────────────────────────────────────────

class IdentityNotifier extends StateNotifier<IdentityState> {
  IdentityNotifier() : super(const IdentityState());

  final IdentityManager _manager = IdentityManager();

  Future<void> initialize() async {
    await _manager.initialize();
    state = state.copyWith(
      sigId: _manager.sigId ?? 'SIG-????',
      publicKey: _manager.publicKey ?? '',
      privateKey: _manager.privateKey ?? '',
      isReady: true,
      createdAt: _manager.createdAt,
    );
  }

  String get sigId => state.sigId;
  String get publicKey => state.publicKey;
  String get privateKey => state.privateKey;
}

// ──────────────────────────────────────────────
// Providers
// ──────────────────────────────────────────────

final identityProvider = StateNotifierProvider<IdentityNotifier, IdentityState>(
  (ref) => IdentityNotifier(),
);

/// Convenience provider for just the SIG-ID string.
final sigIdProvider =
    Provider<String>((ref) => ref.watch(identityProvider).sigId);
