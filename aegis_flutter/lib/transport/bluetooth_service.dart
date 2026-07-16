// Bluetooth LE - Fallback transport
// Range: 10-30m

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import '../models/signal_packet.dart';

class BluetoothService {
  static const String aegisServiceUuid = '0000aegi-0000-1000-8000-00805f9b34fb';
  static const String aegisCharUuid = '0000aegi-0001-1000-8000-00805f9b34fb';

  final _messageController = StreamController<SignalPacket>.broadcast();
  Stream<SignalPacket> get messageStream => _messageController.stream;

  final Map<String, fbp.BluetoothDevice> _connectedDevices = {};
  bool get isConnected => _connectedDevices.isNotEmpty;

  Future<void> startAdvertising() async {
    debugPrint('📢 BLE: Starting...');

    try {
      if (await fbp.FlutterBluePlus.isSupported == false) {
        debugPrint('❌ BLE not supported');
        return;
      }

      await _startScanning();
      debugPrint('✅ BLE: Active');
    } catch (e) {
      debugPrint('❌ BLE error: $e');
    }
  }

  Future<void> _startScanning() async {
    fbp.FlutterBluePlus.scanResults.listen((results) {
      for (fbp.ScanResult r in results) {
        final uuids = r.advertisementData.serviceUuids
            .map((g) => g.toString().toLowerCase());
        if (uuids.contains(aegisServiceUuid)) {
          _connectToDevice(r.device);
        }
      }
    });

    await fbp.FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 4),
      androidUsesFineLocation: true,
    );
  }

  Future<void> _connectToDevice(fbp.BluetoothDevice device) async {
    final id = device.remoteId.toString();
    if (_connectedDevices.containsKey(id)) return;

    try {
      await device.connect();
      _connectedDevices[id] = device;

      final services = await device.discoverServices();
      for (final svc in services) {
        if (svc.uuid.toString().toLowerCase() == aegisServiceUuid) {
          for (final char in svc.characteristics) {
            if (char.uuid.toString().toLowerCase() == aegisCharUuid) {
              await char.setNotifyValue(true);
              char.lastValueStream.listen(_onDataReceived);
            }
          }
        }
      }
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

      for (final device in _connectedDevices.values) {
        final services = await device.discoverServices();
        for (final svc in services) {
          if (svc.uuid.toString().toLowerCase() == aegisServiceUuid) {
            for (final char in svc.characteristics) {
              if (char.uuid.toString().toLowerCase() == aegisCharUuid) {
                await char.write(bytes);
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint('❌ BLE send: $e');
    }
  }

  void dispose() {
    fbp.FlutterBluePlus.stopScan();
    for (final device in _connectedDevices.values) {
      device.disconnect();
    }
    _messageController.close();
  }
}
