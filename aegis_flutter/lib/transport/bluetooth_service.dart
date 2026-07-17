// Bluetooth LE - Fallback transport
// Range: 10-30m

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import '../models/signal_packet.dart';

class BluetoothService {
  static const _bleChannel = MethodChannel('aegis_ble');

  // BLE is used ONLY for peer discovery (extracting SIG-ID from scan
  // response). GATT data transfer is not supported — no GATT server on
  // Android side. All packet transport goes through Nearby Connections.
  static const String aegisServiceUuid = 'a6e5f100-0000-1000-8000-00805f9b34fb';

  final _messageController = StreamController<SignalPacket>.broadcast();
  Stream<SignalPacket> get messageStream => _messageController.stream;

  Timer? _scanTimer;
  StreamSubscription<List<fbp.ScanResult>>? _scanSub;
  bool get isConnected => false;

  /// Called when a scan discovers a peer's SIG-ID from BLE advertisement
  /// service data (no GATT connect needed).
  void Function(String sigId)? onPeerDiscovered;

  String _mySigId = 'SIG-????';
  void setMySigId(String id) => _mySigId = id;

  /// Extracts the peer's SIG-ID from BLE advertisement service data.
  String? _extractSigId(fbp.ScanResult r) {
    try {
      final sd = r.advertisementData.serviceData;
      final raw = sd[fbp.Guid(aegisServiceUuid)];
      if (raw != null && raw.isNotEmpty) {
        return utf8.decode(raw);
      }
    } catch (_) {}
    return null;
  }

  Future<void> startAdvertising() async {
    debugPrint('📢 BLE: Starting...');

    try {
      if (await fbp.FlutterBluePlus.isSupported == false) {
        debugPrint('❌ BLE not supported');
        return;
      }

      // Subscribe to scan results ONCE (persistent)
      _scanSub = fbp.FlutterBluePlus.scanResults.listen((results) {
        for (final r in results) {
          _processScanResult(r);
        }
      });

      _startPeriodicScan();

      try {
        final advertised = await _bleChannel
            .invokeMethod<bool>('startAdvertising', {'sigId': _mySigId});
        if (advertised == true) {
          debugPrint('✅ BLE advertising started via platform channel');
        } else {
          debugPrint('⚠️ BLE advertising not available on this device');
        }
      } catch (e) {
        debugPrint('⚠️ BLE platform advertising failed: $e');
      }

      debugPrint('✅ BLE: Active');
    } catch (e) {
      debugPrint('❌ BLE error: $e');
    }
  }

  void _processScanResult(fbp.ScanResult r) {
    final uuidStrings = r.advertisementData.serviceUuids
        .map((g) => g.str128.toLowerCase())
        .toList();
    final isAegis = uuidStrings.contains(aegisServiceUuid) ||
        uuidStrings.any((u) => u.contains('a6e5f100'));
    if (!isAegis) return;

    debugPrint('📡 BLE: Found AEGIS device — ${r.device.remoteId}');

    // Extract SIG-ID from scan response service data.
    // BLE is used only for peer discovery (no GATT data transfer —
    // Nearby/WiFi Direct is the primary transport for packets).
    final peerSigId = _extractSigId(r);
    if (peerSigId != null && peerSigId != _mySigId) {
      debugPrint('📡 BLE: Peer SIG-ID = $peerSigId');
      onPeerDiscovered?.call(peerSigId);
    } else if (peerSigId == null) {
      debugPrint('📡 BLE: No service data (scan response not yet received)');
    }
  }

  void _startPeriodicScan() {
    _scanTimer?.cancel();
    _doScanCycle();
    _scanTimer =
        Timer.periodic(const Duration(seconds: 8), (_) => _doScanCycle());
  }

  Future<void> _doScanCycle() async {
    debugPrint('📡 BLE: Scan cycle starting...');
    try {
      await fbp.FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 6),
        androidUsesFineLocation: true,
      );
    } catch (e) {
      debugPrint('⚠️ BLE scan error: $e');
    }
    debugPrint('📡 BLE: Scan cycle done');
  }

  Future<bool> send(SignalPacket packet) async {
    // BLE is peer-discovery only; all data transfer goes through
    // Nearby Connections (WiFi Direct). See bluetooth_service.dart header.
    return false;
  }

  void dispose() {
    _scanTimer?.cancel();
    _scanSub?.cancel();
    try {
      _bleChannel.invokeMethod('stopAdvertising');
    } catch (_) {}
    fbp.FlutterBluePlus.stopScan();
    _messageController.close();
  }
}
