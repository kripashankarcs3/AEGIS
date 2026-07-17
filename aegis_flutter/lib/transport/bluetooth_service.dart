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

  // Valid 128-bit BLE UUIDs (using random base to avoid conflicts)
  static const String aegisServiceUuid = 'a6e5f100-0000-1000-8000-00805f9b34fb';
  static const String aegisCharUuid = 'a6e5f101-0001-1000-8000-00805f9b34fb';

  final _messageController = StreamController<SignalPacket>.broadcast();
  Stream<SignalPacket> get messageStream => _messageController.stream;

  final Map<String, fbp.BluetoothDevice> _connectedDevices = {};
  final Map<String, fbp.BluetoothCharacteristic?> _txCharacteristics = {};
  final Map<String, StreamSubscription?> _dataSubscriptions = {};
  Timer? _scanTimer;
  StreamSubscription<List<fbp.ScanResult>>? _scanSub;
  bool get isConnected => _connectedDevices.isNotEmpty;

  /// Called when a scan discovers a peer's SIG-ID from BLE advertisement
  /// service data (no GATT connect needed).
  void Function(String sigId)? onPeerDiscovered;

  /// Called by mesh_provider when a new BLE peer connects
  VoidCallback? onNewPeerConnected;

  String _mySigId = 'SIG-????';
  void setMySigId(String id) => _mySigId = id;

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
        final advertised = await _bleChannel.invokeMethod<bool>('startAdvertising', {'sigId': _mySigId});
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

    // Extract SIG-ID from scan response service data
    try {
      final sd = r.advertisementData.serviceData;
      final raw = sd[fbp.Guid(aegisServiceUuid)];
      if (raw != null && raw.isNotEmpty) {
        final peerSigId = utf8.decode(raw);
        debugPrint('📡 BLE: Peer SIG-ID = $peerSigId');
        if (peerSigId != _mySigId) {
          onPeerDiscovered?.call(peerSigId);
        }
      } else {
        debugPrint('📡 BLE: No service data (scan response not yet received)');
      }
    } catch (e) {
      debugPrint('⚠️ BLE: Failed to parse service data: $e');
    }

    _connectToDevice(r.device);
  }

  void _startPeriodicScan() {
    _scanTimer?.cancel();
    _doScanCycle();
    _scanTimer = Timer.periodic(const Duration(seconds: 8), (_) => _doScanCycle());
  }

  Future<void> _doScanCycle() async {
    debugPrint('📡 BLE: Scan cycle starting...');
    try {
      await fbp.FlutterBluePlus.startScan(
        withServices: [fbp.Guid(aegisServiceUuid)],
        timeout: const Duration(seconds: 6),
        androidUsesFineLocation: true,
      );
    } catch (e) {
      debugPrint('⚠️ BLE scan error: $e');
    }
    debugPrint('📡 BLE: Scan cycle done');
  }

  Future<void> _connectToDevice(fbp.BluetoothDevice device) async {
    final id = device.remoteId.toString();
    if (_connectedDevices.containsKey(id)) return;

    try {
      await device.connect();
      _connectedDevices[id] = device;

      final services = await device.discoverServices();
      for (final svc in services) {
        if (svc.uuid.str128.toLowerCase() == aegisServiceUuid) {
          for (final char in svc.characteristics) {
            if (char.uuid.str128.toLowerCase() == aegisCharUuid) {
              await char.setNotifyValue(true);
              _txCharacteristics[id] = char;
              _dataSubscriptions[id]?.cancel();
              _dataSubscriptions[id] = char.lastValueStream.listen(_onDataReceived);
            }
          }
        }
      }
      onNewPeerConnected?.call();
    } catch (e) {
      debugPrint('❌ BLE connect: $e');
      _connectedDevices.remove(id);
    }
  }

  void _onDataReceived(List<int> value) {
    try {
      final json = jsonDecode(utf8.decode(value));
      final packet = SignalPacket.fromJson(json);
      _messageController.add(packet);
    } catch (e) {
      debugPrint('❌ BLE parse: $e');
    }
  }

  Future<void> send(SignalPacket packet) async {
    try {
      final bytes = utf8.encode(jsonEncode(packet.toJson()));

      for (final id in _connectedDevices.keys) {
        final char = _txCharacteristics[id];
        if (char != null) {
          await char.write(bytes);
        }
      }
    } catch (e) {
      debugPrint('❌ BLE send: $e');
    }
  }

  void dispose() {
    _scanTimer?.cancel();
    _scanSub?.cancel();
    try {
      _bleChannel.invokeMethod('stopAdvertising');
    } catch (_) {}
    fbp.FlutterBluePlus.stopScan();
    for (final sub in _dataSubscriptions.values) {
      sub?.cancel();
    }
    _dataSubscriptions.clear();
    for (final device in _connectedDevices.values) {
      device.disconnect();
    }
    _connectedDevices.clear();
    _txCharacteristics.clear();
    _messageController.close();
  }
}
