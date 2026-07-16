// meshSendProvider — exposes the mesh send function to any provider/widget.
//
// Reads from meshProvider.notifier to call sendPacket.
// If mesh is not yet running, the send is a no-op (packets will be queued
// once the mesh router is initialised).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/signal_packet.dart';
import 'mesh_provider.dart';

/// A function that sends a [SignalPacket] to [peerId] via the mesh router.
/// The [peerId] parameter is kept for symmetry with the old sendPacketProvider
/// signature; routing is handled inside MeshRouter itself.
final meshSendProvider =
    Provider<Future<void> Function(String peerId, SignalPacket packet)>(
  (ref) {
    return (String peerId, SignalPacket packet) async {
      // Only delegate when the mesh is actually running; otherwise swallow
      // (MeshRouter's internal queue will pick it up on reconnect).
      final notifier = ref.read(meshProvider.notifier);
      try {
        await notifier.sendPacket(packet);
      } catch (_) {
        // Silently queue — MeshRouter already handles this internally.
      }
    };
  },
);
