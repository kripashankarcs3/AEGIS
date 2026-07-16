import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '../services/storage_service.dart';

final localIpProvider = FutureProvider<String>((ref) async {
  final cached = StorageService.getCachedLocalIp();
  if (cached != null && cached.isNotEmpty) return cached;
  try {
    final ip = await NetworkInfo().getWifiIP();
    if (ip != null && ip.isNotEmpty) {
      await StorageService.setCachedLocalIp(ip);
      return ip;
    }
  } catch (_) {}
  return '0.0.0.0';
});
