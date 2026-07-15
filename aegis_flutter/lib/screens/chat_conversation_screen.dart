import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'share_file_screen.dart';
import 'voice_message_screen.dart';

class ChatConversationScreen extends StatefulWidget {
  final String nodeId;
  const ChatConversationScreen({super.key, required this.nodeId});

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    final bool isOfflineNode = widget.nodeId == 'SIG-4D2F';

    return Scaffold(
      backgroundColor: AegisColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF090D16),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.nodeId,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Container(
                  width: 6.0,
                  height: 6.0,
                  decoration: BoxDecoration(
                    color: isOfflineNode ? const Color(0xFF64748B) : AegisColors.activeGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5.0),
                Text(
                  isOfflineNode ? 'Offline' : 'Online  •  2 hops away',
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AegisColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Message List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: isOfflineNode
                    ? [
                        _buildIncomingBubble('Hello! Are you safe?', '10:18 AM'),
                        _buildOutgoingBubble('Yes, I\'m safe here.', '10:19 AM', doubleTickGreen: false),
                        _buildIncomingBubble('We need medical supplies.', '10:20 AM'),
                        _buildQueuedBubble('I can help. I have some basic medicines.', '10:21 AM'),
                      ]
                    : [
                        _buildIncomingBubble('Are you safe?', '10:21 AM'),
                        _buildOutgoingBubble('Yes, we are safe.', '10:22 AM'),
                        _buildHopPathIndicator('SIG-7F3A → SIG-B2C1 → SIG-8AF3'),
                        _buildIncomingBubble('Do you have any medical supplies?', '10:23 AM'),
                        _buildOutgoingBubble('Yes, we have some basic medications.', '10:24 AM'),
                        _buildHopPathIndicator('SIG-7F3A → SIG-B2C1 → SIG-8AF3'),
                        _buildWarningBubble('Can you send bandages?', '10:25 AM'),
                        _buildQueueIndicator(),
                      ],
              ),
            ),

            // Warning bottom message banner
            if (isOfflineNode)
              _buildQueuedMessageWarningBanner(),

            // Message Input Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: const BoxDecoration(
                color: Color(0xFF090D16),
                border: Border(
                  top: BorderSide(color: AegisColors.border, width: 1.0),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: AegisColors.cardBackground,
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: AegisColors.border, width: 1.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Row(
                        children: [
                          const Expanded(
                            child: TextField(
                              style: TextStyle(color: Colors.white, fontSize: 13.0),
                              decoration: InputDecoration(
                                hintText: 'Type a message...',
                                hintStyle: TextStyle(color: AegisColors.textMuted, fontSize: 13.0),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: const Color(0xFF161B22),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16.0),
                                    topRight: Radius.circular(16.0),
                                  ),
                                ),
                                builder: (context) => SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.file_present_rounded, color: AegisColors.busyPurple),
                                        title: const Text('Share File', style: TextStyle(color: Colors.white, fontSize: 14.0)),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => const ShareFileScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                      const Divider(color: Color(0xFF1E293B), height: 1.0),
                                      ListTile(
                                        leading: const Icon(Icons.mic_none_rounded, color: AegisColors.busyPurple),
                                        title: const Text('Voice Message', style: TextStyle(color: Colors.white, fontSize: 14.0)),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => const VoiceMessageScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.attach_file_rounded,
                              color: AegisColors.textSecondary,
                              size: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  // Send Button
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: const BoxDecoration(
                      color: AegisColors.activeGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 18.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomingBubble(String text, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0, right: 48.0),
        padding: const EdgeInsets.all(12.0),
        decoration: const BoxDecoration(
          color: Color(0xFF1E293B),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12.0),
            bottomLeft: Radius.circular(12.0),
            bottomRight: Radius.circular(12.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 13.0),
            ),
            const SizedBox(height: 4.0),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                time,
                style: const TextStyle(color: AegisColors.textMuted, fontSize: 9.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutgoingBubble(String text, String time, {bool doubleTickGreen = true}) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0, left: 48.0),
        padding: const EdgeInsets.all(12.0),
        decoration: const BoxDecoration(
          color: Color(0xFF064E3B),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            bottomLeft: Radius.circular(12.0),
            bottomRight: Radius.circular(12.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 13.0),
            ),
            const SizedBox(height: 4.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: const TextStyle(color: AegisColors.textSecondary, fontSize: 9.0),
                ),
                const SizedBox(width: 4.0),
                Icon(
                  Icons.done_all_rounded,
                  color: doubleTickGreen ? AegisColors.activeGreen : const Color(0xFF64748B),
                  size: 12.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueuedBubble(String text, String time) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0, left: 48.0),
        child: CustomPaint(
          painter: DashedRectPainter(
            color: const Color(0xFFD97706).withOpacity(0.65), // Orange/Brown border
            strokeWidth: 1.2,
          ),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: const BoxDecoration(
              color: Color(0xFF2D1F10), // Dark brown/orange bg matching mockup
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(12.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 13.0),
                ),
                const SizedBox(height: 6.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(color: AegisColors.textSecondary, fontSize: 9.0),
                    ),
                    const SizedBox(width: 4.0),
                    const Icon(
                      Icons.access_time_rounded,
                      color: AegisColors.warningOrange,
                      size: 11.0,
                    ),
                  ],
                ),
                const SizedBox(height: 2.0),
                const Text(
                  'Queued',
                  style: TextStyle(
                    color: AegisColors.warningOrange,
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQueuedMessageWarningBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      margin: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1710), // Dark orange/grey background matching mockup
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          color: const Color(0xFFD97706).withOpacity(0.35),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.access_time_rounded,
            color: AegisColors.warningOrange,
            size: 18.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Queued Message',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(height: 2.0),
                Text(
                  'Will deliver when SIG-4D2F comes back online.',
                  style: TextStyle(
                    color: AegisColors.textSecondary,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBubble(String text, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0, right: 48.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color(0xFF451A03),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12.0),
            bottomLeft: Radius.circular(12.0),
            bottomRight: Radius.circular(12.0),
          ),
          border: Border.all(color: AegisColors.warningOrange.withOpacity(0.4), width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 13.0),
            ),
            const SizedBox(height: 4.0),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                time,
                style: const TextStyle(color: AegisColors.textMuted, fontSize: 9.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHopPathIndicator(String path) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.check_circle_outline_rounded,
                color: AegisColors.activeGreen,
                size: 11.0,
              ),
              SizedBox(width: 4.0),
              Text(
                'via 2 hops',
                style: TextStyle(
                  color: AegisColors.activeGreen,
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2.0),
          Text(
            path,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AegisColors.textMuted,
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }

  Widget _buildQueueIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
      child: Row(
        children: const [
          Icon(
            Icons.hourglass_empty_rounded,
            color: AegisColors.warningOrange,
            size: 13.0,
          ),
          SizedBox(width: 6.0),
          Text(
            'Queued',
            style: TextStyle(
              color: AegisColors.warningOrange,
              fontSize: 11.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    path.addRRect(RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: const Radius.circular(12.0),
      bottomLeft: const Radius.circular(12.0),
      bottomRight: const Radius.circular(12.0),
    ));

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final double dashLength = 4.0;
    final double spaceLength = 3.0;

    for (final PathMetric metric in path.computeMetrics()) {
      double start = 0.0;
      while (start < metric.length) {
        final double end = (start + dashLength).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(start, end), paint);
        start += dashLength + spaceLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedRectPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}
