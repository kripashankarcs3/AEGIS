import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'splash_screen.dart'; // Reuse MeshGlobePainter
import 'main_shell.dart';

class LoginJoinScreen extends StatelessWidget {
  const LoginJoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Stars background
            Positioned.fill(
              child: CustomPaint(
                painter: StarsBackgroundPainter(),
              ),
            ),

            // Earth Globe mesh bottom graphic layout
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 150.0,
              child: CustomPaint(
                painter: MeshGlobePainter(),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32.0),
                  // Title details
                  const Text(
                    'Join the Network',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  const Text(
                    'Choose a way to continue',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: AegisColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 48.0),

                  // Option Button 1: Continue with Phone
                  Container(
                    width: double.infinity,
                    height: 46.0,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AegisColors.busyPurple,
                          AegisColors.primaryBlue,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: AegisColors.primaryBlue.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () => _navigateToMainShell(context),
                      borderRadius: BorderRadius.circular(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.phone_outlined,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          SizedBox(width: 10.0),
                          Text(
                            'Continue with Phone',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Option Button 2: Scan QR Code
                  _buildOutlineIconButton(
                    context: context,
                    icon: Icons.qr_code_scanner_rounded,
                    label: 'Scan QR Code',
                  ),
                  const SizedBox(height: 16.0),

                  // Option Button 3: Join as Guest
                  _buildOutlineIconButton(
                    context: context,
                    icon: Icons.person_outline_rounded,
                    label: 'Join as Guest',
                  ),
                  const SizedBox(height: 44.0),

                  // Offline notice indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off_rounded,
                        color: AegisColors.textSecondary.withOpacity(0.8),
                        size: 16.0,
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        'No Internet? No problem.\nAEGIS works offline.',
                        style: TextStyle(
                          color: AegisColors.textSecondary.withOpacity(0.8),
                          fontSize: 11.5,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMainShell(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MainShell(),
      ),
      (route) => false, // Remove all previous routes from history stack
    );
  }

  Widget _buildOutlineIconButton({
    required BuildContext context,
    required IconData icon,
    required String label,
  }) {
    return Container(
      width: double.infinity,
      height: 46.0,
      decoration: BoxDecoration(
        color: const Color(0xFF0C1017),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0xFF1E293B), width: 1.0),
      ),
      child: InkWell(
        onTap: () => _navigateToMainShell(context),
        borderRadius: BorderRadius.circular(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 18.0,
            ),
            const SizedBox(width: 10.0),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
