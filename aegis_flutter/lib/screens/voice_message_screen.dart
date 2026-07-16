import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';

class VoiceMessageScreen extends StatelessWidget {
  const VoiceMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF090D16),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Voice Message',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded, color: Colors.white, size: 22.0),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              // 1. Voice soundwave visualization graphic
              Center(
                child: SizedBox(
                  height: 64.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildWaveBar(14.0),
                      _buildWaveBar(24.0),
                      _buildWaveBar(38.0),
                      _buildWaveBar(20.0),
                      _buildWaveBar(32.0),
                      _buildWaveBar(48.0),
                      _buildWaveBar(64.0),
                      _buildWaveBar(52.0),
                      _buildWaveBar(30.0),
                      _buildWaveBar(42.0),
                      _buildWaveBar(22.0),
                      _buildWaveBar(16.0),
                      _buildWaveBar(26.0),
                      _buildWaveBar(38.0),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              // Time counter details
              const Center(
                child: Text(
                  '00:12',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 18.0),

              // 2. Microphone record trigger button
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Microphone circle
                    Container(
                      width: 64.0,
                      height: 64.0,
                      decoration: BoxDecoration(
                        color: AegisColors.violet,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AegisColors.violet.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.mic_none_rounded,
                          color: Colors.white,
                          size: 28.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Swipe up instruction
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.keyboard_arrow_up_rounded, color: AegisColors.textSecondary, size: 14.0),
                        SizedBox(width: 4.0),
                        Text(
                          'Slide up to cancel',
                          style: TextStyle(
                            color: AegisColors.textSecondary,
                            fontSize: 11.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28.0),

              // 3. Nearby Devices list Section
              const Text(
                'Nearby Devices',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: AegisColors.textSecondary,
                ),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: ListView(
                  children: [
                    _buildVoiceShareDeviceRow('SIG-8AF3', '2 hops'),
                    _buildInnerDivider(),
                    _buildVoiceShareDeviceRow('SIG-C4E1', '1 hop'),
                    _buildInnerDivider(),
                    _buildVoiceShareDeviceRow('SIG-B2C1', '2 hops'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWaveBar(double height) {
    return Container(
      width: 3.5,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        color: AegisColors.violet,
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  Widget _buildVoiceShareDeviceRow(String nodeId, String hops) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Avatar circle
              Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: AegisColors.neonGreen.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sensors_rounded,
                  color: AegisColors.neonGreen,
                  size: 16.0,
                ),
              ),
              const SizedBox(width: 14.0),
              // Info Details
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nodeId,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    hops,
                    style: const TextStyle(
                      fontSize: 11.0,
                      color: AegisColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Purple circular send icon button
          Container(
            width: 32.0,
            height: 32.0,
            decoration: BoxDecoration(
              color: AegisColors.violet.withOpacity(0.1).withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(color: AegisColors.violet.withOpacity(0.4), width: 1.0),
            ),
            child: const Center(
              child: Icon(
                Icons.send_rounded,
                color: AegisColors.violet,
                size: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerDivider() {
    return const Divider(
      color: Color(0xFF1E293B),
      height: 1.0,
      thickness: 0.5,
    );
  }
}
