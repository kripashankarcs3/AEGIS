import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../constants/aegis_colors.dart';
import '../constants/aegis_animations.dart';
import '../providers/identity_provider.dart';
import '../providers/network_provider.dart';

class IdentityScreen extends ConsumerWidget {
  const IdentityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sigId = ref.watch(sigIdProvider);
    final identity = ref.watch(identityProvider);
    final publicKey = identity.publicKey;
    final displayKey = publicKey.isEmpty ? 'Not generated yet' : publicKey;
    final localIp = ref.watch(localIpProvider);
    final qrData = localIp.whenOrNull(
          data: (ip) =>
              'AEGIS-V1|$sigId|$ip|9090|$publicKey',
        ) ??
        'AEGIS-V1|$sigId|0.0.0.0|9090|$publicKey';

    return Scaffold(
      backgroundColor: AegisColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AegisColors.surface2,
            shape: BoxShape.circle,
            border: Border.all(color: AegisColors.border1, width: 0.5),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back,
                color: AegisColors.textPrimary, size: 18),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          'My Identity',
          style: TextStyle(
            color: AegisColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AegisColors.surface2,
              shape: BoxShape.circle,
              border: Border.all(color: AegisColors.border1, width: 0.5),
            ),
            child: Icon(
              Icons.verified_user_rounded,
              color: AegisColors.isLight
                  ? const Color(0xFF5B21B6)
                  : AegisColors.violet,
              size: 18,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StaggeredFadeIn(index: 0, child: _profileCard(context, sigId)),
              const SizedBox(height: 28),
              StaggeredFadeIn(
                  index: 1, child: _publicKeySection(context, displayKey)),
              const SizedBox(height: 28),
              StaggeredFadeIn(index: 2, child: _qrCodeSection(qrData, sigId)),
              const SizedBox(height: 28),
              StaggeredFadeIn(index: 3, child: _securitySection()),
              const SizedBox(height: 28),
              StaggeredFadeIn(index: 4, child: _infoBox()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileCard(BuildContext context, String sigId) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AegisColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AegisColors.border1, width: 0.5),
        boxShadow: AegisColors.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AegisColors.isLight
                      ? const Color(0xFFEDE9FE)
                      : const Color(0xFF1E1B4B),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.person_rounded,
                    color: AegisColors.isLight
                        ? const Color(0xFF6D28D9)
                        : AegisColors.violet,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              sigId,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AegisColors.textPrimary,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: sigId));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Node ID copied to clipboard')),
                                );
                              },
                              child: Icon(Icons.copy_rounded,
                                  color: AegisColors.textMuted, size: 14),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AegisColors.neonGreen.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AegisColors.neonGreen.withOpacity(0.2),
                                width: 0.5),
                          ),
                          child: Text(
                            'Active & Trusted',
                            style: TextStyle(
                              color: AegisColors.neonGreen,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '2 hops away • via SIG-B2C1',
                      style: TextStyle(
                        fontSize: 12,
                        color: AegisColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 0.5,
            color: AegisColors.border1.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Member since',
                style: TextStyle(
                    fontSize: 12,
                    color: AegisColors.textSecondary,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                '12 May 2024',
                style: TextStyle(
                    fontSize: 12,
                    color: AegisColors.textPrimary,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _publicKeySection(BuildContext context, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                    color: AegisColors.violet,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 8),
            Text(
              'IDENTITY KEY',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AegisColors.textSecondary,
                  letterSpacing: 0.5),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: key.startsWith('Not generated')
              ? null
              : () {
                  Clipboard.setData(ClipboardData(text: key));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Public key copied to clipboard')),
                  );
                },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AegisColors.isLight
                  ? const Color(0xFFF8FAFC)
                  : const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AegisColors.border1, width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      key.startsWith('Not generated') ? '' : 'Public Key (Tap to copy)',
                      style: TextStyle(
                          fontSize: 11,
                          color: AegisColors.textSecondary,
                          fontWeight: FontWeight.w600),
                    ),
                    if (!key.startsWith('Not generated'))
                      Icon(Icons.copy_rounded,
                          color: AegisColors.textMuted, size: 14),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  key,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: AegisColors.textPrimary,
                    height: 1.5,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _qrCodeSection(String qrData, String sigId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                    color: AegisColors.violet,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 8),
            Text(
              'DIRECT CONNECT QR',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AegisColors.textSecondary,
                  letterSpacing: 0.5),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AegisColors.border1, width: 0.5),
          ),
          child: Column(
            children: [
              QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200,
                backgroundColor: Colors.white,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Color(0xFF1A1A2E),
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Share this QR to connect directly',
                style: TextStyle(
                  fontSize: 12,
                  color: AegisColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                sigId,
                style: TextStyle(
                  fontSize: 13,
                  color: AegisColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _securitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                    color: AegisColors.violet,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 8),
            Text(
              'SECURITY',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AegisColors.textSecondary,
                  letterSpacing: 0.5),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AegisColors.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AegisColors.border1, width: 0.5),
            boxShadow: AegisColors.cardShadow,
          ),
          child: Column(
            children: [
              _securityRow('Key Type', 'Ed25519', isStatus: false),
              _divider(),
              _securityRow('Signature', 'Valid',
                  isStatus: true,
                  statusColor: AegisColors.neonGreen,
                  icon: Icons.check_circle_outline_rounded),
              _divider(),
              _securityRow('Key Created', '12 May 2024', isStatus: false),
              _divider(),
              _securityRow('Last Rotated', 'Never', isStatus: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _securityRow(String label, String value,
      {bool isStatus = false, Color? statusColor, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: AegisColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: statusColor, size: 15),
                const SizedBox(width: 6),
              ],
              Text(
                value,
                style: TextStyle(
                  color: isStatus ? statusColor : AegisColors.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AegisColors.isLight
            ? const Color(0xFFF5F3FF)
            : const Color(0xFF1E152A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AegisColors.isLight
              ? const Color(0xFFDDD6FE)
              : AegisColors.violet.withOpacity(0.15),
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.help_outline_rounded,
            color: AegisColors.isLight
                ? const Color(0xFF6D28D9)
                : AegisColors.violet,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What is SIG-ID?',
                  style: TextStyle(
                    color: AegisColors.isLight
                        ? const Color(0xFF5B21B6)
                        : AegisColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Your SIG-ID is derived from your public key. It is your unique identity in the mesh network.',
                  style: TextStyle(
                    color: AegisColors.isLight
                        ? const Color(0xFF6D28D9).withOpacity(0.85)
                        : AegisColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      height: 0.5,
      color: AegisColors.border1.withOpacity(0.5),
    );
  }
}
