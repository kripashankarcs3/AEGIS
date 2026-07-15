import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'chat_conversation_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Top Header Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ENCRYPTED CHAT',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.search_rounded, color: Colors.white, size: 22.0),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.tune_rounded, color: Colors.white, size: 22.0),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  // 2. Tabs Row
                  Row(
                    children: [
                      _buildTabItem(0, 'All Chats'),
                      _buildTabItem(1, 'Nearby'),
                      _buildTabItem(2, 'Groups'),
                    ],
                  ),
                  const SizedBox(height: 16.0),

                  // 3. Chat List
                  Expanded(
                    child: ListView(
                      children: [
                        _buildChatTile(
                          avatarColor: AegisColors.busyPurple,
                          nodeId: 'SIG-8AF3',
                          time: '10:24 AM',
                          subtitle: 'All good here. We have supplies.',
                          unreadCount: 2,
                          unreadColor: AegisColors.busyPurple,
                        ),
                        _buildDivider(),
                        _buildChatTile(
                          avatarColor: AegisColors.sosRed,
                          nodeId: 'SIG-4D2F',
                          time: '10:18 AM',
                          subtitle: 'Need medical assistance.',
                          unreadCount: 1,
                          unreadColor: AegisColors.sosRed,
                        ),
                        _buildDivider(),
                        _buildChatTile(
                          avatarColor: AegisColors.activeGreen,
                          nodeId: 'SIG-1A9D',
                          time: '9:56 AM',
                          subtitle: 'How many people in your group?',
                        ),
                        _buildDivider(),
                        _buildChatTile(
                          avatarColor: AegisColors.primaryBlue,
                          nodeId: 'SIG-B2C1',
                          time: '9:41 AM',
                          subtitle: 'Water available. 2 bottles left.',
                          hasStatusDot: true,
                        ),
                        _buildDivider(),
                        _buildChatTile(
                          avatarColor: AegisColors.busyPurple,
                          nodeId: 'SIG-3C7E',
                          time: '9:32 AM',
                          subtitle: 'Heading north. Roads blocked.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Purple FAB button on the bottom right (raised above bottom nav bar)
            Positioned(
              right: 16.0,
              bottom: 16.0,
              child: FloatingActionButton(
                backgroundColor: AegisColors.busyPurple,
                shape: const CircleBorder(),
                elevation: 4.0,
                onPressed: () {},
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 26.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 24.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          border: isSelected
              ? const Border(
                  bottom: BorderSide(
                    color: AegisColors.activeGreen,
                    width: 2.5,
                  ),
                )
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AegisColors.textMuted,
            fontSize: 13.0,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildChatTile({
    required Color avatarColor,
    required String nodeId,
    required String time,
    required String subtitle,
    int unreadCount = 0,
    Color unreadColor = AegisColors.busyPurple,
    bool hasStatusDot = false,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatConversationScreen(nodeId: nodeId),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
        child: Row(
          children: [
            // Avatar circle
            Container(
              width: 44.0,
              height: 44.0,
              decoration: BoxDecoration(
                color: avatarColor.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: avatarColor.withOpacity(0.3), width: 1.0),
              ),
              child: Icon(
                Icons.person_rounded,
                color: avatarColor,
                size: 22.0,
              ),
            ),
            const SizedBox(width: 14.0),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        nodeId,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AegisColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      if (hasStatusDot) ...[
                        Container(
                          width: 6.0,
                          height: 6.0,
                          decoration: const BoxDecoration(
                            color: AegisColors.activeGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6.0),
                      ],
                      Expanded(
                        child: Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: AegisColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unreadCount > 0) ...[
                        const SizedBox(width: 8.0),
                        Container(
                          padding: const EdgeInsets.all(5.5),
                          decoration: BoxDecoration(
                            color: unreadColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildDivider() {
    return const Divider(
      color: Color(0xFF1E293B),
      height: 1.0,
      thickness: 0.5,
    );
  }
}
