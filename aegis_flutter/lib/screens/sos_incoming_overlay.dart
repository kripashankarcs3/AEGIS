import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'chat_conversation_screen.dart';

class SosIncomingOverlayScreen extends StatefulWidget {
  const SosIncomingOverlayScreen({super.key});

  @override
  State<SosIncomingOverlayScreen> createState() => _SosIncomingOverlayScreenState();
}

class _SosIncomingOverlayScreenState extends State<SosIncomingOverlayScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.35).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B11),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AegisColors.sosRed.withOpacity(0.55),
              width: 3.0,
            ),
            boxShadow: [
              BoxShadow(
                color: AegisColors.sosRed.withOpacity(0.12),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 36.0),
                
                // concentric glowing waves and alert icon
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // concentric wave 2
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AegisColors.sosRed.withOpacity(0.04),
                            border: Border.all(color: AegisColors.sosRed.withOpacity(0.12), width: 1.5),
                          ),
                        ),
                      ),
                      // concentric wave 1
                      Container(
                        width: 74.0,
                        height: 74.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AegisColors.sosRed.withOpacity(0.08),
                          border: Border.all(color: AegisColors.sosRed.withOpacity(0.24), width: 2.0),
                        ),
                      ),
                      // Red Siren Icon
                      Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AegisColors.sosRed,
                        ),
                        child: Icon(
                          Icons.notifications_active_rounded,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.0),

                Text(
                  'SOS ALERT RECEIVED',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: 6.0),
                Text(
                  'Medical Emergency',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: AegisColors.sosRed,
                  ),
                ),
                SizedBox(height: 36.0),

                // Details Card layout
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F131A),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: const Color(0xFF1F2937), width: 1.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        label: 'From',
                        valueWidget: Text(
                          'SIG-8AF3',
                          style: TextStyle(
                            color: AegisColors.sosRed,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                      _buildDivider(),
                      _buildDetailRow(
                        label: 'Location',
                        valueWidget: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '28.6139° N, 77.2090° E',
                              style: TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 6.0),
                            Icon(Icons.location_on_rounded, color: AegisColors.textSecondary, size: 16.0),
                          ],
                        ),
                      ),
                      _buildDivider(),
                      _buildDetailRow(
                        label: 'Hop Count',
                        valueWidget: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '3 hops away',
                              style: TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 6.0),
                            Icon(Icons.share_rounded, color: AegisColors.textSecondary, size: 15.0),
                          ],
                        ),
                      ),
                      _buildDivider(),
                      _buildDetailRow(
                        label: 'Time',
                        valueWidget: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '10:24 AM  •  12 May 2024',
                              style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 6.0),
                            Icon(Icons.access_time_rounded, color: AegisColors.textSecondary, size: 15.0),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      // Emergency text banner description
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: AegisColors.sosRed.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6.0),
                          border: Border.all(color: AegisColors.sosRed.withOpacity(0.24), width: 1.0),
                        ),
                        child: Center(
                          child: Text(
                            'Emergency assistance needed!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // OPEN CHAT action button
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // pop overlay
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ChatConversationScreen(nodeId: 'SIG-8AF3'),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: AegisColors.sosRed,
                      borderRadius: BorderRadius.circular(6.0),
                      boxShadow: [
                        BoxShadow(
                          color: AegisColors.sosRed.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_rounded, color: Colors.white, size: 18.0),
                        SizedBox(width: 8.0),
                        Text(
                          'OPEN CHAT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.0),

                // DISMISS button
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: double.infinity,
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFF161A22),
                      borderRadius: BorderRadius.circular(6.0),
                      border: Border.all(color: const Color(0xFF374151), width: 1.0),
                    ),
                    child: Center(
                      child: Text(
                        'DISMISS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.0),

                // Expiry timer sub-tagline
                Text(
                  '3 beeps sent  •  Alert will auto-expire in 60s',
                  style: TextStyle(
                    color: AegisColors.sosRed,
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({required String label, required Widget valueWidget}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AegisColors.textSecondary,
              fontSize: 12.5,
            ),
          ),
          valueWidget,
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        color: Color(0xFF1F2937),
        height: 1.0,
      ),
    );
  }
}
