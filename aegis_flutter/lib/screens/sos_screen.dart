import 'package:flutter/material.dart';
import '../constants/aegis_colors.dart';
import '../widgets/sos_banner.dart';
import 'status_history_screen.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AegisColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Header Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.shield_outlined,
                          color: AegisColors.sosRed,
                          size: 26.0,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'SOS',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.history_rounded, color: Colors.white, size: 22.0),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),

                // 2. Sub-bar Status Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 8 Nodes Badge
                    Row(
                      children: [
                        Container(
                          width: 6.0,
                          height: 6.0,
                          decoration: const BoxDecoration(
                            color: AegisColors.activeGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        const Text(
                          '8 Nodes Online',
                          style: TextStyle(
                            color: AegisColors.textSecondary,
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // 127 Relayed
                    Row(
                      children: const [
                        Icon(
                          Icons.wifi_tethering_rounded,
                          color: AegisColors.textSecondary,
                          size: 13.0,
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          '127 Relayed',
                          style: TextStyle(
                            color: AegisColors.textSecondary,
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),

                // 3. Central Glowing SOS hold broadcast card
                const SosBroadcastCard(countdownText: '05:00'),
                const SizedBox(height: 24.0),

                // 4. Select Category Section
                const Text(
                  'SELECT CATEGORY',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: AegisColors.textMuted,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCategoryButton(0, Icons.add_rounded, 'Medical', AegisColors.sosRed),
                    _buildCategoryButton(1, Icons.person_rounded, 'Injury', Colors.white),
                    _buildCategoryButton(2, Icons.local_fire_department_rounded, 'Fire', Colors.white),
                    _buildCategoryButton(3, Icons.restaurant_rounded, 'Food', Colors.white),
                    _buildCategoryButton(4, Icons.more_horiz_rounded, 'Other', Colors.white),
                  ],
                ),
                const SizedBox(height: 28.0),

                // 5. Recent SOS Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'RECENT SOS',
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const StatusHistoryScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'View all',
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                          color: AegisColors.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12.0),

                // 6. Recent SOS list
                _buildRecentSosTile(
                  icon: Icons.add_rounded,
                  nodeId: 'SIG-1D9A',
                  issue: 'Medical Assistance',
                  time: '2 min ago',
                  hops: '2 hops',
                ),
                _buildDivider(),
                _buildRecentSosTile(
                  icon: Icons.local_fire_department_rounded,
                  nodeId: 'SIG-3C7E',
                  issue: 'Fire Emergency',
                  time: '15 min ago',
                  hops: '3 hops',
                ),
                _buildDivider(),
                _buildRecentSosTile(
                  icon: Icons.restaurant_rounded,
                  nodeId: 'SIG-9E10',
                  issue: 'Food Needed',
                  time: '32 min ago',
                  hops: '1 hop',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(int index, IconData icon, String label, Color activeColor) {
    final bool isSelected = _selectedCategory == index;
    final Color strokeColor = isSelected ? AegisColors.sosRed : const Color(0xFF1E293B);
    final Color contentColor = isSelected ? AegisColors.sosRed : AegisColors.textSecondary;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42.0,
            height: 42.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: strokeColor, width: 1.5),
              color: isSelected ? AegisColors.sosRed.withOpacity(0.1) : Colors.transparent,
            ),
            child: Icon(
              icon,
              color: contentColor,
              size: 20.0,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.0,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: contentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSosTile({
    required IconData icon,
    required String nodeId,
    required String issue,
    required String time,
    required String hops,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          // Red circle badge icon
          Container(
            width: 32.0,
            height: 32.0,
            decoration: const BoxDecoration(
              color: Color(0xFF3B1212),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AegisColors.sosRed,
              size: 16.0,
            ),
          ),
          const SizedBox(width: 12.0),
          // Info Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nodeId,
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  issue,
                  style: const TextStyle(
                    fontSize: 11.0,
                    color: AegisColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Duration & hops
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 10.0,
                  color: AegisColors.textMuted,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    hops,
                    style: const TextStyle(
                      fontSize: 10.0,
                      color: AegisColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 2.0),
                  const Icon(
                    Icons.chevron_right,
                    size: 12.0,
                    color: AegisColors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ],
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
