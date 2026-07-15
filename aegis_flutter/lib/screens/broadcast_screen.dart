import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';

class BroadcastScreen extends StatefulWidget {
  const BroadcastScreen({super.key});

  @override
  State<BroadcastScreen> createState() => _BroadcastScreenState();
}

class _BroadcastScreenState extends State<BroadcastScreen> {
  int _selectedAudience = 1; // Default to Nearby Devices
  int _selectedPriority = 2; // Default to High

  final List<Map<String, String>> _audiences = const [
    {'title': 'Everyone', 'sub': 'All nodes in range'},
    {'title': 'Nearby Devices', 'sub': 'Within 3 hops'},
    {'title': 'Medical Volunteers', 'sub': 'Only verified'},
    {'title': 'Rescue Teams', 'sub': 'Only rescue nodes'},
    {'title': 'Shelter Leaders', 'sub': 'Only shelter nodes'},
  ];

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
          'Broadcast',
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Broadcast Message Banner Card
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1B4B), // Dark Indigo/Purple card
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AegisColors.busyPurple.withOpacity(0.3), width: 1.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
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
                      const SizedBox(width: 12.0),
                      Container(
                        width: 38.0,
                        height: 38.0,
                        decoration: BoxDecoration(
                          color: AegisColors.busyPurple.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.podcasts_rounded,
                          color: AegisColors.busyPurple,
                          size: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),

                // 2. Who should receive? Section
                const Text(
                  'Who should receive?',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: AegisColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  decoration: BoxDecoration(
                    color: AegisColors.cardBackground,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: AegisColors.border, width: 1.0),
                  ),
                  child: Column(
                    children: List.generate(_audiences.length, (index) {
                      return Column(
                        children: [
                          _buildAudienceRow(index),
                          if (index < _audiences.length - 1)
                            const Divider(color: Color(0xFF1E293B), height: 1.0, thickness: 0.5),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20.0),

                // 3. Message Section
                const Text(
                  'Message',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: AegisColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: AegisColors.cardBackground,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AegisColors.border, width: 1.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      TextField(
                        maxLines: 3,
                        maxLength: 200,
                        style: TextStyle(color: Colors.white, fontSize: 13.0),
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(color: AegisColors.textMuted, fontSize: 13.0),
                          border: InputBorder.none,
                          counterText: '',
                          isDense: true,
                        ),
                        controller: null, // Let it be default
                      ),
                      Text(
                        '62/200',
                        style: TextStyle(color: AegisColors.textMuted, fontSize: 10.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),

                // 4. Priority Section
                const Text(
                  'Priority',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: AegisColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPriorityButton(0, 'Low'),
                    _buildPriorityButton(1, 'Medium'),
                    _buildPriorityButton(2, 'High'),
                  ],
                ),
                const SizedBox(height: 32.0),

                // 5. Send Broadcast Action Button
                Container(
                  width: double.infinity,
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: AegisColors.busyPurple,
                    borderRadius: BorderRadius.circular(6.0),
                    boxShadow: [
                      BoxShadow(
                        color: AegisColors.busyPurple.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(6.0),
                    child: const Center(
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
            // Checkbox indicator on the left
            Container(
              width: 18.0,
              height: 18.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AegisColors.busyPurple : AegisColors.textMuted,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: const BoxDecoration(
                          color: AegisColors.busyPurple,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12.0),
            // Title and Subtitle details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    audience['title']!,
                    style: const TextStyle(
                      fontSize: 13.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    audience['sub']!,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AegisColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            // Selected Green Check Badge on the right
            if (isSelected)
              Container(
                width: 18.0,
                height: 18.0,
                decoration: const BoxDecoration(
                  color: AegisColors.activeGreen,
                  shape: BoxShape.circle,
                ),
                child: const Center(
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
    final Color strokeColor = isSelected ? AegisColors.sosRed : const Color(0xFF1E293B);
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
              // Circular radio/dot indicator
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
              const SizedBox(width: 8.0),
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
