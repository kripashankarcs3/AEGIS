import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/aegis_colors.dart';
import '../providers/mesh_provider.dart';
import '../providers/identity_provider.dart';
import '../models/signal_packet.dart';

class BroadcastScreen extends ConsumerStatefulWidget {
  const BroadcastScreen({super.key});

  @override
  ConsumerState<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends ConsumerState<BroadcastScreen> {
  int _selectedAudience = 1;
  int _selectedPriority = 2;
  final TextEditingController _messageController = TextEditingController();
  int _charCount = 0;

  final List<Map<String, String>> _audiences = [
    {'title': 'Everyone', 'sub': 'All nodes in range'},
    {'title': 'Nearby Devices', 'sub': 'Within 3 hops'},
    {'title': 'Medical Volunteers', 'sub': 'Only verified'},
    {'title': 'Rescue Teams', 'sub': 'Only rescue nodes'},
    {'title': 'Shelter Leaders', 'sub': 'Only shelter nodes'},
  ];

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {
        _charCount = _messageController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendBroadcast() {
    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message')),
      );
      return;
    }

    final sigId = ref.read(sigIdProvider);
    final audience = _audiences[_selectedAudience]['title'] ?? 'Everyone';

    final packet = SignalPacket(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      from: sigId,
      to: 'broadcast',
      type: PacketType.status,
      payload: message,
      ttl: 8,
      hopCount: 0,
      path: [sigId],
      timestamp: DateTime.now(),
    );

    ref.read(meshProvider.notifier).sendPacket(packet);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Broadcast sent to $audience nodes')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AegisColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Broadcast',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: AegisColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline_rounded, color: AegisColors.textPrimary, size: 22.0),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1B4B),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AegisColors.violet.withOpacity(0.3), width: 1.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Broadcast Message',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Send important updates to all\nnearby nodes in range.',
                              style: TextStyle(
                                color: AegisColors.textSecondary,
                                fontSize: 11.5,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.0),
                      Container(
                        width: 38.0,
                        height: 38.0,
                        decoration: BoxDecoration(
                          color: AegisColors.violet.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.podcasts_rounded,
                          color: AegisColors.violet,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),

                Text(
                  'Who should receive?',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: AegisColors.textSecondary,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  decoration: BoxDecoration(
                    color: AegisColors.cardBg,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AegisColors.border1, width: 1.0),
                  ),
                  child: Column(
                    children: List.generate(_audiences.length, (index) {
                      return Column(
                        children: [
                          _buildAudienceRow(index),
                          if (index < _audiences.length - 1)
                            Divider(color: AegisColors.border1, height: 1.0, thickness: 0.5),
                        ],
                      );
                    }),
                  ),
                ),
                SizedBox(height: 20.0),

                Text(
                  'Message',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: AegisColors.textSecondary,
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: AegisColors.cardBg,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AegisColors.border1, width: 1.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                        controller: _messageController,
                        maxLines: 3,
                        maxLength: 200,
                        style: TextStyle(color: AegisColors.textPrimary, fontSize: 13.0),
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(color: AegisColors.textMuted, fontSize: 13.0),
                          border: InputBorder.none,
                          counterText: '',
                          isDense: true,
                        ),
                      ),
                      Text(
                        '$_charCount/200',
                        style: TextStyle(color: AegisColors.textMuted, fontSize: 10.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),

                Text(
                  'Priority',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: AegisColors.textSecondary,
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPriorityButton(0, 'Low'),
                    _buildPriorityButton(1, 'Medium'),
                    _buildPriorityButton(2, 'High'),
                  ],
                ),
                SizedBox(height: 32.0),

                Container(
                  width: double.infinity,
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: AegisColors.violet,
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: [
                      BoxShadow(
                        color: AegisColors.violet.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: _sendBroadcast,
                    borderRadius: BorderRadius.circular(6.0),
                    child: Center(
                      child: Text(
                        'SEND BROADCAST',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAudienceRow(int index) {
    final bool isSelected = _selectedAudience == index;
    final audience = _audiences[index];

    return InkWell(
      onTap: () {
        setState(() {
          _selectedAudience = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        child: Row(
          children: [
            Container(
              width: 18.0,
              height: 18.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AegisColors.violet : AegisColors.textMuted,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          color: AegisColors.violet,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    audience['title']!,
                    style: TextStyle(
                      fontSize: 13.0,
                      color: AegisColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    audience['sub']!,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: AegisColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 18.0,
                height: 18.0,
                decoration: const BoxDecoration(
                  color: AegisColors.neonGreen,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 12.0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityButton(int index, String label) {
    final bool isSelected = _selectedPriority == index;
    final Color strokeColor = isSelected ? AegisColors.sosRed : AegisColors.border1;
    final Color textColor = isSelected ? AegisColors.sosRed : AegisColors.textSecondary;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPriority = index;
          });
        },
        child: Container(
          margin: EdgeInsets.only(
            left: index == 0 ? 0.0 : 6.0,
            right: index == 2 ? 0.0 : 6.0,
          ),
          height: 38.0,
          decoration: BoxDecoration(
            color: isSelected ? AegisColors.sosRed.withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(color: strokeColor, width: 1.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 12.0,
                height: 12.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: strokeColor, width: 1.0),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 6.0,
                          height: 6.0,
                          decoration: const BoxDecoration(
                            color: AegisColors.sosRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 8.0),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
