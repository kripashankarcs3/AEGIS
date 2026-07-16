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
  final bool isReady;

  const IdentityState({
    this.sigId = 'SIG-????',
    this.publicKey = '',
    this.isReady = false,
  });

  IdentityState copyWith({String? sigId, String? publicKey, bool? isReady}) =>
      IdentityState(
        sigId: sigId ?? this.sigId,
        publicKey: publicKey ?? this.publicKey,
        isReady: isReady ?? this.isReady,
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
      isReady: true,
    );
  }

  String get sigId => state.sigId;
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
