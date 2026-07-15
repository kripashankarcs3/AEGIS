// NOTE: this file wasn't in the original scaffold (only chat_provider,
// identity_provider, mesh_provider, survivor_provider existed). Added it
// because sos_screen.dart needs somewhere to watch SOS state from. Flag
// this to the team so nobody's surprised by an extra file.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/sos_handler.dart';
import '../services/notification_service.dart';
import 'chat_provider.dart' show myIdentityProvider, sendPacketProvider;

final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService();
  service.init();
  return service;
});

final sosHandlerProvider = Provider<SosHandler>((ref) {
  final handler = SosHandler(notificationService: ref.watch(notificationServiceProvider));
  handler.myIdentity = ref.watch(myIdentityProvider);
  handler.broadcastToMesh = (packet) => ref.watch(sendPacketProvider)('broadcast', packet);
  return handler;
});

class SosLogNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final SosHandler handler;
  SosLogNotifier(this.handler) : super([]) {
    _load();
  }

  Future<void> _load() async => state = await handler.log;

  Future<void> trigger({
    required String category,
    String? message,
    double? lat,
    double? lng,
  }) async {
    await handler.trigger(category: category, customMessage: message, lat: lat, lng: lng);
    await _load();
  }

  Future<void> refresh() => _load();
}

final sosLogProvider = StateNotifierProvider<SosLogNotifier, List<Map<String, dynamic>>>(
  (ref) => SosLogNotifier(ref.watch(sosHandlerProvider)),
);
