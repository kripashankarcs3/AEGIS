import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../constants/aegis_colors.dart';
import '../models/peer_address.dart';
import '../providers/mesh_provider.dart';
import '../services/storage_service.dart';
import 'main_shell.dart';

class QrScannerScreen extends ConsumerStatefulWidget {
  const QrScannerScreen({super.key});

  @override
  ConsumerState<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends ConsumerState<QrScannerScreen> {
  MobileScannerController? _scannerController;
  bool _isProcessing = false;
  bool _hasError = false;
  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
    );
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;
    _isProcessing = true;
    _handleQrData(barcode.rawValue!);
  }

  void _handleQrData(String data) {
    final parts = data.split('|');
    if (parts.length < 4 || parts[0] != 'AEGIS-V1') {
      setState(() {
        _hasError = true;
        _errorMsg = 'Invalid QR code format';
        _isProcessing = false;
      });
      return;
    }

    final sigId = parts[1];
    final ip = parts[2];
    final port = int.tryParse(parts[3]) ?? 9090;
    final _ = parts.length > 4 ? parts[4] : '';

    debugPrint('QR scanned: $sigId @ $ip:$port');

    // Save to storage
    StorageService.saveDirectPeer(PeerAddress(
      sigId: sigId,
      ip: ip,
      port: port,
      lastSeen: DateTime.now(),
    ));

    // Connect via Direct TCP
    _connectAndNavigate(sigId, ip, port);
  }

  Future<void> _connectAndNavigate(String sigId, String ip, int port) async {
    final mesh = ref.read(meshProvider.notifier);
    final state = ref.read(meshProvider);

    if (!state.isRunning) {
      await mesh.start();
    }

    await mesh.connectDirectPeer(sigId, ip, port);

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainShell(),
          transitionsBuilder: (_, a, __, child) =>
              FadeTransition(opacity: a, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                MobileScanner(
                  controller: _scannerController,
                  onDetect: _onDetect,
                ),
                // Scan overlay frame
                Center(
                  child: Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      border: Border.all(color: AegisColors.electricBlue.withOpacity(0.6), width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white.withOpacity(0.3),
                          size: 64,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_hasError)
                  Positioned(
                    bottom: 40,
                    left: 24,
                    right: 24,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMsg,
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() {
                              _hasError = false;
                              _isProcessing = false;
                            }),
                            child: const Icon(Icons.close, color: Colors.white, size: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0), Colors.black],
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Point camera at another AEGIS device\'s QR code',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AegisColors.cardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AegisColors.border1, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
