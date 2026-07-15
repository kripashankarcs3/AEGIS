import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import 'radar_screen.dart';
import 'chat_screen.dart';
import 'sos_screen.dart';
import 'resource_feed_screen.dart';
import 'network_map_screen.dart';

class MainShell extends StatefulWidget {
  final int initialTab;
  const MainShell({super.key, this.initialTab = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  final List<Widget> _screens = [
    const RadarScreen(),
    const ChatScreen(),
    const SosScreen(),
    const ResourceFeedScreen(),
    const NetworkMapScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: 72.0,
        decoration: const BoxDecoration(
          color: Color(0xFF090D16), // Dark background matching bottom nav bar
          border: Border(
            top: BorderSide(color: AegisColors.border, width: 1.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              index: 0,
              icon: Icons.radar_rounded,
              label: 'Radar',
            ),
            _buildNavItem(
              index: 1,
              icon: Icons.chat_bubble_outline_rounded,
              label: 'Chat',
            ),
            // Centered SOS Custom Button
            _buildSosNavItem(),
            _buildNavItem(
              index: 3,
              icon: Icons.library_books_outlined,
              label: 'Resources',
            ),
            _buildNavItem(
              index: 4,
              icon: Icons.map_outlined,
              label: 'Map',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = _currentIndex == index;
    final Color color = isSelected ? AegisColors.activeGreen : AegisColors.textMuted;
    
    return Expanded(
      child: InkWell(
        onTap: () => _onTabTapped(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 20.0,
            ),
            const SizedBox(height: 4.0),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 9.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSosNavItem() {
    final bool isSelected = _currentIndex == 2;
    
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: () => _onTabTapped(2),
          child: Container(
            width: 44.0,
            height: 44.0,
            decoration: BoxDecoration(
              color: AegisColors.sosRed,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AegisColors.sosRed.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
              border: isSelected 
                  ? Border.all(color: Colors.white, width: 2.0) 
                  : null,
            ),
            child: const Center(
              child: Text(
                'SOS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
